import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/robot_model.dart';
import 'package:rui/data/robot_view_model.dart';
import 'package:rui/screens/app_constants.dart';
import 'package:rui/screens/map_display.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@Preview(name: 'Robot Maps')
Widget robotMapsTab() {
  final rm = RobotModel();
  final vm = RobotViewModel(robotModel: rm);
  return ShadApp(
    builder: (context, app) {
      return RobotMapsTab(robotStatusViewModel: vm);
    }
  );
}

class RobotMapsTab extends StatefulWidget {
  const RobotMapsTab({
    super.key,
    required this.robotStatusViewModel
  });

  final RobotViewModel robotStatusViewModel;

  @override
  State<StatefulWidget> createState() => _RobotMapsTabState();
}

class _RobotMapsTabState extends State<RobotMapsTab> {
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
          child: widget.mapStatusNotifier.value.mapsList.isEmpty
          ? Center(child: Text('No maps to show', style: ShadTheme.of(context).textTheme.h3))
          : GridView.count(
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
                    child: Text('Select a map', style: ShadTheme.of(context).textTheme.h3),
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
