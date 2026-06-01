import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/time_slot_entity.dart';
import '../repositories/time_slots_repository.dart';

class GetTimeSlotsUseCase implements UseCase<List<TimeSlotEntity>, NoParams> {
  final TimeSlotsRepository repository;

  GetTimeSlotsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TimeSlotEntity>>> call(NoParams params) {
    return repository.getTimeSlots();
  }
}

class AddTimeSlotUseCase implements UseCase<TimeSlotEntity, AddTimeSlotParams> {
  final TimeSlotsRepository repository;

  AddTimeSlotUseCase(this.repository);

  @override
  Future<Either<Failure, TimeSlotEntity>> call(AddTimeSlotParams params) {
    return repository.addTimeSlot(params);
  }
}

class UpdateTimeSlotUseCase implements UseCase<TimeSlotEntity, UpdateTimeSlotParams> {
  final TimeSlotsRepository repository;

  UpdateTimeSlotUseCase(this.repository);

  @override
  Future<Either<Failure, TimeSlotEntity>> call(UpdateTimeSlotParams params) {
    return repository.updateTimeSlot(params);
  }
}
