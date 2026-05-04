import '../data/robot_status_model.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class MapDisplay extends StatefulWidget {
  const MapDisplay({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  RobotStatusViewModel get robotStatusViewModel => widget.robotStatusViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.gray,
      child: Text('Map goes here'),
    );
  }
}
