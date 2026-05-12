class BuiltinInterfacesTime {
  final int sec;
  final int nanosec;

  const BuiltinInterfacesTime({required this.sec, required this.nanosec});

  static const zero = BuiltinInterfacesTime(sec: 0, nanosec: 0);

  factory BuiltinInterfacesTime.fromJson(Map<String, dynamic> json) {
    return BuiltinInterfacesTime(
      sec: (json['sec'] as num).toInt(),
      nanosec: (json['nanosec'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {'sec': sec, 'nanosec': nanosec};
}
