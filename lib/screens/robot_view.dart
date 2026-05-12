import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/robot_model.dart';
import 'package:rui/data/robot_status_view_model.dart';
import 'package:rui/screens/app_constants.dart';
import 'package:rui/screens/labels.dart';
import 'package:rui/screens/map_display.dart';
import 'package:rui/screens/popovers.dart';
import 'package:rui/screens/robot_status_panel.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// @Preview(name: 'Robot Dashboard')
// Widget robotDashboard() {
//   final rm = RobotModel();
//   final vm = RobotStatusViewModel(robotModel: rm);
//   return RobotDashboard(robotStatusViewModel: vm);
// }

// @Preview(name: 'Robot Maps')
// Widget robotMaps() {
//   final rm = RobotModel();
//   final vm = RobotStatusViewModel(robotModel: rm);
//   return ShadApp(
//     builder: (context, app) {
//       return _RobotMaps(robotStatusViewModel: vm);
//     }
//   );
// }

@Preview(name: 'Quick Actions Panel')
Widget quickActionsPael() {
  return ShadApp(
    builder: (context, app) {
      return NavActionsPanel();
    }
  );
}

class RobotMainView extends StatefulWidget {
  const RobotMainView({super.key});

  @override
  State<StatefulWidget> createState() => _RobotMainView();
}

class _RobotMainView extends State<RobotMainView> {
  _RobotMainView() : robotModel = RobotModel() {
    robotStatusViewModel = RobotStatusViewModel(robotModel: robotModel);
  }

  RobotModel robotModel;
  late RobotStatusViewModel robotStatusViewModel;
  static const List<Tab> tabsList = <Tab>[
    Tab(text: 'Dashboard',),
    Tab(text: 'Waypoints',),
    Tab(text: 'Maps',),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabsList.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90.0,
          title: RobotHeaderView(robotStatusViewModel: robotStatusViewModel),
          bottom: const TabBar(
            textScaler: TextScaler.linear(1.52),
            tabs: tabsList
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: TabBarView(
                    children: [
                      RobotDashboard(robotStatusViewModel: robotStatusViewModel),
                      RobotWaypoints(),
                      _RobotMaps(robotStatusViewModel: robotStatusViewModel),
                    ]
                  ),
                )
              ),
              RobotStatusFooterView(robotStatusViewModel: robotStatusViewModel)
            ],
          ),
        )
      )
    );
  }
}

class RobotHeaderView extends StatelessWidget {
  const RobotHeaderView({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: AppSpacing.sm,
          children: [
            Icon(
              Icons.computer,
              color: Colors.cyan,
              size: 48.0,
              semanticLabel: "App icon.",
            ),
            Expanded(
              child: Text('Robot Command & Control'),
            ),
            ConnectRobotPopover(
              onConnectPressed: (host, port) {
                robotStatusViewModel.connectToRobot(host, port);
              },
              onDisconnectPressed: () {
                robotStatusViewModel.disconnectRobot();
              },
              onCancelPressed: () {},
              connectedNotifier: robotStatusViewModel.connectionNotifier,
            )
          ],
        ),
        ShadSeparator.horizontal()
      ],
    );
  }
}

class RobotStatusFooterView extends StatefulWidget {
  const RobotStatusFooterView({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  State<StatefulWidget> createState() => _RobotStatusFooterViewState();
}

class _RobotStatusFooterViewState extends State<RobotStatusFooterView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
        child: Row(
        spacing: AppSpacing.sm,
        children: [
          ValueListenableBuilder<RobotConnectionStatus>(
            valueListenable: widget.robotStatusViewModel.connectionNotifier,
            builder: (context, connection, child) {
              return ConnectionStatusLabel(status: connection);
            }
          ),
          ValueListenableBuilder<AutonomyStatus>(
            valueListenable: widget.robotStatusViewModel.autonomyNotifier,
            builder: (context, autonomy, child) {
              return AutonomyStatusLabel(status: autonomy);
            }
          ),
          ValueListenableBuilder<BatteryState>(
            valueListenable: widget.robotStatusViewModel.batteryStateNotifier,
            builder: (context, battery, child) {
              return BatteryStateLabel(state: battery);
            }
          ),
        ],
      )
    );
  }
}

