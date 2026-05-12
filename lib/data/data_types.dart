import 'dart:math';
import 'dart:ui' as ui;

import 'geometry_msgs.dart';

enum RobotConnectionStatus {
  disconnected('Disconnected'),
  connected('Connected'),
  connecting('Connecting');
  const RobotConnectionStatus(this.label);
  final String label;
}

enum MapMode {
  localization(0, 'Localization'),
  mapping(1, 'Mapping');
  const MapMode(this.idx, this.label);
  factory MapMode.fromIndex(int idx) {
    return values.firstWhere(
      (e) => e.idx == idx,
      orElse: () => MapMode.localization
    );
  }
  final int idx;
  final String label;
}

enum AutonomyStatus {
  unknown('Unknown'),
  manual('Manual'),
  idle('Idle'),
  auto('Auto');
  const AutonomyStatus(this.label);
  final String label;
}


extension PoseExt on Pose {
  double get yaw => atan2(
    2 * (orientation.w * orientation.z + orientation.x * orientation.y),
    1 - 2 * (orientation.y * orientation.y + orientation.z * orientation.z),
  );

  String toString2D() =>
      'px: ${position.x.toStringAsFixed(3)},\npy: ${position.y.toStringAsFixed(3)},\nyaw: ${yaw.toStringAsFixed(3)}';
}


class MapInfo {
  const MapInfo({
    this.name = '',
    this.description = '',
    this.home = const Pose.zero(),
    this.resolution = 0.0,
    this.width = 0.0,
    this.height = 0.0,
    this.origin = const Pose.zero(),
    this.mapImage
  });

  final String name;
  final String description;
  final Pose home;
  final double resolution;
  final double width;
  final double height;
  final Pose origin;
  final ui.Image? mapImage;

  factory MapInfo.fromJson(Map<String, dynamic> json) {
    return MapInfo(
      name: json['name'],
      description: json['description'],
      home: Pose.fromJson(json['home']),
      resolution: (json['resolution'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      origin: Pose.fromJson(json['origin'] as Map<String, dynamic>),
    );
  }
}

class MapStatus {
  const MapStatus({
    this.currentMap = const MapInfo(),
    this.mapsList = const [],
    this.mapMode = MapMode.localization
  });

  final MapInfo currentMap;
  final List<MapInfo> mapsList;
  final MapMode mapMode;

  factory MapStatus.fromJson(Map<String, dynamic> json) {
    final jsonMapsList = json['maps_list'] as List<dynamic>;
    final mapsList = jsonMapsList
        .map((mapJson) => MapInfo.fromJson(mapJson as Map<String, dynamic>))
        .toList();
    return MapStatus(
      currentMap: MapInfo.fromJson(json['current_map']),
      mapsList: mapsList,
      mapMode: MapMode.fromIndex(json['map_mode']),
    );
  }
}
