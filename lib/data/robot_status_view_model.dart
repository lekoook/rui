import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/robot_model.dart';

class RobotStatusViewModel {
  RobotStatusViewModel({
    required RobotModel robotModel
  }) :
    _robotModel = robotModel,
    _autonomyNotifier = ValueNotifier(AutonomyStatus.unknown),
    _currentMapNotifier = ValueNotifier(MapData()) {
      // TODO: Mock data, to be implemented.
      _autonomyNotifier.value = AutonomyStatus.idle;
    }

  final RobotModel _robotModel;
  final ValueNotifier<AutonomyStatus> _autonomyNotifier;
  final ValueNotifier<MapData> _currentMapNotifier;

  RobotModel get robotMode => _robotModel;
  String get robotName => _robotModel.robotName;
  double get batteryPercentage => _robotModel.batteryState.value.percentage;
  ValueNotifier<RobotConnectionStatus> get connectionNotifier => _robotModel.connectionStatus;
  ValueNotifier<BatteryState> get batteryStateNotifier => _robotModel.batteryState;
  ValueNotifier<AutonomyStatus> get autonomyNotifier => _autonomyNotifier;
  ValueNotifier<Pose> get robotPoseNotifier => _robotModel.robotPose;
  ValueNotifier<MapData> get currentMapNotifier => _currentMapNotifier;
  ui.Image? get currentMapImage => _currentMapNotifier.value.mapImage;

  void connectToRobot(String host, int port) {
    _robotModel.connect(host, port)
      .then((success) {
        // Do nothing for now.
      }).catchError((error) {
        print('[RobotStatusViewModel.connectToRobot]: $error');
      });
  }

  void disconnectRobot() {
    _robotModel.disconnect();
  }

  void dispose() {
    _autonomyNotifier.dispose();
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