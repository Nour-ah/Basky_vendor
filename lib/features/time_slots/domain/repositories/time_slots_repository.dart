import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/time_slot_entity.dart';

abstract class TimeSlotsRepository {
  Future<Either<Failure, List<TimeSlotEntity>>> getTimeSlots();
  Future<Either<Failure, TimeSlotEntity>> addTimeSlot(AddTimeSlotParams params);
  Future<Either<Failure, TimeSlotEntity>> updateTimeSlot(UpdateTimeSlotParams params);
}
