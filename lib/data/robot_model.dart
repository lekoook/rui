import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui';
import 'package:web/helpers.dart';

import 'errors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rui/data/data_types.dart';
import 'package:web/web.dart' as web;

class RobotModel {
  RobotModel();

  web.EventSource _eventSource = web.EventSource('');
  final _connectionStatus = ValueNotifier(RobotConnectionStatus.disconnected);
  final _batteryState = ValueNotifier(BatteryState());

  late final _eventsMap = {
    'battery_state' : _onBatteryState,
    'robot_pose' : _onRobotPose,
  };

  ValueNotifier<RobotConnectionStatus> get connectionStatus => _connectionStatus;
  ValueNotifier<BatteryState> get batteryState => _batteryState;

  void _onBatteryState(web.MessageEvent event) {
    final str = event.data.toString();
    try {
      final decoded = jsonDecode(str);
      _batteryState.value = BatteryState.fromJson(decoded);
    } on FormatException catch (e) {
      print('battery_state event invalid JSON: ${e.message}\n$str');
    } catch (e) {
      print('battery_state event unexpected JSON error: $e');
    }
  }

  void _onRobotPose(web.MessageEvent event) {
    print('Robot pose event!');
  }

  Future<bool> connect(String url) async {
    final completer = Completer<bool>();
    _eventSource = web.EventSource(url);

    _eventSource.onOpen.first.then((_) {
      if (!completer.isCompleted) {
        if (_eventSource.readyState == web.EventSource.OPEN) {
          _connectionStatus.value = RobotConnectionStatus.connected;
          completer.complete(true);
        } else {
          _connectionStatus.value = RobotConnectionStatus.disconnected;
          completer.complete(false);
        }
      }
    });

    _eventSource.onError.first.then((error) {
      if (!completer.isCompleted) {
        _connectionStatus.value = RobotConnectionStatus.disconnected;
        completer.completeError(ConnectError.sseError);
      }
    });
    _eventSource.onError.listen((error) {
      _eventSource.close();
      _connectionStatus.value = RobotConnectionStatus.disconnected;
    });

    // TODO: Add listener for various events.
    _eventsMap.forEach((k, v) {
      _eventSource.addEventListener(k, (web.Event event) {
        final message = event as MessageEvent;
        v(message);
      }.toJS);
    });

    return completer.future;
  }

  void disconnect() {
    _eventSource.close();
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
