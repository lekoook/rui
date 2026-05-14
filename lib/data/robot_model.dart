import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui' as ui;

import 'errors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/geometry_msgs.dart';
import 'package:rui/data/nav_msgs.dart';
import 'package:rui/data/sensor_msgs.dart';
import 'package:web/web.dart' as web;

class RobotModel {
  RobotModel();

  web.EventSource _eventSource = web.EventSource('');
  final _connectionStatus = ValueNotifier(RobotConnectionStatus.disconnected);
  final _batteryState = ValueNotifier(BatteryState.zero);
  final _robotPose = ValueNotifier(Pose.zero);
  final _currentMap = ValueNotifier(MapInfo());
  final _mapStatus = ValueNotifier(MapStatus());

  late final _eventsMap = {
    'battery_state' : _onBatteryState,
    'robot_pose' : _onRobotPose,
    'current_map' : _onCurrentMap,
    'map_status' : _onMapStatus,
    'map_grid' : _onMapGrid,
  };

  String get robotName => 'Robot Name';
  ValueNotifier<RobotConnectionStatus> get connectionStatus => _connectionStatus;
  ValueNotifier<BatteryState> get batteryState => _batteryState;
  ValueNotifier<Pose> get robotPose => _robotPose;
  ValueNotifier<MapInfo> get currentMap => _currentMap;
  ValueNotifier<MapStatus> get mapStatus => _mapStatus;

  Future<ui.Image?> _decodeOccupancyGridToImage(OccupancyGrid grid) async {
    final width = grid.info.width;
    final height = grid.info.height;
    final data = grid.data;
    
    if (width <= 0 || height <= 0 || data.isEmpty) {
      return null;
    }

    // Convert occupancy values to RGBA bytes
    final rgbaBytes = Uint8List(width * height * 4);

    for (int i = 0; i < data.length; i++) {
      final occupancy = data[i];

      // Convert ROS occupancy (-1=unknown, 0=free, 100=obstacle) to grayscale
      int grayValue;
      if (occupancy < 0) {
        grayValue = 205; // unknown = light gray (matching test_map.png)
      } else {
        // Invert: 0 (free) -> 255 (white), 100 (obstacle) -> 0 (black)
        grayValue = 255 - ((occupancy.clamp(0, 100) * 255) ~/ 100);
      }

      // Flip Y-axis: convert linear index to row/col, then flip row
      final row = i ~/ width;
      final col = i % width;
      final flippedRow = height - 1 - row;
      final flippedIndex = flippedRow * width + col;

      // Set RGBA values (RGBA8888 format)
      rgbaBytes[flippedIndex * 4] = grayValue;         // R
      rgbaBytes[flippedIndex * 4 + 1] = grayValue;     // G
      rgbaBytes[flippedIndex * 4 + 2] = grayValue;     // B
      rgbaBytes[flippedIndex * 4 + 3] = 255;           // A (opaque)
    }

    // Create image from raw RGBA data
    final descriptor = ui.ImageDescriptor.raw(
      await ui.ImmutableBuffer.fromUint8List(rgbaBytes),
      width: width,
      height: height,
      pixelFormat: ui.PixelFormat.rgba8888,
    );

    final codec = await descriptor.instantiateCodec();
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<bool> _connectEventSource(String url) {
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
    _eventsMap.forEach((k, v) {
      _eventSource.addEventListener(k, (web.Event event) {
        final message = event as web.MessageEvent;
        v(message);
      }.toJS);
    });
    return completer.future;
  }

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
    final str = event.data.toString();
    try {
      final decoded = jsonDecode(str);
      final pose = PoseWithCovarianceStamped.fromJson(decoded);
      _robotPose.value = Pose(
        position: Point(x: pose.pose.pose.position.x, y: pose.pose.pose.position.y, z: pose.pose.pose.position.z),
        orientation: Quaternion(x: pose.pose.pose.orientation.x, y: pose.pose.pose.orientation.y, z: pose.pose.pose.orientation.z, w: pose.pose.pose.orientation.w),
      );
    } on FormatException catch (e) {
      print('robot_pose event invalid JSON: ${e.message}\n$str');
    } catch (e) {
      print('robot_pose event unexpected JSON error: $e');
    }
  }

  void _onCurrentMap(web.MessageEvent event) {
    final str = event.data.toString();
    try {
      final decoded = jsonDecode(str);
      final map = MapInfo.fromJson(decoded);
      _currentMap.value = MapInfo(
          name: map.name,
          description: map.description,
          home: map.home,
          resolution: map.resolution,
          width: map.width,
          height: map.height,
          origin: map.origin,
          mapImage: _currentMap.value.mapImage
        );
    } on FormatException catch (e) {
      print('current_map event invalid JSON: ${e.message}\n$str');
    } catch (e) {
      print('current_map event unexpected JSON error: $e');
    }
  }

  void _onMapStatus(web.MessageEvent event) {
    final str = event.data.toString();
    try {
      final decoded = jsonDecode(str);
      _mapStatus.value = MapStatus.fromJson(decoded);
    } on FormatException catch (e) {
      print('map_status event invalid JSON: ${e.message}\n$str');
    } catch (e) {
      print('map_status event unexpected JSON error: $e');
    }
  }

  void _onMapGrid(web.MessageEvent event) {
    final str = event.data.toString();
    try {
      final decoded = jsonDecode(str);
      final grid = OccupancyGrid.fromJson(decoded);
      _decodeOccupancyGridToImage(grid).then((image) {
        if (image != null) {
          _currentMap.value = MapInfo(
            name: _currentMap.value.name,
            description: _currentMap.value.description,
            home: _currentMap.value.home,
            resolution: grid.info.resolution,
            width: grid.info.width.toDouble(),
            height: grid.info.height.toDouble(),
            origin: _currentMap.value.home,
            mapImage: image
          );
        }
      });
      print(grid);
    } on FormatException catch (e) {
      print('map_grid event invalid JSON: ${e.message}\n$str');
    } catch (e) {
      print('map_grid event unexpected JSON error: $e');
    }
  }

  Future<bool> connect(String host, int port) async {
    final eventSourceUri = Uri(scheme: 'http', host: host, port: port, path: 'events');
    return _connectEventSource(eventSourceUri.toString());
  }

  void disconnect() {
    _eventSource.close();
    _connectionStatus.value = RobotConnectionStatus.disconnected;
  }

  Future<MapInfo?> getCurrentMap() async {
    // TODO: Temp.
    final asset = 'test_map.png';
    final data = await rootBundle.load(asset);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    _currentMap.value = MapInfo(
      name: 'test_map',
      resolution: 0.05,
      width: 1350,
      height: 615,
      origin: const Pose(
        position: Point(x: -45.916, y: -9.869, z: 0),
        orientation: Quaternion(x: 0, y: 0, z: 0, w: 1),
      ),
      mapImage: frame.image
    );
    return _currentMap.value;
  }

  void dispose() {
    disconnect();
  }
}
