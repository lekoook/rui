import 'package:flutter/widget_previews.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/robot_model.dart';
import 'package:rui/data/robot_status_view_model.dart';
import 'package:rui/screens/labels.dart';
import 'package:rui/screens/map_display.dart';
import 'package:rui/screens/robot_status_panel.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

@Preview(name: 'Robot Dashboard')
Widget robotDashboard() {
  final rm = RobotModel();
  final vm = RobotStatusViewModel(robotModel: rm);
  return RobotDashboard(robotStatusViewModel: vm);
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
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        RobotHeaderView(robotStatusViewModel: robotStatusViewModel),
        Divider()
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabList(
            index: _tabIndex,
            onChanged: (value) {
              setState(() {
                _tabIndex = value;
              });
            },
            children: [
              TabItem(child: TextWithIcon.iconData(text: 'Dashboard', iconData: Icons.dashboard)),
              TabItem(child: TextWithIcon.iconData(text: 'Waypoints', iconData: Icons.route)),
              TabItem(child: TextWithIcon.iconData(text: 'Map', iconData: Icons.map))
            ],
          ),
          const Gap(8),
          Expanded(
              child: IndexedStack(
              index: _tabIndex,
              children: [
                RobotDashboard(robotStatusViewModel: robotStatusViewModel),
                RobotWaypoints(),
                RobotMaps()
              ],
            ),
          )
        ],
      )
    );
  }
}

class RobotHeaderView extends StatelessWidget {
  const RobotHeaderView({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('RUI'),
      subtitle: Text('Robot Command & Control Interface'),
      leading: [
        Icon(
          Icons.computer,
          color: Colors.cyan,
          size: 48.0,
          semanticLabel: "App icon.",
        )
      ],
      trailing: [
        ValueListenableBuilder<RobotConnectionStatus>(
          valueListenable: robotStatusViewModel.connectionNotifier,
          builder: (context, connection, child) {
            return ConnectionStatusLabel(status: connection);
          }
        ),
        ValueListenableBuilder<BatteryState>(
          valueListenable: robotStatusViewModel.batteryStateNotifier,
          builder: (context, battery, child) {
            return BatteryStateLabel(state: battery);
          }
        ),
        ValueListenableBuilder<AutonomyStatus>(
          valueListenable: robotStatusViewModel.autonomyNotifier,
          builder: (context, autonomy, child) {
            return AutonomyStatusLabel(status: autonomy);
          }
        )
      ],
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
          child: ClipRect(
            child: ValueListenableBuilder(
              valueListenable: widget.robotStatusViewModel.currentMapNotifier,
              builder: (context, value, child) {
                return MapDisplay(mapData: value);
              }
            ),
          )
        ),
        RobotStatusPanel(robotStatusViewModel: widget.robotStatusViewModel),
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

class RobotMaps extends StatelessWidget {
  const RobotMaps({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Maps View')
    );
  }
}
