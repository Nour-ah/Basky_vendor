class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server Error'});

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'Network Error'});

  @override
  String toString() => 'NetworkException: $message';
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException({this.message = 'Unauthorized'});

  @override
  String toString() => 'UnauthorizedException: $message';
}

class ParsingException implements Exception {
  final String message;
  const ParsingException({this.message = 'Parsing Error'});

  @override
  String toString() => 'ParsingException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>> errors;
  const ValidationException({this.message = 'Validation Error', this.errors = const {}});

  @override
  String toString() => 'ValidationException: $message, Errors: $errors';
}
