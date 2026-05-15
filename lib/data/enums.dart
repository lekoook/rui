enum RobotConnectionStatus {
  disconnected('Disconnected'),
  connected('Connected'),
  connecting('Connecting');
  const RobotConnectionStatus(this.label);
  final String label;
}

enum MapMode {
  localization(0, 'Localization'),
  mapping(1, 'Mapping');
  const MapMode(this.idx, this.label);
  factory MapMode.fromIndex(int idx) {
    return values.firstWhere(
      (e) => e.idx == idx,
      orElse: () => MapMode.localization,
    );
  }
  final int idx;
  final String label;
}

enum AutonomyStatus {
  unknown('Unknown'),
  manual('Manual'),
  idle('Idle'),
  auto('Auto');
  const AutonomyStatus(this.label);
  final String label;
}
