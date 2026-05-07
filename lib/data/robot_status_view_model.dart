import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/robot_model.dart';

class RobotStatusViewModel {
  RobotStatusViewModel({
    required RobotModel robotModel
  }) :
    _robotModel = robotModel,
    _batteryStateNotifier = ValueNotifier(BatteryState()),
    _autonomyNotifier = ValueNotifier(AutonomyStatus.unknown),
    _locationNotifier = ValueNotifier(LocationData()),
    _currentMapNotifier = ValueNotifier(MapData()) {
      // TODO: Mock data, to be implemented.
      _batteryStateNotifier.value = BatteryState(percentage: 47.0);
      _autonomyNotifier.value = AutonomyStatus.idle;
      _locationNotifier.value = LocationData(posX: 1.23, posY: 4.56, oriW: 1.0);
    }

  final RobotModel _robotModel;
  final ValueNotifier<BatteryState> _batteryStateNotifier;
  final ValueNotifier<AutonomyStatus> _autonomyNotifier;
  final ValueNotifier<LocationData> _locationNotifier;
  final ValueNotifier<MapData> _currentMapNotifier;

  RobotModel get robotMode => _robotModel;
  ValueNotifier<RobotConnectionStatus> get connectionNotifier => _robotModel.connectionStatus;
  ValueNotifier<BatteryState> get batteryStateNotifier => _batteryStateNotifier;
  ValueNotifier<AutonomyStatus> get autonomyNotifier => _autonomyNotifier;
  ValueNotifier<LocationData> get locationNotifier => _locationNotifier;
  ValueNotifier<MapData> get currentMapNotifier => _currentMapNotifier;
  ui.Image? get currentMapImage => _currentMapNotifier.value.mapImage;

  void connectToRobot(String url) {
    _robotModel.connect(url)
      .then((success) {
        // Do nothing for now.
      }).catchError((error) {
        print('[RobotStatusViewModel.connectToRobot]: $error');
      });
  }

  void dispose() {
    _batteryStateNotifier.dispose();
    _autonomyNotifier.dispose();
    _locationNotifier.dispose();
    _currentMapNotifier.dispose();
  }

  void fetchCurrentMap() {
    _robotModel.getCurrentMap().then((value) {
      if (value != null) {
        _currentMapNotifier.value = value;
      }
    });
  }
}