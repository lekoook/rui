import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/robot_model.dart';
import 'package:rui/data/robot_status_view_model.dart';
import 'package:rui/screens/app_constants.dart';
import 'package:rui/screens/labels.dart';
import 'package:rui/screens/map_display.dart';
import 'package:rui/screens/popovers.dart';
import 'package:rui/screens/robot_maps_tab.dart';
import 'package:rui/screens/robot_status_panel.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@Preview(name: 'Robot Dashboard')
Widget robotDashboard() {
  final rm = RobotModel();
  final vm = RobotStatusViewModel(robotModel: rm);
  return ShadApp(
    builder: (context, app) {
      return RobotDashboard(robotStatusViewModel: vm);
    }
  );
}

@Preview(name: 'Robot Maps')
Widget robotMapsTab() {
  final rm = RobotModel();
  final vm = RobotStatusViewModel(robotModel: rm);
  return ShadApp(
    builder: (context, app) {
      return RobotMapsTab(robotStatusViewModel: vm);
    }
  );
}

@Preview(name: 'Navigate Actions Panel')
Widget navActionsPael() {
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
                      RobotMapsTab(robotStatusViewModel: robotStatusViewModel),
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
