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
  unknown('Unknown'),
  charging('Charging'),
  discharging('Discharging'),
  notCharging('NotCharging'),
  full('Full');
  const BatteryPowerStatus(this.label);
  final String label;
}

enum BatteryPowerHealth {
  unknown('Unknown'),
  good('Good'),
  overheat('Overheat'),
  dead('Dead'),
  overvoltage('Overvoltage'),
  unspecFailure('UnspecFailure'),
  cold('Cold'),
  watchdogTimerExpire('WatchdogTimerExpire'),
  safetyTimerExpire('SafetyTimerExpire');
  const BatteryPowerHealth(this.label);
  final String label;
}

enum BatteryPowerTech {
  unknown('UNKNOWN'),
  nimh('NIMH'),
  lion('LION'),
  lipo('LIPO'),
  life('LIFE'),
  nicd('NICD'),
  limn('LIMN');
  const BatteryPowerTech(this.label);
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
  }) : time = time ?? DateTime.now();

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

class LocationData {
  const LocationData({
    this.posX = 0.0,
    this.posY = 0.0,
    this.posZ = 0.0,
    this.oriW = 0.0,
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
}

class MapData {
  const MapData({
    this.name = '',
    this.resolution = 0.0,
    this.width = 0.0,
    this.height = 0.0,
    this.origin = const Pose(),
    this.mapImage
  });

  final String name;
  final double resolution;
  final double width;
  final double height;
  final Pose origin;
  final ui.Image? mapImage;
}
