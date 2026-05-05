class Pose {
  const Pose({
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
    // TODO: Calculate yaw.
    return 0;
  }
}

class MapMetaData {
  const MapMetaData({
    this.name = '',
    this.resolution = 0.0,
    this.width = 0.0,
    this.height = 0.0,
    this.origin = const Pose()
  });

  final String name;
  final double resolution;
  final double width;
  final double height;
  final Pose origin;
}
