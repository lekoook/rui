import 'package:flutter/material.dart';
import 'package:rui/data/data_types.dart';

class MapMarkerController extends ChangeNotifier {
  MapMarkerController({
    required this.poseNotifier,
    required this.hiddenNotifier,
  }) {
    poseNotifier.addListener(() => notifyListeners());
    hiddenNotifier.addListener(() => notifyListeners());
  }
  
  final ValueNotifier<Pose> poseNotifier;
  final ValueNotifier<bool> hiddenNotifier;
}
