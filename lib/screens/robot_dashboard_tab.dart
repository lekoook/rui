import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:rui/data/geometry_msgs.dart';
import 'package:rui/data/robot_model.dart';
import 'package:rui/data/robot_view_model.dart';
import 'package:rui/screens/app_constants.dart';
import 'package:rui/screens/map_display.dart';
import 'package:rui/screens/robot_status_panel.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@Preview(name: 'Robot Dashboard')
Widget robotDashboard() {
  final rm = RobotModel();
  final vm = RobotViewModel(robotModel: rm);
  return ShadApp(
    builder: (context, app) {
      return RobotDashboardTab(robotStatusViewModel: vm);
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

class RobotDashboardTab extends StatefulWidget {
  const RobotDashboardTab({required this.robotStatusViewModel, super.key});

  final RobotViewModel robotStatusViewModel;

  @override
  State<StatefulWidget> createState() => _RobotDashboard();
}

class _RobotDashboard extends State<RobotDashboardTab> {
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
                      HomeMarker(pose: ValueNotifier(Pose(position: Point(x: -3, y: -3, z: 0), orientation: Quaternion.zero))), // TODO: Temp.
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
