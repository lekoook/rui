import 'package:flutter/widget_previews.dart';
import 'package:rui/data/robot_status_model.dart';

import 'map_display.dart';
import 'package:flutter/material.dart';
import 'robot_status_panel.dart';
import 'labels.dart';

@Preview(name: 'Robot Dashboard')
Widget robotDashboard() {
  RobotStatusViewModel vm = RobotStatusViewModel();
  return RobotDashboard(robotStatusViewModel: vm);
}

class RobotMainView extends StatelessWidget {
  RobotMainView({super.key}) :
    _robotStatusViewModel = RobotStatusViewModel();

  final RobotStatusViewModel _robotStatusViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RobotHeaderView(robotStatusViewModel: _robotStatusViewModel),
        Divider(indent: 4.0, endIndent: 4.0,),
        Expanded(
          child: RobotDashboard(robotStatusViewModel: _robotStatusViewModel)
        )
      ],
    );
  }
}

class RobotHeaderView extends StatelessWidget {
  const RobotHeaderView({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        spacing: 16.0,
        children: [
          Icon(
            Icons.computer,
            color: Colors.black,
            size: 48.0,
            semanticLabel: "App icon.",
          ),
          Expanded(
            child: Text('Robot Command & Control', style: TextStyle(fontSize: 36.0))
          ),
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
        ]
      ),
    );
  }
}

class RobotDashboard extends StatelessWidget {
  const RobotDashboard({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: MapDisplay()
        ),
        RobotStatusPanel(robotStatusViewModel: robotStatusViewModel),
      ],
    );
  }
}
