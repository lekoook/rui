import 'builtin_interfaces.dart';
import 'geometry_msgs.dart';
import 'std_msgs.dart';

enum PowerSupplyStatus {
  unknown(0, 'Unknown'),
  charging(1, 'Charging'),
  discharging(2, 'Discharging'),
  notCharging(3, 'NotCharging'),
  full(4, 'Full');

  const PowerSupplyStatus(this.idx, this.label);

  factory PowerSupplyStatus.fromIndex(int idx) {
    return values.firstWhere(
      (e) => e.idx == idx,
      orElse: () => PowerSupplyStatus.unknown,
    );
  }

  final int idx;
  final String label;
}

enum PowerSupplyHealth {
  unknown(0, 'Unknown'),
  good(1, 'Good'),
  overheat(2, 'Overheat'),
  dead(3, 'Dead'),
  overvoltage(4, 'Overvoltage'),
  unspecFailure(5, 'UnspecFailure'),
  cold(6, 'Cold'),
  watchdogTimerExpire(7, 'WatchdogTimerExpire'),
  safetyTimerExpire(8, 'SafetyTimerExpire');

  const PowerSupplyHealth(this.idx, this.label);

  factory PowerSupplyHealth.fromIndex(int idx) {
    return values.firstWhere(
      (e) => e.idx == idx,
      orElse: () => PowerSupplyHealth.unknown,
    );
  }

  final int idx;
  final String label;
}

enum PowerSupplyTechnology {
  unknown(0, 'UNKNOWN'),
  nimh(1, 'NIMH'),
  lion(2, 'LION'),
  lipo(3, 'LIPO'),
  life(4, 'LIFE'),
  nicd(5, 'NICD'),
  limn(6, 'LIMN');

  const PowerSupplyTechnology(this.idx, this.label);

  factory PowerSupplyTechnology.fromIndex(int idx) {
    return values.firstWhere(
      (e) => e.idx == idx,
      orElse: () => PowerSupplyTechnology.unknown,
    );
  }

  final int idx;
  final String label;
}

class BatteryState {
  final Header header;
  final double voltage;
  final double temperature;
  final double current;
  final double charge;
  final double capacity;
  final double designCapacity;
  final double percentage;
  final PowerSupplyStatus powerSupplyStatus;
  final PowerSupplyHealth powerSupplyHealth;
  final PowerSupplyTechnology powerSupplyTechnology;
  final bool present;
  final List<double> cellVoltage;
  final List<double> cellTemperature;
  final String location;
  final String serialNumber;

  const BatteryState({
    required this.header,
    required this.voltage,
    required this.temperature,
    required this.current,
    required this.charge,
    required this.capacity,
    required this.designCapacity,
    required this.percentage,
    required this.powerSupplyStatus,
    required this.powerSupplyHealth,
    required this.powerSupplyTechnology,
    required this.present,
    required this.cellVoltage,
    required this.cellTemperature,
    required this.location,
    required this.serialNumber,
  });

  const BatteryState.zero()
      : header = const Header.zero(),
        voltage = 0,
        temperature = 0,
        current = 0,
        charge = 0,
        capacity = 0,
        designCapacity = 0,
        percentage = 0,
        powerSupplyStatus = PowerSupplyStatus.unknown,
        powerSupplyHealth = PowerSupplyHealth.unknown,
        powerSupplyTechnology = PowerSupplyTechnology.unknown,
        present = false,
        cellVoltage = const <double>[],
        cellTemperature = const <double>[],
        location = '',
        serialNumber = '';

