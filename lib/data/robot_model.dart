import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:rui/data/data_types.dart';

class RobotModel {
  RobotModel();

  Future<MapData?> getCurrentMap() async {
    // TODO: Temp.
    final asset = 'test_map.png';
    final data = await rootBundle.load(asset);
    final bytes = data.buffer.asUint8List();
    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();

    return MapData(
      name: 'test_map',
      resolution: 0.05,
      width: 1350,
      height: 615,
      origin: Pose(
        posX: -45.916,
        posY: -9.869
      ),
      mapImage: frame.image
    );
  }
}
