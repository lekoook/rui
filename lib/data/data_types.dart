import 'dart:math';
import 'dart:ui' as ui;

enum RobotConnectionStatus {
  unknown('Unknown'),
  disconnected('Disconnected'),
  connected('Connected');
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

enum BatteryPowerStatus {
  unknown(0, 'Unknown'),
  charging(1, 'Charging'),
  discharging(2, 'Discharging'),
  notCharging(3, 'NotCharging'),
  full(4, 'Full');
  const BatteryPowerStatus(this.idx, this.label);
  factory BatteryPowerStatus.fromIndex(int idx) {
    return values.firstWhere(
      (e) => e.idx == idx,
      orElse: () => BatteryPowerStatus.unknown
    );
  }
  final int idx;
  final String label;
}

enum BatteryPowerHealth {
  unknown(0, 'Unknown'),
  good(1, 'Good'),
  overheat(2, 'Overheat'),
  dead(3, 'Dead'),
  overvoltage(4, 'Overvoltage'),
  unspecFailure(5, 'UnspecFailure'),
  cold(6, 'Cold'),
  watchdogTimerExpire(7, 'WatchdogTimerExpire'),
  safetyTimerExpire(8, 'SafetyTimerExpire');
  const BatteryPowerHealth(this.idx, this.label);
  factory BatteryPowerHealth.fromIndex(int idx) {
    return values.firstWhere(
      (e) => e.idx == idx,
      orElse: () => BatteryPowerHealth.unknown
    );
  }
  final int idx;
  final String label;
}

enum BatteryPowerTech {
  unknown(0, 'UNKNOWN'),
  nimh(1, 'NIMH'),
  lion(2, 'LION'),
  lipo(3, 'LIPO'),
  life(4, 'LIFE'),
  nicd(5, 'NICD'),
  limn(6, 'LIMN');
  const BatteryPowerTech(this.idx, this.label);
  factory BatteryPowerTech.fromIndex(int idx) {
    return values.firstWhere(
      (e) => e.idx == idx,
      orElse: () => BatteryPowerTech.unknown
    );
  }
  final int idx;
  final String label;
}

class Header {
const Header({
  this.stamp,
  this.frameId
});
  final DateTime? stamp;
  final String? frameId;

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      // stamp: json['stamp'],
      frameId: json['frame_id'],
    );
  }
}

class BatteryState {
  BatteryState({
    this.location = '',
    this.serialNumber = '',
    DateTime? time,
    this.voltage = 0.0,
    this.temperature = 0.0,
    this.current = 0.0,
    this.charge = 0.0,
    this.capacity = 0.0,
    this.designCapacity = 0.0,
    this.percentage = 0.0,
    this.powerStatus = BatteryPowerStatus.unknown,
    this.powerHealth = BatteryPowerHealth.unknown,
    this.powerTechnology = BatteryPowerTech.unknown,
    this.cellVoltage = const [],
    this.cellTemperature = const []
  }) : time = time ?? DateTime(0);

  factory BatteryState.fromJson(Map<String, dynamic> json) {
    return BatteryState(
      location: json['location'],
      serialNumber: json['serial_number'],
      voltage: json['voltage'],
      temperature: json['temperature'],
      current: json['current'],
      charge: json['charge'],
      capacity: json['capacity'],
      designCapacity: json['design_capacity'],
      percentage: json['percentage'],
      powerStatus: BatteryPowerStatus.fromIndex(json['power_supply_status']),
      powerHealth: BatteryPowerHealth.fromIndex(json['power_supply_health']),
      powerTechnology: BatteryPowerTech.fromIndex(json['power_supply_technology']),
    );
  }

  final String location;
  final String serialNumber;
  final DateTime time;
  final double voltage;
  final double temperature;
  final double current;
  final double charge;
  final double capacity;
  final double designCapacity;
  final double percentage;
  final BatteryPowerStatus powerStatus;
  final BatteryPowerHealth powerHealth;
  final BatteryPowerTech powerTechnology;
  final List<double> cellVoltage;
  final List<double> cellTemperature;
}

class Point {
  const Point({
    this.x,
    this.y,
    this.z
  });

  final double? x;
  final double? y;
  final double? z;

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      x: json['x'],
      y: json['y'],
      z: json['z'],
    );
  }
}

class Quaternion {
  const Quaternion({
    this.w,
    this.x,
    this.y,
    this.z
  });

  final double? w;
  final double? x;
  final double? y;
  final double? z;

  factory Quaternion.fromJson(Map<String, dynamic> json) {
    return Quaternion(
      w: json['w'],
      x: json['x'],
      y: json['y'],
      z: json['z'],
    );
  }
}

class Pose {
  const Pose({
    this.position,
    this.orientation
  });