  factory BatteryState.fromJson(Map<String, dynamic> json) {
    return BatteryState(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      voltage: (json['voltage'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      current: (json['current'] as num).toDouble(),
      charge: (json['charge'] as num).toDouble(),
      capacity: (json['capacity'] as num).toDouble(),
      designCapacity: (json['design_capacity'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      powerSupplyStatus: PowerSupplyStatus.fromIndex((json['power_supply_status'] as num).toInt()),
      powerSupplyHealth: PowerSupplyHealth.fromIndex((json['power_supply_health'] as num).toInt()),
      powerSupplyTechnology: PowerSupplyTechnology.fromIndex((json['power_supply_technology'] as num).toInt()),
      present: json['present'] as bool,
      cellVoltage: (json['cell_voltage'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      cellTemperature: (json['cell_temperature'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      location: json['location'] as String,
      serialNumber: json['serial_number'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'voltage': voltage,
        'temperature': temperature,
        'current': current,
        'charge': charge,
        'capacity': capacity,
        'design_capacity': designCapacity,
        'percentage': percentage,
        'power_supply_status': powerSupplyStatus.idx,
        'power_supply_health': powerSupplyHealth.idx,
        'power_supply_technology': powerSupplyTechnology.idx,
        'present': present,
        'cell_voltage': cellVoltage,
        'cell_temperature': cellTemperature,
        'location': location,
        'serial_number': serialNumber,
      };
}

class CameraInfo {
  final Header header;
  final int height;
  final int width;
  final String distortionModel;
  final List<double> d;
  final List<double> k;
  final List<double> r;
  final List<double> p;
  final int binningX;
  final int binningY;
  final RegionOfInterest roi;

  const CameraInfo({
    required this.header,
    required this.height,
    required this.width,
    required this.distortionModel,
    required this.d,
    required this.k,
    required this.r,
    required this.p,
    required this.binningX,
    required this.binningY,
    required this.roi,
  });

  const CameraInfo.zero()
      : header = const Header.zero(),
        height = 0,
        width = 0,
        distortionModel = '',
        d = const <double>[],
        k = const <double>[],
        r = const <double>[],
        p = const <double>[],
        binningX = 0,
        binningY = 0,
        roi = const RegionOfInterest.zero();

  factory CameraInfo.fromJson(Map<String, dynamic> json) {
    return CameraInfo(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      height: (json['height'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      distortionModel: json['distortion_model'] as String,
      d: (json['d'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      k: (json['k'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      r: (json['r'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      p: (json['p'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      binningX: (json['binning_x'] as num).toInt(),
      binningY: (json['binning_y'] as num).toInt(),
      roi: RegionOfInterest.fromJson(json['roi'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'height': height,
        'width': width,
        'distortion_model': distortionModel,
        'd': d,
        'k': k,
        'r': r,
        'p': p,
        'binning_x': binningX,
        'binning_y': binningY,
        'roi': roi.toJson(),
      };
}

class ChannelFloat32 {
  final String name;
  final List<double> values;

  const ChannelFloat32({required this.name, required this.values});

  const ChannelFloat32.zero() : name = '', values = const <double>[];

  factory ChannelFloat32.fromJson(Map<String, dynamic> json) {
    return ChannelFloat32(
      name: json['name'] as String,
      values: (json['values'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'values': values};
}

class CompressedImage {
  final Header header;
  final String format;
  final List<int> data;

  const CompressedImage({required this.header, required this.format, required this.data});

  const CompressedImage.zero()
      : header = const Header.zero(),
        format = '',
        data = const <int>[];

  factory CompressedImage.fromJson(Map<String, dynamic> json) {
    return CompressedImage(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      format: json['format'] as String,
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'format': format, 'data': data};
}

class FluidPressure {
  final Header header;
  final double fluidPressure;
  final double variance;

  const FluidPressure({required this.header, required this.fluidPressure, required this.variance});

  const FluidPressure.zero()
      : header = const Header.zero(),
        fluidPressure = 0,
        variance = 0;

  factory FluidPressure.fromJson(Map<String, dynamic> json) {
    return FluidPressure(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      fluidPressure: (json['fluid_pressure'] as num).toDouble(),
      variance: (json['variance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'fluid_pressure': fluidPressure,
        'variance': variance,
      };
}

class Illuminance {
  final Header header;
  final double illuminance;
  final double variance;

  const Illuminance({required this.header, required this.illuminance, required this.variance});

  const Illuminance.zero()
      : header = const Header.zero(),
        illuminance = 0,
        variance = 0;

  factory Illuminance.fromJson(Map<String, dynamic> json) {
    return Illuminance(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      illuminance: (json['illuminance'] as num).toDouble(),
      variance: (json['variance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'illuminance': illuminance,
        'variance': variance,
      };
}

class Image {
  final Header header;
  final int height;
  final int width;
  final String encoding;
  final int isBigendian;
  final int step;
  final List<int> data;

  const Image({
    required this.header,
    required this.height,
    required this.width,
    required this.encoding,
    required this.isBigendian,
    required this.step,
    required this.data,
  });

  const Image.zero()
      : header = const Header.zero(),
        height = 0,
        width = 0,
        encoding = '',
        isBigendian = 0,
        step = 0,
        data = const <int>[];

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      height: (json['height'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      encoding: json['encoding'] as String,
      isBigendian: (json['is_bigendian'] as num).toInt(),
      step: (json['step'] as num).toInt(),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'height': height,
        'width': width,
        'encoding': encoding,
        'is_bigendian': isBigendian,
        'step': step,
        'data': data,
      };
}

class Imu {
  final Header header;
  final Quaternion orientation;
  final List<double> orientationCovariance;
  final Vector3 angularVelocity;
  final List<double> angularVelocityCovariance;
  final Vector3 linearAcceleration;
  final List<double> linearAccelerationCovariance;

  const Imu({
    required this.header,
    required this.orientation,
    required this.orientationCovariance,
    required this.angularVelocity,
    required this.angularVelocityCovariance,
    required this.linearAcceleration,
    required this.linearAccelerationCovariance,
  });

  const Imu.zero()
      : header = const Header.zero(),
        orientation = const Quaternion.zero(),
        orientationCovariance = const <double>[],
        angularVelocity = const Vector3.zero(),
        angularVelocityCovariance = const <double>[],
        linearAcceleration = const Vector3.zero(),
        linearAccelerationCovariance = const <double>[];

  factory Imu.fromJson(Map<String, dynamic> json) {
    return Imu(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      orientation: Quaternion.fromJson(json['orientation'] as Map<String, dynamic>),
      orientationCovariance: (json['orientation_covariance'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      angularVelocity: Vector3.fromJson(json['angular_velocity'] as Map<String, dynamic>),
      angularVelocityCovariance: (json['angular_velocity_covariance'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      linearAcceleration: Vector3.fromJson(json['linear_acceleration'] as Map<String, dynamic>),
      linearAccelerationCovariance: (json['linear_acceleration_covariance'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'orientation': orientation.toJson(),
        'orientation_covariance': orientationCovariance,
        'angular_velocity': angularVelocity.toJson(),
        'angular_velocity_covariance': angularVelocityCovariance,
        'linear_acceleration': linearAcceleration.toJson(),
        'linear_acceleration_covariance': linearAccelerationCovariance,
      };
}

class JointState {
  final Header header;
  final List<String> name;
  final List<double> position;
  final List<double> velocity;
  final List<double> effort;

  const JointState({
    required this.header,
    required this.name,
    required this.position,
    required this.velocity,
    required this.effort,
  });

  const JointState.zero()
      : header = const Header.zero(),
        name = const <String>[],
        position = const <double>[],
        velocity = const <double>[],
        effort = const <double>[];

  factory JointState.fromJson(Map<String, dynamic> json) {
    return JointState(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      name: (json['name'] as List<dynamic>).map((e) => e as String).toList(),
      position: (json['position'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      velocity: (json['velocity'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      effort: (json['effort'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'name': name,
        'position': position,
        'velocity': velocity,
        'effort': effort,
      };
}

class JoyFeedbackArray {
  final List<JoyFeedback> array;

  const JoyFeedbackArray({required this.array});

  const JoyFeedbackArray.zero() : array = const <JoyFeedback>[];

  factory JoyFeedbackArray.fromJson(Map<String, dynamic> json) {
    return JoyFeedbackArray(
      array: (json['array'] as List<dynamic>)
          .map((e) => JoyFeedback.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {'array': array.map((e) => e.toJson()).toList()};
}

class JoyFeedback {
  static const int typeLed = 0;
  static const int typeRumble = 1;
  static const int typeBuzzer = 2;

  final int type;
  final int id;
  final double intensity;

  const JoyFeedback({required this.type, required this.id, required this.intensity});

  const JoyFeedback.zero() : type = 0, id = 0, intensity = 0;

  factory JoyFeedback.fromJson(Map<String, dynamic> json) {
    return JoyFeedback(
      type: (json['type'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      intensity: (json['intensity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'id': id, 'intensity': intensity};
}

class Joy {
  final Header header;
  final List<double> axes;
  final List<int> buttons;

  const Joy({required this.header, required this.axes, required this.buttons});

  const Joy.zero()
      : header = const Header.zero(),
        axes = const <double>[],
        buttons = const <int>[];

  factory Joy.fromJson(Map<String, dynamic> json) {
    return Joy(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      axes: (json['axes'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      buttons: (json['buttons'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'header': header.toJson(), 'axes': axes, 'buttons': buttons};
}

class LaserEcho {
  final List<double> echoes;

  const LaserEcho({required this.echoes});

  const LaserEcho.zero() : echoes = const <double>[];

  factory LaserEcho.fromJson(Map<String, dynamic> json) {
    return LaserEcho(
      echoes: (json['echoes'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'echoes': echoes};
}

class LaserScan {
  final Header header;
  final double angleMin;
  final double angleMax;
  final double angleIncrement;
  final double timeIncrement;
  final double scanTime;
  final double rangeMin;
  final double rangeMax;
  final List<double> ranges;
  final List<double> intensities;

  const LaserScan({
    required this.header,
    required this.angleMin,
    required this.angleMax,
    required this.angleIncrement,
    required this.timeIncrement,
    required this.scanTime,
    required this.rangeMin,
    required this.rangeMax,
    required this.ranges,
    required this.intensities,
  });

  const LaserScan.zero()
      : header = const Header.zero(),
        angleMin = 0,
        angleMax = 0,
        angleIncrement = 0,
        timeIncrement = 0,
        scanTime = 0,
        rangeMin = 0,
        rangeMax = 0,
        ranges = const <double>[],
        intensities = const <double>[];

  factory LaserScan.fromJson(Map<String, dynamic> json) {
    return LaserScan(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      angleMin: (json['angle_min'] as num).toDouble(),
      angleMax: (json['angle_max'] as num).toDouble(),
      angleIncrement: (json['angle_increment'] as num).toDouble(),
      timeIncrement: (json['time_increment'] as num).toDouble(),
      scanTime: (json['scan_time'] as num).toDouble(),
      rangeMin: (json['range_min'] as num).toDouble(),
      rangeMax: (json['range_max'] as num).toDouble(),
      ranges: (json['ranges'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      intensities: (json['intensities'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'angle_min': angleMin,
        'angle_max': angleMax,
        'angle_increment': angleIncrement,
        'time_increment': timeIncrement,
        'scan_time': scanTime,
        'range_min': rangeMin,
        'range_max': rangeMax,
        'ranges': ranges,
        'intensities': intensities,
      };
}

class MagneticField {
  final Header header;
  final Vector3 magneticField;
  final List<double> magneticFieldCovariance;

  const MagneticField({
    required this.header,
    required this.magneticField,
    required this.magneticFieldCovariance,
  });

  const MagneticField.zero()
      : header = const Header.zero(),
        magneticField = const Vector3.zero(),
        magneticFieldCovariance = const <double>[];

  factory MagneticField.fromJson(Map<String, dynamic> json) {
    return MagneticField(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      magneticField: Vector3.fromJson(json['magnetic_field'] as Map<String, dynamic>),
      magneticFieldCovariance: (json['magnetic_field_covariance'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'magnetic_field': magneticField.toJson(),
        'magnetic_field_covariance': magneticFieldCovariance,
      };
}

class MultiDOFJointState {
  final Header header;
  final List<String> jointNames;
  final List<Transform> transforms;
  final List<Twist> twist;
  final List<Wrench> wrench;

  const MultiDOFJointState({
    required this.header,
    required this.jointNames,
    required this.transforms,
    required this.twist,
    required this.wrench,
  });

  const MultiDOFJointState.zero()
      : header = const Header.zero(),
        jointNames = const <String>[],
        transforms = const <Transform>[],
        twist = const <Twist>[],
        wrench = const <Wrench>[];

  factory MultiDOFJointState.fromJson(Map<String, dynamic> json) {
    return MultiDOFJointState(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      jointNames: (json['joint_names'] as List<dynamic>).map((e) => e as String).toList(),
      transforms: (json['transforms'] as List<dynamic>).map((e) => Transform.fromJson(e as Map<String, dynamic>)).toList(),
      twist: (json['twist'] as List<dynamic>).map((e) => Twist.fromJson(e as Map<String, dynamic>)).toList(),
      wrench: (json['wrench'] as List<dynamic>).map((e) => Wrench.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'joint_names': jointNames,
        'transforms': transforms.map((e) => e.toJson()).toList(),
        'twist': twist.map((e) => e.toJson()).toList(),
        'wrench': wrench.map((e) => e.toJson()).toList(),
      };
}

class MultiEchoLaserScan {
  final Header header;
  final double angleMin;
  final double angleMax;
  final double angleIncrement;
  final double timeIncrement;
  final double scanTime;
  final double rangeMin;
  final double rangeMax;
  final List<LaserEcho> ranges;
  final List<LaserEcho> intensities;

  const MultiEchoLaserScan({
    required this.header,
    required this.angleMin,
    required this.angleMax,
    required this.angleIncrement,
    required this.timeIncrement,
    required this.scanTime,
    required this.rangeMin,
    required this.rangeMax,
    required this.ranges,
    required this.intensities,
  });

  const MultiEchoLaserScan.zero()
      : header = const Header.zero(),
        angleMin = 0,
        angleMax = 0,
        angleIncrement = 0,
        timeIncrement = 0,
        scanTime = 0,
        rangeMin = 0,
        rangeMax = 0,
        ranges = const <LaserEcho>[],
        intensities = const <LaserEcho>[];

  factory MultiEchoLaserScan.fromJson(Map<String, dynamic> json) {
    return MultiEchoLaserScan(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      angleMin: (json['angle_min'] as num).toDouble(),
      angleMax: (json['angle_max'] as num).toDouble(),
      angleIncrement: (json['angle_increment'] as num).toDouble(),
      timeIncrement: (json['time_increment'] as num).toDouble(),
      scanTime: (json['scan_time'] as num).toDouble(),
      rangeMin: (json['range_min'] as num).toDouble(),
      rangeMax: (json['range_max'] as num).toDouble(),
      ranges: (json['ranges'] as List<dynamic>).map((e) => LaserEcho.fromJson(e as Map<String, dynamic>)).toList(),
      intensities: (json['intensities'] as List<dynamic>).map((e) => LaserEcho.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'angle_min': angleMin,
        'angle_max': angleMax,
        'angle_increment': angleIncrement,
        'time_increment': timeIncrement,
        'scan_time': scanTime,
        'range_min': rangeMin,
        'range_max': rangeMax,
        'ranges': ranges.map((e) => e.toJson()).toList(),
        'intensities': intensities.map((e) => e.toJson()).toList(),
      };
}

class NavSatFix {
  static const int covarianceTypeUnknown = 0;
  static const int covarianceTypeApproximated = 1;
  static const int covarianceTypeDiagonalKnown = 2;
  static const int covarianceTypeKnown = 3;

  final Header header;
  final NavSatStatus status;
  final double latitude;
  final double longitude;
  final double altitude;
  final List<double> positionCovariance;
  final int positionCovarianceType;

  const NavSatFix({
    required this.header,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.positionCovariance,
    required this.positionCovarianceType,
  });

  const NavSatFix.zero()
      : header = const Header.zero(),
        status = const NavSatStatus.zero(),
        latitude = 0,
        longitude = 0,
        altitude = 0,
        positionCovariance = const <double>[],
        positionCovarianceType = 0;

  factory NavSatFix.fromJson(Map<String, dynamic> json) {
    return NavSatFix(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      status: NavSatStatus.fromJson(json['status'] as Map<String, dynamic>),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      positionCovariance: (json['position_covariance'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      positionCovarianceType: (json['position_covariance_type'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'status': status.toJson(),
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'position_covariance': positionCovariance,
        'position_covariance_type': positionCovarianceType,
      };
}

class NavSatStatus {
  static const int statusUnknown = -2;
  static const int statusNoFix = -1;
  static const int statusFix = 0;
  static const int statusSbasFix = 1;
  static const int statusGbasFix = 2;

  static const int serviceUnknown = 0;
  static const int serviceGps = 1;
  static const int serviceGlonass = 2;
  static const int serviceCompass = 4;
  static const int serviceGalileo = 8;

  final int status;
  final int service;

  const NavSatStatus({required this.status, required this.service});

  const NavSatStatus.zero() : status = 0, service = 0;

  factory NavSatStatus.fromJson(Map<String, dynamic> json) {
    return NavSatStatus(
      status: (json['status'] as num).toInt(),
      service: (json['service'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'service': service};
}

class PointCloud2 {
  final Header header;
  final int height;
  final int width;
  final List<PointField> fields;
  final bool isBigendian;
  final int pointStep;
  final int rowStep;
  final List<int> data;
  final bool isDense;

  const PointCloud2({
    required this.header,
    required this.height,
    required this.width,
    required this.fields,
    required this.isBigendian,
    required this.pointStep,
    required this.rowStep,
    required this.data,
    required this.isDense,
  });

  const PointCloud2.zero()
      : header = const Header.zero(),
        height = 0,
        width = 0,
        fields = const <PointField>[],
        isBigendian = false,
        pointStep = 0,
        rowStep = 0,
        data = const <int>[],
        isDense = false;

  factory PointCloud2.fromJson(Map<String, dynamic> json) {
    return PointCloud2(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      height: (json['height'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      fields: (json['fields'] as List<dynamic>).map((e) => PointField.fromJson(e as Map<String, dynamic>)).toList(),
      isBigendian: json['is_bigendian'] as bool,
      pointStep: (json['point_step'] as num).toInt(),
      rowStep: (json['row_step'] as num).toInt(),
      data: (json['data'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      isDense: json['is_dense'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'height': height,
        'width': width,
        'fields': fields.map((e) => e.toJson()).toList(),
        'is_bigendian': isBigendian,
        'point_step': pointStep,
        'row_step': rowStep,
        'data': data,
        'is_dense': isDense,
      };
}

class PointCloud {
  final Header header;
  final List<Point32> points;
  final List<ChannelFloat32> channels;

  const PointCloud({required this.header, required this.points, required this.channels});

  const PointCloud.zero()
      : header = const Header.zero(),
        points = const <Point32>[],
        channels = const <ChannelFloat32>[];

  factory PointCloud.fromJson(Map<String, dynamic> json) {
    return PointCloud(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      points: (json['points'] as List<dynamic>).map((e) => Point32.fromJson(e as Map<String, dynamic>)).toList(),
      channels: (json['channels'] as List<dynamic>).map((e) => ChannelFloat32.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'points': points.map((e) => e.toJson()).toList(),
        'channels': channels.map((e) => e.toJson()).toList(),
      };
}

class PointField {
  static const int int8 = 1;
  static const int uint8 = 2;
  static const int int16 = 3;
  static const int uint16 = 4;
  static const int int32 = 5;
  static const int uint32 = 6;
  static const int float32 = 7;
  static const int float64 = 8;
  static const int int64 = 9;
  static const int uint64 = 10;
  static const int boolean = 11;

  final String name;
  final int offset;
  final int datatype;
  final int count;

  const PointField({required this.name, required this.offset, required this.datatype, required this.count});

  const PointField.zero() : name = '', offset = 0, datatype = 0, count = 0;

  factory PointField.fromJson(Map<String, dynamic> json) {
    return PointField(
      name: json['name'] as String,
      offset: (json['offset'] as num).toInt(),
      datatype: (json['datatype'] as num).toInt(),
      count: (json['count'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'offset': offset, 'datatype': datatype, 'count': count};
}

class Range {
  static const int ultrasound = 0;
  static const int infrared = 1;

  final Header header;
  final int radiationType;
  final double fieldOfView;
  final double minRange;
  final double maxRange;
  final double range;
  final double variance;

  const Range({
    required this.header,
    required this.radiationType,
    required this.fieldOfView,
    required this.minRange,
    required this.maxRange,
    required this.range,
    required this.variance,
  });

  const Range.zero()
      : header = const Header.zero(),
        radiationType = 0,
        fieldOfView = 0,
        minRange = 0,
        maxRange = 0,
        range = 0,
        variance = 0;

  factory Range.fromJson(Map<String, dynamic> json) {
    return Range(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      radiationType: (json['radiation_type'] as num).toInt(),
      fieldOfView: (json['field_of_view'] as num).toDouble(),
      minRange: (json['min_range'] as num).toDouble(),
      maxRange: (json['max_range'] as num).toDouble(),
      range: (json['range'] as num).toDouble(),
      variance: (json['variance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'radiation_type': radiationType,
        'field_of_view': fieldOfView,
        'min_range': minRange,
        'max_range': maxRange,
        'range': range,
        'variance': variance,
      };
}

class RegionOfInterest {
  final int xOffset;
  final int yOffset;
  final int height;
  final int width;
  final bool doRectify;

  const RegionOfInterest({
    required this.xOffset,
    required this.yOffset,
    required this.height,
    required this.width,
    required this.doRectify,
  });

  const RegionOfInterest.zero()
      : xOffset = 0,
        yOffset = 0,
        height = 0,
        width = 0,
        doRectify = false;

  factory RegionOfInterest.fromJson(Map<String, dynamic> json) {
    return RegionOfInterest(
      xOffset: (json['x_offset'] as num).toInt(),
      yOffset: (json['y_offset'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      width: (json['width'] as num).toInt(),
      doRectify: json['do_rectify'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'x_offset': xOffset,
        'y_offset': yOffset,
        'height': height,
        'width': width,
        'do_rectify': doRectify,
      };
}

class RelativeHumidity {
  final Header header;
  final double relativeHumidity;
  final double variance;

  const RelativeHumidity({required this.header, required this.relativeHumidity, required this.variance});

  const RelativeHumidity.zero()
      : header = const Header.zero(),
        relativeHumidity = 0,
        variance = 0;

  factory RelativeHumidity.fromJson(Map<String, dynamic> json) {
    return RelativeHumidity(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      relativeHumidity: (json['relative_humidity'] as num).toDouble(),
      variance: (json['variance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'relative_humidity': relativeHumidity,
        'variance': variance,
      };
}

class Temperature {
  final Header header;
  final double temperature;
  final double variance;

  const Temperature({required this.header, required this.temperature, required this.variance});

  const Temperature.zero()
      : header = const Header.zero(),
        temperature = 0,
        variance = 0;

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      temperature: (json['temperature'] as num).toDouble(),
      variance: (json['variance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'temperature': temperature,
        'variance': variance,
      };
}

class TimeReference {
  final Header header;
  final BuiltinInterfacesTime timeRef;
  final String source;

  const TimeReference({required this.header, required this.timeRef, required this.source});

  const TimeReference.zero()
      : header = const Header.zero(),
        timeRef = const BuiltinInterfacesTime.zero(),
        source = '';

  factory TimeReference.fromJson(Map<String, dynamic> json) {
    return TimeReference(
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
      timeRef: BuiltinInterfacesTime.fromJson(json['time_ref'] as Map<String, dynamic>),
      source: json['source'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header.toJson(),
        'time_ref': timeRef.toJson(),
        'source': source,
      };
}