class RobotDashboard extends StatefulWidget {
  const RobotDashboard({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  State<StatefulWidget> createState() => _RobotDashboard();
}

class _RobotDashboard extends State<RobotDashboard> {
  @override
  void initState() {
    super.initState();
    widget.robotStatusViewModel.fetchCurrentMap();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: ClipRect(
              child: ListenableBuilder(
                listenable: widget.robotStatusViewModel.currentMapNotifier,
                builder: (context, child) {
                  return MapDisplay(
                    mapData: widget.robotStatusViewModel.currentMapNotifier.value,
                    mapMarkers: [
                      HomeMarker(pose: ValueNotifier(widget.robotStatusViewModel.currentMapNotifier.value.home)), // TODO: Temp.
                      RobotMarker(pose: widget.robotStatusViewModel.robotPoseNotifier),
                    ],
                  );
                },
              ),
            )
          )
        ),
        ShadSeparator.vertical(),
        SizedBox(
          width: 300,
          child: Column(
            spacing: AppSpacing.md,
            children: [
              RobotStatusPanel(robotStatusViewModel: widget.robotStatusViewModel),
              MapActionsPanel(),
              NavActionsPanel()
            ],
          )
        )
      ],
    );
  }
}

class MapActionsPanel extends StatelessWidget {
  const MapActionsPanel({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.sm,
      children: [
        Container(
          alignment: AlignmentGeometry.bottomLeft,
          child: Text('Map Actions', style: ShadTheme.of(context).textTheme.h4),
        ),
        ShadSeparator.horizontal(margin: EdgeInsets.zero),
        SizedBox(
          width: double.infinity,
          child: ShadButton.outline(
            leading: Icon(Icons.location_searching, size: IconSize.sm),
            onPressed: () {
              ShadToaster.of(context).show(ShadToast(title: Text('Not yet implemented.'), alignment: Alignment.bottomCenter,));
            },
            child: Text('Localize', style: ShadTheme.of(context).textTheme.large),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ShadButton.outline(
            leading: Icon(Icons.map, size: IconSize.sm),
            onPressed: () {
              ShadToaster.of(context).show(ShadToast(title: Text('Not yet implemented.'), alignment: Alignment.bottomCenter,));
            },
            child: Text('Load Map', style: ShadTheme.of(context).textTheme.large),
          ),
        ),
      ],
    );
  }
}

class NavActionsPanel extends StatelessWidget {
  const NavActionsPanel({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.sm,
      children: [
        Container(
          alignment: AlignmentGeometry.bottomLeft,
          child: Text('Navigate Actions', style: ShadTheme.of(context).textTheme.h4),
        ),
        ShadSeparator.horizontal(margin: EdgeInsets.zero),
        SizedBox(
          width: double.infinity,
          child: ShadButton.outline(
            leading: Icon(Icons.navigation, size: IconSize.sm),
            onPressed: () {
              ShadToaster.of(context).show(ShadToast(title: Text('Not yet implemented.'), alignment: Alignment.bottomCenter,));
            },
            child: Text('Go To', style: ShadTheme.of(context).textTheme.large),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ShadButton.outline(
            leading: Icon(Icons.home, size: IconSize.sm),
            onPressed: () {
              ShadToaster.of(context).show(ShadToast(title: Text('Not yet implemented.'), alignment: Alignment.bottomCenter,));
            },
            child: Text('Go Home', style: ShadTheme.of(context).textTheme.large),
          ),
        ),
      ],
    );
  }
}

class RobotWaypoints extends StatelessWidget {
  const RobotWaypoints({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Waypoints View')
    );
  }
}

class _RobotMaps extends StatefulWidget {
  const _RobotMaps({
    required this.robotStatusViewModel
  });

  final RobotStatusViewModel robotStatusViewModel;

  @override
  State<StatefulWidget> createState() => _RobotMapsState();
}

class _RobotMapsState extends State<_RobotMaps> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      height: 700,
      child: Column(
        children: [
          _RobotMapsHeader(mapStatus: widget.robotStatusViewModel.mapStatusNotifier),
          Expanded(
            child: _RobotMapsGrid(mapStatusNotifier: widget.robotStatusViewModel.mapStatusNotifier),
          )
        ],
      )
    );
  }
}

class _RobotMapsHeader extends StatefulWidget {
  const _RobotMapsHeader({
    super.key,
    required this.mapStatus
  });

  final ValueNotifier<MapStatus> mapStatus;

  @override
  State<StatefulWidget> createState() => _RobotMapsHeaderState();
}

class _RobotMapsHeaderState extends State<_RobotMapsHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: AppSpacing.sm,
          children: [
            Expanded(
              child: Text('${widget.mapStatus.value.mapsList.length} maps available'),
            ),
            ShadButton.outline(
              leading: Icon(Icons.upload),
              onPressed: () {
                ShadToaster.of(context).show(
                  ShadToast(
                    title: const Text('TODO: Import map to robot'),
                    alignment: Alignment.bottomCenter
                  ),
                );
              },
              child: Text('Import'),
            ),
            ShadButton.outline(
              leading: Icon(Icons.download),
              onPressed: () {
                ShadToaster.of(context).show(
                  ShadToast(
                    title: const Text('TODO: Export map from robot'),
                    alignment: Alignment.bottomCenter
                  ),
                );
              },
              child: Text('Export'),
            )
          ],
        ),
        SizedBox(height: AppSpacing.sm)
      ],
    );
  }
}

