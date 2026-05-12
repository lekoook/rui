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
  final _connectionStatusNotifier = ValueNotifier(RobotConnectionStatus.disconnected);
  final ValueNotifier<AutonomyStatus> _autonomyNotifier;

  RobotModel get robotMode => _robotModel;
  String get robotName => _robotModel.robotName;
  double get batteryPercentage => _robotModel.batteryState.value.percentage;
  ValueNotifier<RobotConnectionStatus> get connectionStatusNotifier => _connectionStatusNotifier;
  ValueNotifier<BatteryState> get batteryStateNotifier => _robotModel.batteryState;
  ValueNotifier<AutonomyStatus> get autonomyNotifier => _autonomyNotifier;
  ValueNotifier<Pose> get robotPoseNotifier => _robotModel.robotPose;
  ValueNotifier<MapInfo> get currentMapNotifier => _robotModel.currentMap;
  ValueNotifier<MapStatus> get mapStatusNotifier => _robotModel.mapStatus;
  ui.Image? get currentMapImage => _robotModel.currentMap.value.mapImage;

  bool isConnected() {
    return _connectionStatusNotifier.value == RobotConnectionStatus.connected;
  }

  Future<void> connect(String host, int port) async {
    if (isConnected()) {
      disconnectRobot();
    }
    _connectionStatusNotifier.value = RobotConnectionStatus.connecting;
    await _robotModel.connect(host, port)
      .then((success) {
        if (success) {
          _connectionStatusNotifier.value = RobotConnectionStatus.connected;
        } else {
          _connectionStatusNotifier.value = RobotConnectionStatus.disconnected;
        }
      }).catchError((error) {
        _connectionStatusNotifier.value = RobotConnectionStatus.disconnected;
        print('[RobotStatusViewModel.connect]: $error');
      });
  }

  void disconnectRobot() {
    _robotModel.disconnect();
    _connectionStatusNotifier.value = RobotConnectionStatus.disconnected;
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