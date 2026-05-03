import '../data/robot_status_model.dart';
import 'labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: "Robot Status Panel")
Widget robotStatusPanel() {
  RobotStatusViewModel vm = RobotStatusViewModel();
  vm.connectionNotifier.value = RobotConnectionStatus.connected;
  vm.autonomyNotifier.value = AutonomyStatus.idle;
  vm.batteryStateNotifier.value = BatteryState(percentage: 47.0);
  return RobotStatusPanel(robotStatusViewModel: vm);
}

class RobotStatusPanel extends StatelessWidget {
  const RobotStatusPanel({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            alignment: Alignment.centerLeft,
            child: Text('Robot Status'),
          ),
          Divider(color: Colors.grey, thickness: 1.0, height: 1.0, indent: 8.0, endIndent: 8.0),
          FieldRow(
            iconData: Icons.wifi,
            name: 'Connection',
            dataWidget: ValueListenableBuilder<RobotConnectionStatus>(
              valueListenable: robotStatusViewModel.connectionNotifier,
              builder: (context, connection, child) {
                return ConnectionStatusLabel(status: connection);
              }
            )
          ),
          FieldRow(
            iconData: Icons.battery_std,
            name: 'Battery',
            dataWidget: ValueListenableBuilder<BatteryState>(
              valueListenable: robotStatusViewModel.batteryStateNotifier,
              builder: (context, battery, child) {
                return BatteryStateLabel(state: battery);
              }
            )
          ),
          FieldRow(
            iconData: Icons.drive_eta,
            name: 'Autonomy',
            dataWidget: ValueListenableBuilder<AutonomyStatus>(
              valueListenable: robotStatusViewModel.autonomyNotifier,
              builder: (context, autonomy, child) {
                return AutonomyStatusLabel(status: autonomy);
              },
            )
          ),
          FieldRow(
            iconData: Icons.my_location,
            name: 'Location',
            dataWidget: ValueListenableBuilder<LocationData>(
              valueListenable: robotStatusViewModel.locationNotifier,
              builder: (context, location, child) {
                return LocationLabel(locationData: location);
              }
            )
          )
        ]
      )
    );
  }
}

class FieldRow extends StatelessWidget {
  const FieldRow({
    required this.iconData,
    required this.name,
    required this.dataWidget,
    super.key
  });

  final IconData iconData;
  final String name;
  final Widget dataWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
      child: Row(
      spacing: 8.0,
      children: [
        Icon(iconData),
        Expanded(
          child: Text(name)
        ),
        Align(
          alignment: Alignment.centerRight,
          child: dataWidget,
        ),
      ],
    ));
  }
}
