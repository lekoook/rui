import 'std_msgs.dart';

class Accel {
  final Vector3 linear;
  final Vector3 angular;

  const Accel({required this.linear, required this.angular});

  const Accel.zero()
      : linear = const Vector3.zero(),
        angular = const Vector3.zero();

  factory Accel.fromJson(Map<String, dynamic> json) {
    return Accel(
      linear: Vector3.fromJson(json['linear'] as Map<String, dynamic>),
      angular: Vector3.fromJson(json['angular'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'linear': linear.toJson(), 'angular': angular.toJson()};
}

class AccelStamped {
  final Header header;
  final Accel accel;

  const AccelStamped({required this.header, required this.accel});

  const AccelStamped.zero()
      : header = const Header.zero(),
        accel = const Accel.zero();

  factory AccelStamped.fromJson(Map<String, dynamic> json) {
    return AccelStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      accel: Accel.fromJson(json['accel'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'accel': accel.toJson()};
}

class AccelWithCovariance {
  final Accel accel;
  final List<double> covariance;

  const AccelWithCovariance({required this.accel, required this.covariance});

  const AccelWithCovariance.zero()
      : accel = const Accel.zero(),
        covariance = const <double>[];

  factory AccelWithCovariance.fromJson(Map<String, dynamic> json) {
    return AccelWithCovariance(
      accel: Accel.fromJson(json['accel'] as Map<String, dynamic>),
      covariance: (json['covariance'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'accel': accel.toJson(), 'covariance': covariance};
}

class AccelWithCovarianceStamped {
  final Header header;
  final AccelWithCovariance accel;

  const AccelWithCovarianceStamped({required this.header, required this.accel});

  const AccelWithCovarianceStamped.zero()
      : header = const Header.zero(),
        accel = const AccelWithCovariance.zero();

  factory AccelWithCovarianceStamped.fromJson(Map<String, dynamic> json) {
    return AccelWithCovarianceStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      accel: AccelWithCovariance.fromJson(json['accel'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'accel': accel.toJson()};
}

class Inertia {
  final double m;
  final Vector3 com;
  final double ixx;
  final double ixy;
  final double ixz;
  final double iyy;
  final double iyz;
  final double izz;

  const Inertia({
    required this.m,
    required this.com,
    required this.ixx,
    required this.ixy,
    required this.ixz,
    required this.iyy,
    required this.iyz,
    required this.izz,
  });

  const Inertia.zero()
      : m = 0,
        com = const Vector3.zero(),
        ixx = 0,
        ixy = 0,
        ixz = 0,
        iyy = 0,
        iyz = 0,
        izz = 0;

  factory Inertia.fromJson(Map<String, dynamic> json) {
    return Inertia(
      m: (json['m'] as num).toDouble(),
      com: Vector3.fromJson(json['com'] as Map<String, dynamic>),
      ixx: (json['ixx'] as num).toDouble(),
      ixy: (json['ixy'] as num).toDouble(),
      ixz: (json['ixz'] as num).toDouble(),
      iyy: (json['iyy'] as num).toDouble(),
      iyz: (json['iyz'] as num).toDouble(),
      izz: (json['izz'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'm': m,
        'com': com.toJson(),
        'ixx': ixx,
        'ixy': ixy,
        'ixz': ixz,
        'iyy': iyy,
        'iyz': iyz,
        'izz': izz,
      };
}

class InertiaStamped {
  final Header header;
  final Inertia inertia;

  const InertiaStamped({required this.header, required this.inertia});

  const InertiaStamped.zero()
      : header = const Header.zero(),
        inertia = const Inertia.zero();

  factory InertiaStamped.fromJson(Map<String, dynamic> json) {
    return InertiaStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      inertia: Inertia.fromJson(json['inertia'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'inertia': inertia.toJson()};
}

class Point32 {
  final double x;
  final double y;
  final double z;

  const Point32({required this.x, required this.y, required this.z});

  const Point32.zero() : x = 0, y = 0, z = 0;

  factory Point32.fromJson(Map<String, dynamic> json) {
    return Point32(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'z': z};
}

class Point {
  final double x;
  final double y;
  final double z;

  const Point({required this.x, required this.y, required this.z});

  const Point.zero() : x = 0, y = 0, z = 0;

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'z': z};
}

class PointStamped {
  final Header header;
  final Point point;

  const PointStamped({required this.header, required this.point});

  const PointStamped.zero()
      : header = const Header.zero(),
        point = const Point.zero();

  factory PointStamped.fromJson(Map<String, dynamic> json) {
    return PointStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      point: Point.fromJson(json['point'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'point': point.toJson()};
}

class PolygonInstance {
  final Polygon polygon;
  final int id;

  const PolygonInstance({required this.polygon, required this.id});

  const PolygonInstance.zero()
      : polygon = const Polygon.zero(),
        id = 0;

  factory PolygonInstance.fromJson(Map<String, dynamic> json) {
    return PolygonInstance(
      polygon: Polygon.fromJson(json['polygon'] as Map<String, dynamic>),
      id: (json['id'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {'polygon': polygon.toJson(), 'id': id};
}

class PolygonInstanceStamped {
  final Header header;
  final PolygonInstance polygon;

  const PolygonInstanceStamped({required this.header, required this.polygon});

  const PolygonInstanceStamped.zero()
      : header = const Header.zero(),
        polygon = const PolygonInstance.zero();

  factory PolygonInstanceStamped.fromJson(Map<String, dynamic> json) {
    return PolygonInstanceStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      polygon: PolygonInstance.fromJson(json['polygon'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'polygon': polygon.toJson()};
}

class Polygon {
  final List<Point32> points;

  const Polygon({required this.points});

  const Polygon.zero() : points = const <Point32>[];

  factory Polygon.fromJson(Map<String, dynamic> json) {
    return Polygon(
      points: (json['points'] as List<dynamic>)
          .map((e) => Point32.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {'points': points.map((e) => e.toJson()).toList()};
}

class PolygonStamped {
  final Header header;
  final Polygon polygon;

  const PolygonStamped({required this.header, required this.polygon});

  const PolygonStamped.zero()
      : header = const Header.zero(),
        polygon = const Polygon.zero();

  factory PolygonStamped.fromJson(Map<String, dynamic> json) {
    return PolygonStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      polygon: Polygon.fromJson(json['polygon'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'polygon': polygon.toJson()};
}

class PoseArray {
  final Header header;
  final List<Pose> poses;

  const PoseArray({required this.header, required this.poses});

  const PoseArray.zero()
      : header = const Header.zero(),
        poses = const <Pose>[];

  factory PoseArray.fromJson(Map<String, dynamic> json) {
    return PoseArray(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      poses: (json['poses'] as List<dynamic>)
          .map((e) => Pose.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'poses': poses.map((e) => e.toJson()).toList(),
      };
}

class Pose {
  final Point position;
  final Quaternion orientation;

  const Pose({required this.position, required this.orientation});

  const Pose.zero()
      : position = const Point.zero(),
        orientation = const Quaternion.zero();

  factory Pose.fromJson(Map<String, dynamic> json) {
    return Pose(
      position: Point.fromJson(json['position'] as Map<String, dynamic>),
      orientation: Quaternion.fromJson(json['orientation'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'position': position.toJson(), 'orientation': orientation.toJson()};
}

class PoseStamped {
  final Header header;
  final Pose pose;

  const PoseStamped({required this.header, required this.pose});

  const PoseStamped.zero()
      : header = const Header.zero(),
        pose = const Pose.zero();

  factory PoseStamped.fromJson(Map<String, dynamic> json) {
    return PoseStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      pose: Pose.fromJson(json['pose'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'pose': pose.toJson()};
}

class PoseWithCovariance {
  final Pose pose;
  final List<double> covariance;

  const PoseWithCovariance({required this.pose, required this.covariance});

  const PoseWithCovariance.zero()
      : pose = const Pose.zero(),
        covariance = const <double>[];

  factory PoseWithCovariance.fromJson(Map<String, dynamic> json) {
    return PoseWithCovariance(
      pose: Pose.fromJson(json['pose'] as Map<String, dynamic>),
      covariance: (json['covariance'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'pose': pose.toJson(), 'covariance': covariance};
}

class PoseWithCovarianceStamped {
  final Header header;
  final PoseWithCovariance pose;

  const PoseWithCovarianceStamped({required this.header, required this.pose});

  const PoseWithCovarianceStamped.zero()
      : header = const Header.zero(),
        pose = const PoseWithCovariance.zero();

  factory PoseWithCovarianceStamped.fromJson(Map<String, dynamic> json) {
    return PoseWithCovarianceStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      pose: PoseWithCovariance.fromJson(json['pose'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'pose': pose.toJson()};
}

class Quaternion {
  final double x;
  final double y;
  final double z;
  final double w;

  const Quaternion({required this.x, required this.y, required this.z, required this.w});

  const Quaternion.zero() : x = 0, y = 0, z = 0, w = 1;

  factory Quaternion.fromJson(Map<String, dynamic> json) {
    return Quaternion(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
      w: (json['w'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'z': z, 'w': w};
}

class QuaternionStamped {
  final Header header;
  final Quaternion quaternion;

  const QuaternionStamped({required this.header, required this.quaternion});

  const QuaternionStamped.zero()
      : header = const Header.zero(),
        quaternion = const Quaternion.zero();

  factory QuaternionStamped.fromJson(Map<String, dynamic> json) {
    return QuaternionStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      quaternion: Quaternion.fromJson(json['quaternion'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'quaternion': quaternion.toJson()};
}

class Transform {
  final Vector3 translation;
  final Quaternion rotation;

  const Transform({required this.translation, required this.rotation});

  const Transform.zero()
      : translation = const Vector3.zero(),
        rotation = const Quaternion.zero();

  factory Transform.fromJson(Map<String, dynamic> json) {
    return Transform(
      translation: Vector3.fromJson(json['translation'] as Map<String, dynamic>),
      rotation: Quaternion.fromJson(json['rotation'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'translation': translation.toJson(), 'rotation': rotation.toJson()};
}

class TransformStamped {
  final Header header;
  final String childFrameId;
  final Transform transform;

  const TransformStamped({required this.header, required this.childFrameId, required this.transform});

  const TransformStamped.zero()
      : header = const Header.zero(),
        childFrameId = '',
        transform = const Transform.zero();

  factory TransformStamped.fromJson(Map<String, dynamic> json) {
    return TransformStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      childFrameId: json['child_frame_id'] as String,
      transform: Transform.fromJson(json['transform'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'child_frame_id': childFrameId,
        'transform': transform.toJson(),
      };
}

class Twist {
  final Vector3 linear;
  final Vector3 angular;

  const Twist({required this.linear, required this.angular});

  const Twist.zero()
      : linear = const Vector3.zero(),
        angular = const Vector3.zero();

  factory Twist.fromJson(Map<String, dynamic> json) {
    return Twist(
      linear: Vector3.fromJson(json['linear'] as Map<String, dynamic>),
      angular: Vector3.fromJson(json['angular'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'linear': linear.toJson(), 'angular': angular.toJson()};
}

class TwistStamped {
  final Header header;
  final Twist twist;

  const TwistStamped({required this.header, required this.twist});

  const TwistStamped.zero()
      : header = const Header.zero(),
        twist = const Twist.zero();

  factory TwistStamped.fromJson(Map<String, dynamic> json) {
    return TwistStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      twist: Twist.fromJson(json['twist'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'twist': twist.toJson()};
}

class TwistWithCovariance {
  final Twist twist;
  final List<double> covariance;

  const TwistWithCovariance({required this.twist, required this.covariance});

  const TwistWithCovariance.zero()
      : twist = const Twist.zero(),
        covariance = const <double>[];

  factory TwistWithCovariance.fromJson(Map<String, dynamic> json) {
    return TwistWithCovariance(
      twist: Twist.fromJson(json['twist'] as Map<String, dynamic>),
      covariance: (json['covariance'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'twist': twist.toJson(), 'covariance': covariance};
}

class TwistWithCovarianceStamped {
  final Header header;
  final TwistWithCovariance twist;

  const TwistWithCovarianceStamped({required this.header, required this.twist});

  const TwistWithCovarianceStamped.zero()
      : header = const Header.zero(),
        twist = const TwistWithCovariance.zero();

  factory TwistWithCovarianceStamped.fromJson(Map<String, dynamic> json) {
    return TwistWithCovarianceStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      twist: TwistWithCovariance.fromJson(json['twist'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'twist': twist.toJson()};
}

class Vector3 {
  final double x;
  final double y;
  final double z;

  const Vector3({required this.x, required this.y, required this.z});

  const Vector3.zero() : x = 0, y = 0, z = 0;

  factory Vector3.fromJson(Map<String, dynamic> json) {
    return Vector3(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'z': z};
}

class Vector3Stamped {
  final Header header;
  final Vector3 vector;

  const Vector3Stamped({required this.header, required this.vector});

  const Vector3Stamped.zero()
      : header = const Header.zero(),
        vector = const Vector3.zero();

  factory Vector3Stamped.fromJson(Map<String, dynamic> json) {
    return Vector3Stamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      vector: Vector3.fromJson(json['vector'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'vector': vector.toJson()};
}

class VelocityStamped {
  final Header header;
  final String bodyFrameId;
  final String referenceFrameId;
  final Twist velocity;

  const VelocityStamped({
    required this.header,
    required this.bodyFrameId,
    required this.referenceFrameId,
    required this.velocity,
  });

  const VelocityStamped.zero()
      : header = const Header.zero(),
        bodyFrameId = '',
        referenceFrameId = '',
        velocity = const Twist.zero();

  factory VelocityStamped.fromJson(Map<String, dynamic> json) {
    return VelocityStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      bodyFrameId: json['body_frame_id'] as String,
      referenceFrameId: json['reference_frame_id'] as String,
      velocity: Twist.fromJson(json['velocity'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'body_frame_id': bodyFrameId,
        'reference_frame_id': referenceFrameId,
        'velocity': velocity.toJson(),
      };
}

class Wrench {
  final Vector3 force;
  final Vector3 torque;

  const Wrench({required this.force, required this.torque});

  const Wrench.zero()
      : force = const Vector3.zero(),
        torque = const Vector3.zero();

  factory Wrench.fromJson(Map<String, dynamic> json) {
    return Wrench(
      force: Vector3.fromJson(json['force'] as Map<String, dynamic>),
      torque: Vector3.fromJson(json['torque'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'force': force.toJson(), 'torque': torque.toJson()};
}

class WrenchStamped {
  final Header header;
  final Wrench wrench;

  const WrenchStamped({required this.header, required this.wrench});

  const WrenchStamped.zero()
      : header = const Header.zero(),
        wrench = const Wrench.zero();

  factory WrenchStamped.fromJson(Map<String, dynamic> json) {
    return WrenchStamped(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      wrench: Wrench.fromJson(json['wrench'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'wrench': wrench.toJson()};
}
