/// Base class for all exceptions in the data layer
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Server exception - thrown when API returns error
class ServerException extends AppException {
  final int? statusCode;

  ServerException(super.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Cache exception - thrown when local storage operation fails
class CacheException extends AppException {
  CacheException(super.message);

  @override
  String toString() => 'CacheException: $message';
}

/// Network exception - thrown when there's no internet connection
class NetworkException extends AppException {
  NetworkException(super.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Unauthorized exception - thrown when authentication fails
class UnauthorizedException extends AppException {
  UnauthorizedException(super.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Not found exception - thrown when resource is not found
class NotFoundException extends AppException {
  NotFoundException(super.message);

  @override
  String toString() => 'NotFoundException: $message';
}
