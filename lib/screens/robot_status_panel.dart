import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/geometry_msgs.dart';
import 'package:rui/data/sensor_msgs.dart';
import 'package:rui/data/std_msgs.dart';
import 'package:rui/data/robot_model.dart';
import 'package:rui/data/robot_view_model.dart';
import 'package:rui/screens/app_constants.dart';
import 'package:rui/screens/labels.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@Preview(name: "Robot Status Panel")
Widget robotStatusPanel() {
  final rm = RobotModel();
  final vm = RobotViewModel(robotModel: rm);
  vm.connectionNotifier.value = RobotConnectionStatus.connected;
  vm.autonomyNotifier.value = AutonomyStatus.idle;
  vm.batteryStateNotifier.value = const BatteryState(
    header: Header.zero(),
    voltage: 0, temperature: 0, current: 0, charge: 0, capacity: 0,
    designCapacity: 0, percentage: 47.0, powerSupplyStatus: PowerSupplyStatus.unknown,
    powerSupplyHealth: PowerSupplyHealth.unknown, powerSupplyTechnology: PowerSupplyTechnology.unknown, present: false,
    cellVoltage: [], cellTemperature: [], location: '', serialNumber: '',
  );
  return RobotStatusPanel(robotStatusViewModel: vm);
}

class RobotStatusPanel extends StatelessWidget {
  const RobotStatusPanel({required this.robotStatusViewModel, super.key});

  final RobotViewModel robotStatusViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.sm,
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          child: Text('Robot Status', style: ShadTheme.of(context).textTheme.h4),
        ),
        ShadSeparator.horizontal(margin: EdgeInsets.zero),
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
          dataWidget: ValueListenableBuilder<Pose>(
            valueListenable: robotStatusViewModel.robotPoseNotifier,
            builder: (context, location, child) {
              return LocationLabel(locationData: location);
            }
          )
        )
      ]
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
    return Row(
      children: [
        Expanded(
          child: TextWithIcon(text: name, icon: Icon(iconData), style: ShadTheme.of(context).textTheme.p),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: dataWidget,
        ),
      ],
    );
  }
}
