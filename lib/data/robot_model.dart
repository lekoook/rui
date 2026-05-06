import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:rui/data/data_types.dart';
import 'package:web/web.dart' as web;

class RobotModel {
  RobotModel();

  web.EventSource eventSource = web.EventSource('');

  Future<bool> connect(String url) async {
    final completer = Completer<bool>();
    eventSource = web.EventSource(url);

    eventSource.onOpen.first.then((_) {
      if (!completer.isCompleted) {
        if (eventSource.readyState == web.EventSource.OPEN) {
          completer.complete(true);
        } else {
          completer.complete(false);
        }
      }
    });

    eventSource.onError.first.then((error) {
      if (!completer.isCompleted) {
        completer.completeError(false);
      }
    });

    // TODO: Add listener for various events.
    // eventSource.addEventListener(type, callback)

    return completer.future;
  }

  void disconnect() {
    eventSource.close();
  }

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

  void dispose() {
    disconnect();
  }
}
