import 'package:flutter/material.dart';

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

class RobotStatusViewModel {
  RobotStatusViewModel() :
    _connectionNotifier = ValueNotifier(RobotConnectionStatus.unknown),
    _batteryStateNotifier = ValueNotifier(BatteryState()),
    _autonomyNotifier = ValueNotifier(AutonomyStatus.unknown),
    _locationNotifier = ValueNotifier(LocationData()) {
      // TODO: Mock data, to be implemented.
      _connectionNotifier.value = RobotConnectionStatus.connected;
      _batteryStateNotifier.value = BatteryState(percentage: 47.0);
      _autonomyNotifier.value = AutonomyStatus.idle;
      _locationNotifier.value = LocationData(posX: 1.23, posY: 4.56, oriW: 1.0);
    }

  final ValueNotifier<RobotConnectionStatus> _connectionNotifier;
  final ValueNotifier<BatteryState> _batteryStateNotifier;
  final ValueNotifier<AutonomyStatus> _autonomyNotifier;
  final ValueNotifier<LocationData> _locationNotifier;

  ValueNotifier<RobotConnectionStatus> get connectionNotifier => _connectionNotifier;
  ValueNotifier<BatteryState> get batteryStateNotifier => _batteryStateNotifier;
  ValueNotifier<AutonomyStatus> get autonomyNotifier => _autonomyNotifier;
  ValueNotifier<LocationData> get locationNotifier => _locationNotifier;

  void dispose() {
    _connectionNotifier.dispose();
    _batteryStateNotifier.dispose();
    _autonomyNotifier.dispose();
    _locationNotifier.dispose();
  }
}