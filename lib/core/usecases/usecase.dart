import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base UseCase class for all use cases in the application
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// NoParams class for use cases that don't require parameters
class NoParams {}