class _RobotMapsGrid extends StatefulWidget {
  const _RobotMapsGrid({
    required this.mapStatusNotifier
  });

  final ValueNotifier<MapStatus> mapStatusNotifier;

  @override
  State<StatefulWidget> createState() => _RobotMapsGridState();
}

class _RobotMapsGridState extends State<_RobotMapsGrid> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _selectedNotifier = ValueNotifier(MapInfo());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _selectedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      children: [
        Expanded(
          child: GridView.count(
            padding: EdgeInsets.only(right: AppSpacing.lg),
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            crossAxisCount: 5,
            scrollDirection: Axis.vertical,
            children: [
              ...widget.mapStatusNotifier.value.mapsList.map((map) {
                return ShadContextMenuRegion(
                  items: [
                    ShadContextMenuItem.inset(child: Text('Load')),
                    ShadContextMenuItem.inset(child: Text('Edit')),
                  ],
                  child: ShadGestureDetector(
                    onTap: () => _selectedNotifier.value = map,
                    onDoubleTap: () {
                      // TODO: Open map display.
                    },
                    child: ShadCard(
                      title: Text(map.name),
                      description: Text(map.description, maxLines: 2, overflow: TextOverflow.fade),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CustomPaint(
                            // TODO: Temporary draw the same map image until we figure out how to receive image over the network.
                            size: Size(widget.mapStatusNotifier.value.currentMap.width, widget.mapStatusNotifier.value.currentMap.height),
                            painter: MapPainter(mapImage: widget.mapStatusNotifier.value.currentMap.mapImage),
                          ),
                        )
                      )
                    ),
                  )
                );
              })
            ],
          )
        ),
        ShadSeparator.vertical(),
        MapInfoPanel(mapInfoNotifier: _selectedNotifier, width: 400),
      ],
    );
  }
}

class MapInfoPanel extends StatefulWidget {
  const MapInfoPanel({
    super.key,
    required this.mapInfoNotifier,
    this.width
  });

  final ValueNotifier<MapInfo> mapInfoNotifier;
  final double? width;

  @override
  State<StatefulWidget> createState() => _MapInfoPanelState();
}

class _MapInfoPanelState extends State<MapInfoPanel> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.mapInfoNotifier,
      builder: (context, value, child) {
        return AnimatedSwitcher(
          duration: AppAnimate.short,
          child: ShadCard(
            width: widget.width,
            key: ValueKey(value),
            title: SelectableText(widget.mapInfoNotifier.value.name),
            description: SelectableText(widget.mapInfoNotifier.value.description, maxLines: 4),
            child: Column(
              children: [
                if (value.name.isEmpty)
                  Center(
                    child: Text('Select a map', style: Theme.of(context).textTheme.titleLarge),
                  ),
                if (value.name.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.md),
                  Tooltip(
                    message: 'Click to inspect (TODO)',
                    child: ShadGestureDetector(
                      onTap: (){
                        // TODO: Open up the map display.
                      },
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: CustomPaint(
                          // TODO: Temporary draw the same map image until we figure out how to receive image over the network.
                          size: Size(widget.mapInfoNotifier.value.width, widget.mapInfoNotifier.value.height),
                          painter: MapPainter(mapImage: widget.mapInfoNotifier.value.mapImage),
                        ),
                      )
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: ShadTable.list(
                      columnSpanExtent: (column) {
                        if (column == 0) {
                          return FixedTableSpanExtent(100);
                        } else {
                          return const RemainingTableSpanExtent();
                        }
                      },
                      rowSpanExtent: (row) {
                        if (row == 3 || row == 4) {
                          return FixedTableSpanExtent(70);
                        } else {
                          return FixedTableSpanExtent(30);
                        }
                      },
                      children: [
                        [ShadTableCell(child: Text('Resolution')), ShadTableCell(child: SelectableText(value.resolution.toStringAsFixed(2)))],
                        [ShadTableCell(child: Text('Width')), ShadTableCell(child: SelectableText(value.width.toString()))],
                        [ShadTableCell(child: Text('Height')), ShadTableCell(child: SelectableText(value.height.toString()))],
                        [ShadTableCell(child: Text('Origin')), ShadTableCell(child: SelectableText(value.origin.toString2D()))],
                        [ShadTableCell(child: Text('Home')), ShadTableCell(child: SelectableText(value.home.toString2D()))],
                      ]
                    ),
                  )
                ]
              ],
            ),
          )
        );
      }
    );
  }
}
