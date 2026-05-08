import 'package:flutter/material.dart';
import 'package:rui/data/data_types.dart';

class MapMarkerController extends ChangeNotifier {
  MapMarkerController({
    required this.poseNotifier,
  }) : hiddenNotifier = ValueNotifier(false) {
    poseNotifier.addListener(() => notifyListeners());
    hiddenNotifier.addListener(() => notifyListeners());
  }

  final ValueNotifier<Pose> poseNotifier;
  final ValueNotifier<bool> hiddenNotifier;
}
