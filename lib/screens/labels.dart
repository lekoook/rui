import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/geometry_msgs.dart';
import 'package:rui/data/sensor_msgs.dart';

@Preview(name: "Text Label", group: 'Labels')
Widget textLabel() {
  return TextLabel(text: 'Test');
}

@Preview(name: "Connection Label", group: 'Labels')
Widget connectionLabel() {
  return ConnectionStatusLabel(status: RobotConnectionStatus.disconnected);
}

@Preview(name: "Autonomy Status Label", group: 'Labels')
Widget autonomyStatusLabel() {
  return AutonomyStatusLabel(status: AutonomyStatus.manual);
}

@Preview(name: 'Battery State Label', group: 'Labels')
Widget batteryStateLabel() {
  return BatteryStateLabel(state: BatteryState.zero());
}

@Preview(name: 'Text With Icon', group: 'TextWithIcon')
Widget textWithIcon() {
  return TextWithIcon(text: 'Location', icon: Icon(Icons.my_location));
}

class TextLabel extends StatelessWidget {
  const TextLabel({
    required this.text,
    this.color,
    this.style,
    super.key
  });

  final String text;
  final Color? color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
      decoration: ShapeDecoration(
        color: color ?? Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        )
      ),
      child: Text(text, style: style)
    );
  }
}

class IconLabel extends StatelessWidget {
  const IconLabel({
    required this.icon,
    required this.text,
    this.iconRotations = 0,
    this.style,
    super.key
  });

  final IconData icon;
  final int iconRotations;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.0,
      children: [
        Text(text, style: style),
        RotatedBox(
          quarterTurns: iconRotations,
          child: Icon(icon),
        )
      ],
    );
  }
}

class ConnectionStatusLabel extends TextLabel {
  ConnectionStatusLabel({
    required this.status,
    super.style,
    super.key
  }) : super(
    text: status.label,
    color: switch (status) {
      RobotConnectionStatus.disconnected => Colors.red,
      RobotConnectionStatus.connected => Colors.green,
      _ => Colors.grey
    }
  );

  final RobotConnectionStatus status;
}

class AutonomyStatusLabel extends TextLabel {
  AutonomyStatusLabel({
    required this.status,
    super.style,
    super.key
  }) : super(
    text: status.label,
    color: switch (status) {
      AutonomyStatus.manual => Colors.orange,
      AutonomyStatus.idle => Colors.blue,
      AutonomyStatus.auto => Colors.green,
      _ => Colors.grey,
    }
  );

  final AutonomyStatus status;
}

class LocationLabel extends TextLabel {
  LocationLabel({
    required this.locationData,
    super.style,
    super.key
  }) : super(
    text: locationData.toString2D(),
    color: Colors.transparent
  );

  final Pose locationData;
}

class BatteryStateLabel extends IconLabel {
  BatteryStateLabel({
    required this.state,
    super.iconRotations = 1,
    super.style,
    super.key
  }) : super(
    icon: switch (state.percentage) {
      < 10.0 => Icons.battery_0_bar,
      < 20.0 => Icons.battery_1_bar,
      < 30.0 => Icons.battery_2_bar,
      < 40.0 => Icons.battery_3_bar,
      < 50.0 => Icons.battery_4_bar,
      < 70.0 => Icons.battery_5_bar,
      < 90.0 => Icons.battery_6_bar,
      _ => Icons.battery_full
    },
    text: '${state.percentage} %'
  );

  final BatteryState state;
}

class TextWithIcon extends StatelessWidget {
  const TextWithIcon({
    required this.text,
    this.style,
    required this.icon,
    super.key
  });
  TextWithIcon.iconData({
    required this.text,
    this.style,
    required IconData iconData,
    super.key
  }) : icon = Icon(iconData);

  final String text;
  final TextStyle? style;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        icon,
        Text(text, style: style)
      ],
    );
  }
}
