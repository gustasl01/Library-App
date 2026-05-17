class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class AppAuthException implements Exception {
  final String message;
  const AppAuthException(this.message);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);
}
