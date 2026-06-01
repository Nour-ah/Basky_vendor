import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/usecases/time_slots_usecases.dart';
import 'time_slots_state.dart';

class TimeSlotsCubit extends Cubit<TimeSlotsState> {
  final GetTimeSlotsUseCase getTimeSlotsUseCase;
  final AddTimeSlotUseCase addTimeSlotUseCase;
  final UpdateTimeSlotUseCase updateTimeSlotUseCase;

  TimeSlotsCubit({
    required this.getTimeSlotsUseCase,
    required this.addTimeSlotUseCase,
    required this.updateTimeSlotUseCase,
  }) : super(TimeSlotsInitial());

  Future<void> fetchTimeSlots() async {
    if (isClosed) return;
    emit(TimeSlotsLoading());

    final result = await getTimeSlotsUseCase(NoParams());
    if (isClosed) return;

    result.fold(
      (failure) => emit(TimeSlotsError(
        failure.message,
        isNetworkError: failure is NetworkFailure,
      )),
      (slots) {
        if (slots.isEmpty) {
          emit(TimeSlotsEmpty());
        } else {
          emit(TimeSlotsLoaded(slots));
        }
      },
    );
  }

  Future<void> addSlot(AddTimeSlotParams params) async {
    if (isClosed) return;
    final currentSlots = _currentSlots();
    emit(TimeSlotsSubmitting(currentSlots));

    final result = await addTimeSlotUseCase(params);
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(TimeSlotsError(failure.message)),
      (_) async => await fetchTimeSlots(),
    );
  }

  Future<void> updateSlot(UpdateTimeSlotParams params) async {
    if (isClosed) return;
    final currentSlots = _currentSlots();
    emit(TimeSlotsSubmitting(currentSlots));

    final result = await updateTimeSlotUseCase(params);
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(TimeSlotsError(failure.message)),
      (_) async => await fetchTimeSlots(),
    );
  }

  List<TimeSlotEntity> _currentSlots() {
    final state = this.state;
    if (state is TimeSlotsLoaded) return state.slots;
    if (state is TimeSlotsSubmitting) return state.slots;
    return [];
  }
}
