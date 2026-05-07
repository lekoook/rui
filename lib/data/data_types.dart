import 'dart:convert';
import 'dart:ui' as ui;

enum RobotConnectionStatus {
  unknown('Unknown'),
  disconnected('Disconnected'),
  connected('Connected');
  const RobotConnectionStatus(this.label);
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
      serialNumber: json['serialNumber'],
      voltage: json['voltage'],
      temperature: json['temperature'],
      current: json['current'],
      charge: json['charge'],
      capacity: json['capacity'],
      designCapacity: json['designCapacity'],
      percentage: json['percentage'],
      powerStatus: BatteryPowerStatus.fromIndex(json['powerStatus']),
      powerHealth: BatteryPowerHealth.fromIndex(json['powerHealth']),
      powerTechnology: BatteryPowerTech.fromIndex(json['powerTechnology']),
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

class PoseData {
  const PoseData({
    this.posX = 0.0,
    this.posY = 0.0,
    this.posZ = 0.0,
    this.oriW = 0.0,
    this.oriX = 0.0,
    this.oriY = 0.0,
    this.oriZ = 0.0
  });

  factory PoseData.fromJson(Map<String, dynamic> json) {
    return PoseData(
      posX: json['posX'],
      posY: json['posY'],
      posZ: json['posZ'],
      oriW: json['oriW'],
      oriX: json['oriX'],
      oriY: json['oriY'],
      oriZ: json['oriZ'],
    );
  }

  final double posX;
  final double posY;
  final double posZ;
  final double oriW;
  final double oriX;
  final double oriY;
  final double oriZ;

  double yaw() {
    return 0;
  }
}

class Pose {
  const Pose({
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

  double _yaw() {
    // TODO: Calculate yaw.
    return 0;
  }

  double get yaw => _yaw();

  @override
  String toString() {
    return 'px: $posX, py: $posY, pz: $posZ, ow: $oriW, ox: $oriX, oy: $oriY, oz: $oriZ';
  }

  String toString2D() {
    return 'px: $posX, py: $posY, yaw: ${_yaw()}';
  }
}

class MapData {
  const MapData({
    this.name = '',
    this.description = '',
    this.resolution = 0.0,
    this.width = 0.0,
    this.height = 0.0,
    this.origin = const Pose(),
    this.mapImage
  });

  final String name;
  final String description;
  final double resolution;
  final double width;
  final double height;
  final Pose origin;
  final ui.Image? mapImage;
}
