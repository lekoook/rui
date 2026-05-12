import 'builtin_interfaces.dart';
import 'geometry_msgs.dart';
import 'std_msgs.dart';

class Goals {
  final Header header;
  final List<PoseStamped> goals;

  const Goals({required this.header, required this.goals});

  static const zero = Goals(header: Header.zero, goals: []);

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      goals: (json['goals'] as List<dynamic>)
          .map((e) => PoseStamped.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'goals': goals.map((e) => e.toJson()).toList(),
      };
}

class GridCells {
  final Header header;
  final double cellWidth;
  final double cellHeight;
  final List<Point> cells;

  const GridCells({
    required this.header,
    required this.cellWidth,
    required this.cellHeight,
    required this.cells,
  });

  static const zero = GridCells(header: Header.zero, cellWidth: 0, cellHeight: 0, cells: []);

  factory GridCells.fromJson(Map<String, dynamic> json) {
    return GridCells(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      cellWidth: (json['cell_width'] as num).toDouble(),
      cellHeight: (json['cell_height'] as num).toDouble(),
      cells: (json['cells'] as List<dynamic>)
          .map((e) => Point.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'cell_width': cellWidth,
        'cell_height': cellHeight,
        'cells': cells.map((e) => e.toJson()).toList(),
      };
}

class MapMetaData {
  final BuiltinInterfacesTime mapLoadTime;
  final double resolution;
  final int width;
  final int height;
  final Pose origin;

  const MapMetaData({
    required this.mapLoadTime,
    required this.resolution,
    required this.width,
    required this.height,
    required this.origin,
  });

  static const zero = MapMetaData(
    mapLoadTime: BuiltinInterfacesTime.zero,
    resolution: 0,
    width: 0,
    height: 0,
    origin: Pose.zero,
  );

  factory MapMetaData.fromJson(Map<String, dynamic> json) {
    return MapMetaData(
      mapLoadTime: BuiltinInterfacesTime.fromJson(json['map_load_time'] as Map<String, dynamic>),
      resolution: (json['resolution'] as num).toDouble(),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      origin: Pose.fromJson(json['origin'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'map_load_time': mapLoadTime.toJson(),
        'resolution': resolution,
        'width': width,
        'height': height,
        'origin': origin.toJson(),
      };
}

class OccupancyGrid {
  final Header header;
  final MapMetaData info;
  final List<int> data;

  const OccupancyGrid({required this.header, required this.info, required this.data});

  static const zero = OccupancyGrid(header: Header.zero, info: MapMetaData.zero, data: []);

  factory OccupancyGrid.fromJson(Map<String, dynamic> json) {
    return OccupancyGrid(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      info: MapMetaData.fromJson(json['info'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'info': info.toJson(),
        'data': data,
      };
}

class Odometry {
  final Header header;
  final String childFrameId;
  final PoseWithCovariance pose;
  final TwistWithCovariance twist;

  const Odometry({
    required this.header,
    required this.childFrameId,
    required this.pose,
    required this.twist,
  });

  static const zero = Odometry(
    header: Header.zero,
    childFrameId: '',
    pose: PoseWithCovariance.zero,
    twist: TwistWithCovariance.zero,
  );

  factory Odometry.fromJson(Map<String, dynamic> json) {
    return Odometry(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      childFrameId: json['child_frame_id'] as String,
      pose: PoseWithCovariance.fromJson(json['pose'] as Map<String, dynamic>),
      twist: TwistWithCovariance.fromJson(json['twist'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'child_frame_id': childFrameId,
        'pose': pose.toJson(),
        'twist': twist.toJson(),
      };
}

class Path {
  final Header header;
  final List<PoseStamped> poses;

  const Path({required this.header, required this.poses});

  static const zero = Path(header: Header.zero, poses: []);

  factory Path.fromJson(Map<String, dynamic> json) {
    return Path(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      poses: (json['poses'] as List<dynamic>)
          .map((e) => PoseStamped.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'poses': poses.map((e) => e.toJson()).toList(),
      };
}

class Trajectory {
  final Header header;
  final List<TrajectoryPoint> points;

  const Trajectory({required this.header, required this.points});

  static const zero = Trajectory(header: Header.zero, points: []);

  factory Trajectory.fromJson(Map<String, dynamic> json) {
    return Trajectory(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      points: (json['points'] as List<dynamic>)
          .map((e) => TrajectoryPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'points': points.map((e) => e.toJson()).toList(),
      };
}

class TrajectoryPoint {
  final Header header;
  final Pose pose;
  final Twist velocity;
  final Accel acceleration;
  final Wrench effort;

  const TrajectoryPoint({
    required this.header,
    required this.pose,
    required this.velocity,
    required this.acceleration,
    required this.effort,
  });

  static const zero = TrajectoryPoint(
    header: Header.zero,
    pose: Pose.zero,
    velocity: Twist.zero,
    acceleration: Accel.zero,
    effort: Wrench.zero,
  );

  factory TrajectoryPoint.fromJson(Map<String, dynamic> json) {
    return TrajectoryPoint(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      pose: Pose.fromJson(json['pose'] as Map<String, dynamic>),
      velocity: Twist.fromJson(json['velocity'] as Map<String, dynamic>),
      acceleration: Accel.fromJson(json['acceleration'] as Map<String, dynamic>),
      effort: Wrench.fromJson(json['effort'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'pose': pose.toJson(),
        'velocity': velocity.toJson(),
        'acceleration': acceleration.toJson(),
        'effort': effort.toJson(),
      };
}
