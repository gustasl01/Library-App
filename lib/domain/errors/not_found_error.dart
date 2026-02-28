class NotFoundError implements Exception {
  final String message;

  NotFoundError(this.message);

  @override
  String toString() => message;
}
