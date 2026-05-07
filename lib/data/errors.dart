enum ConnectError {
  sseError('SSE Error');
  const ConnectError(this.label);
  final String label;
}
