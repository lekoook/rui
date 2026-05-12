import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/geometry_msgs.dart';
import 'package:rui/data/sensor_msgs.dart';
import 'package:rui/data/robot_model.dart';

class RobotViewModel {
  RobotViewModel({
    required RobotModel robotModel
  }) :
    _robotModel = robotModel,
    _autonomyNotifier = ValueNotifier(AutonomyStatus.unknown) {
      // TODO: Mock data, to be implemented.
      _autonomyNotifier.value = AutonomyStatus.idle;
    }

  final RobotModel _robotModel;
  final ValueNotifier<AutonomyStatus> _autonomyNotifier;

  RobotModel get robotMode => _robotModel;
  String get robotName => _robotModel.robotName;
  double get batteryPercentage => _robotModel.batteryState.value.percentage;
  ValueNotifier<RobotConnectionStatus> get connectionNotifier => _robotModel.connectionStatus;
  ValueNotifier<BatteryState> get batteryStateNotifier => _robotModel.batteryState;
  ValueNotifier<AutonomyStatus> get autonomyNotifier => _autonomyNotifier;
  ValueNotifier<Pose> get robotPoseNotifier => _robotModel.robotPose;
  ValueNotifier<MapInfo> get currentMapNotifier => _robotModel.currentMap;
  ValueNotifier<MapStatus> get mapStatusNotifier => _robotModel.mapStatus;
  ui.Image? get currentMapImage => _robotModel.currentMap.value.mapImage;

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
  }

  void fetchCurrentMap() {
    _robotModel.getCurrentMap().then((value) {
      if (value != null) {
      }
    });
  }
}