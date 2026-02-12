class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache operation failed']);

  @override
  String toString() => 'CacheException: $message';
}

class ServerException implements Exception {
  final String message;

  const ServerException([this.message = 'Server operation failed']);

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'Network operation failed']);

  @override
  String toString() => 'NetworkException: $message';
}
