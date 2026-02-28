import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Using Equatable for value comparison
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Server failure - when API returns error
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Cache failure - when local storage operation fails
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Network failure - when there's no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Validation failure - when input validation fails
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Unauthorized failure - when user is not authenticated
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

/// Not found failure - when resource is not found (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}