  final Point? position;
  final Quaternion? orientation;

  double get yaw => _getYaw();

  double _getYaw() {
    if (position == null || orientation == null) {
      return 0.0;
    }
    return atan2(2 * (orientation!.w! * orientation!.z! + orientation!.x! * orientation!.y!), 1 - 2 * (orientation!.y! * orientation!.y! + orientation!.z! * orientation!.z!));
  }

  factory Pose.fromJson(Map<String, dynamic> json) {
    return Pose(
      position: Point.fromJson(json['position']),
      orientation: Quaternion.fromJson(json['orientation'])
    );
  }

  @override
  String toString() {
    return 'px: ${position?.x?.toStringAsFixed(3)}, py: ${position?.y?.toStringAsFixed(3)}, pz: ${position?.z?.toStringAsFixed(3)}, ow: ${orientation?.w?.toStringAsFixed(3)}, ox: ${orientation?.x?.toStringAsFixed(3)}, oy: ${orientation?.y?.toStringAsFixed(3)}, oz: ${orientation?.z?.toStringAsFixed(3)}';
  }

  String toString2D() {
    return 'px: ${position?.x?.toStringAsFixed(3)},\npy: ${position?.y?.toStringAsFixed(3)},\nyaw: ${position?.z?.toStringAsFixed(3)}';
  }
}

class PoseWithCovarianceStamped {
  const PoseWithCovarianceStamped({
    this.posX = 0.0,
    this.posY = 0.0,
    this.posZ = 0.0,
    this.oriW = 1.0,
    this.oriX = 0.0,
    this.oriY = 0.0,
    this.oriZ = 0.0
  });

  final double posX;
  final double posY;
  final double posZ;
  final double oriW;
  final double oriX;
  final double oriY;
  final double oriZ;

  double get yaw => _getYaw();

  double _getYaw() {
    return atan2(2 * (oriW * oriZ + oriX * oriY), 1 - 2 * (oriY * oriY + oriZ * oriZ));
  }

  factory PoseWithCovarianceStamped.fromJson(Map<String, dynamic> json) {
    return PoseWithCovarianceStamped(
      posX: json['pose']['pose']['position']['x'],
      posY: json['pose']['pose']['position']['y'],
      posZ: json['pose']['pose']['position']['z'],
      oriW: json['pose']['pose']['orientation']['w'],
      oriX: json['pose']['pose']['orientation']['x'],
      oriY: json['pose']['pose']['orientation']['y'],
      oriZ: json['pose']['pose']['orientation']['z'],
    );
  }

  @override
  String toString() {
    return 'px: ${posX.toStringAsFixed(3)}, py: ${posY.toStringAsFixed(3)}, pz: ${posZ.toStringAsFixed(3)}, ow: ${oriW.toStringAsFixed(3)}, ox: ${oriX.toStringAsFixed(3)}, oy: ${oriY.toStringAsFixed(3)}, oz: ${oriZ.toStringAsFixed(3)}';
  }

  String toString2D() {
    return 'px: ${posX.toStringAsFixed(3)},\npy: ${posY.toStringAsFixed(3)},\nyaw: ${yaw.toStringAsFixed(3)}';
  }
}

class MapMetaData {
  const MapMetaData({
    this.mapLoadTime,
    this.resolution,
    this.width,
    this.height,
    this.origin
  });

  final DateTime? mapLoadTime;
  final double? resolution;
  final int? width;
  final int? height;
  final Pose? origin;

  factory MapMetaData.fromJson(Map<String, dynamic> json) {
    return MapMetaData(
      // mapLoadTime: json['map_load_time'],
      resolution: json['resolution'],
      width: json['width'],
      height: json['height'],
      origin: Pose.fromJson(json['origin']),
    );
  }
}

class OccupancyGrid {
  const OccupancyGrid({
    this.header,
    this.info,
    this.data
  });

  final Header? header;
  final MapMetaData? info;
  final List<int>? data;

  factory OccupancyGrid.fromJson(Map<String, dynamic> json) {
    return OccupancyGrid(
      header: Header.fromJson(json['header']),
      info: MapMetaData.fromJson(json['info']),
      data: (json['data'] as List<dynamic>?)?.cast<int>(),
    );
  }
}

class MapInfo {
  const MapInfo({
    this.name = '',
    this.description = '',
    this.home = const Pose(),
    this.resolution = 0.0,
    this.width = 0.0,
    this.height = 0.0,
    this.origin = const Pose(),
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
      // TODO: Implement on ROS side.
      home: Pose.fromJson(json['home']),
      // resolution: json['resolution'],
      // width: json['width'],
      // height: json['height'],
      // origin: Pose.fromJson(json['origin']),
      // mapImage: json['mapImage'],
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
