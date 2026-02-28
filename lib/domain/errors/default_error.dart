class DefaultError implements Exception {
  final String message;

  DefaultError(this.message);

  @override
  String toString() => message;
}
