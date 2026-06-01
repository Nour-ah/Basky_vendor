import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/repositories/time_slots_repository.dart';
import '../datasources/time_slots_remote_datasource.dart';

class TimeSlotsRepositoryImpl implements TimeSlotsRepository {
  final TimeSlotsRemoteDataSource remoteDataSource;

  TimeSlotsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TimeSlotEntity>>> getTimeSlots() {
    return _execute(() => remoteDataSource.getTimeSlots());
  }

  @override
  Future<Either<Failure, TimeSlotEntity>> addTimeSlot(AddTimeSlotParams params) {
    return _execute(() => remoteDataSource.addTimeSlot(params));
  }

  @override
  Future<Either<Failure, TimeSlotEntity>> updateTimeSlot(UpdateTimeSlotParams params) {
    return _execute(() => remoteDataSource.updateTimeSlot(params));
  }

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
