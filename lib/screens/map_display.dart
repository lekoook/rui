
import 'package:flutter/services.dart';

import '../data/robot_status_model.dart';
import 'dart:ui' as ui;
import 'package:flutter/widget_previews.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

@Preview(name: 'Map Display')
Widget mapDisplay() {
  RobotStatusViewModel vm = RobotStatusViewModel();
  return MapDisplay(robotStatusViewModel: vm);
}

class MapPainter extends CustomPainter {
  MapPainter({
    required this.mapImage
  });

  final ui.Image? mapImage;

  @override
  void paint(Canvas canvas, Size size) {
    if (mapImage == null) {
      return;
    }
    canvas.save();

    // canvas.scale(1, -1);
    canvas.drawImage(
      mapImage!,
      Offset((size.width - mapImage!.width) / 2.0, (size.height - mapImage!.height) / 2.0),
      Paint()
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

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
    return FutureBuilder<ui.Image>(
      future: loadImage('test_map.png'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CustomPaint(
            painter: MapPainter(mapImage: snapshot.data),
          );
          // return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container();
        }
      }
    );
  }

  Future<ui.Image> loadImage(String asset) async {
    final data = await rootBundle.load(asset);
    final bytes = data.buffer.asUint8List();

    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();

    return frame.image;
  }
}
