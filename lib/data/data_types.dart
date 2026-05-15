import 'dart:math';

import 'geometry_msgs.dart';

export 'enums.dart';

extension PoseExt on Pose {
  double get yaw => atan2(
    2 * (orientation.w * orientation.z + orientation.x * orientation.y),
    1 - 2 * (orientation.y * orientation.y + orientation.z * orientation.z),
  );

  String toString2D() =>
      'px: ${position.x.toStringAsFixed(3)},\npy: ${position.y.toStringAsFixed(3)},\nyaw: ${yaw.toStringAsFixed(3)}';
}
