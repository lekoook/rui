import 'enums.dart';
import 'geometry_msgs.dart';

class MapLandmark {
  final String name;
  final String description;
  final Pose pose;

  const MapLandmark({
    required this.name,
    required this.description,
    required this.pose,
  });

  static const zero = MapLandmark(name: '', description: '', pose: Pose.zero);

  factory MapLandmark.fromJson(Map<String, dynamic> json) {
    return MapLandmark(
      name: json['name'] as String,
      description: json['description'] as String,
      pose: Pose.fromJson(json['pose'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'pose': pose.toJson(),
      };
}

class MapWaypoints {
  final String name;
  final String description;
  final List<Pose> poses;

  const MapWaypoints({
    required this.name,
    required this.description,
    required this.poses,
  });

  static const zero = MapWaypoints(name: '', description: '', poses: []);

  factory MapWaypoints.fromJson(Map<String, dynamic> json) {
    return MapWaypoints(
      name: json['name'] as String,
      description: json['description'] as String,
      poses: (json['poses'] as List<dynamic>)
          .map((e) => Pose.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'poses': poses.map((e) => e.toJson()).toList(),
      };
}

class MapInfo {
  final String name;
  final String description;
  final Pose home;
  final double resolution;
  final double width;
  final double height;
  final Pose origin;
  final List<MapLandmark> landmarks;
  final List<MapWaypoints> waypoints;

  const MapInfo({
    required this.name,
    required this.description,
    required this.home,
    required this.resolution,
    required this.width,
    required this.height,
    required this.origin,
    required this.landmarks,
    required this.waypoints,
  });

  static const zero = MapInfo(
    name: '',
    description: '',
    home: Pose.zero,
    resolution: 0.0,
    width: 0.0,
    height: 0.0,
    origin: Pose.zero,
    landmarks: [],
    waypoints: [],
  );

  factory MapInfo.fromJson(Map<String, dynamic> json) {
    return MapInfo(
      name: json['name'] as String,
      description: json['description'] as String,
      home: Pose.fromJson(json['home'] as Map<String, dynamic>),
      resolution: (json['resolution'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      origin: Pose.fromJson(json['origin'] as Map<String, dynamic>),
      landmarks: (json['landmarks'] as List<dynamic>)
          .map((e) => MapLandmark.fromJson(e as Map<String, dynamic>))
          .toList(),
      waypoints: (json['waypoints'] as List<dynamic>)
          .map((e) => MapWaypoints.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'home': home.toJson(),
        'resolution': resolution,
        'width': width,
        'height': height,
        'origin': origin.toJson(),
        'landmarks': landmarks.map((e) => e.toJson()).toList(),
        'waypoints': waypoints.map((e) => e.toJson()).toList(),
      };
}

class MapStatus {
  final MapInfo currentMap;
  final List<MapInfo> mapsList;
  final MapMode mapMode;

  const MapStatus({
    required this.currentMap,
    required this.mapsList,
    required this.mapMode,
  });

  static const zero = MapStatus(
    currentMap: MapInfo.zero,
    mapsList: [],
    mapMode: MapMode.localization,
  );

  factory MapStatus.fromJson(Map<String, dynamic> json) {
    return MapStatus(
      currentMap: MapInfo.fromJson(json['current_map'] as Map<String, dynamic>),
      mapsList: (json['maps_list'] as List<dynamic>)
          .map((e) => MapInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      mapMode: MapMode.fromIndex((json['map_mode'] as num).toInt()),
    );
  }

  Map<String, dynamic> toJson() => {
        'current_map': currentMap.toJson(),
        'maps_list': mapsList.map((e) => e.toJson()).toList(),
        'map_mode': mapMode.idx,
      };
}