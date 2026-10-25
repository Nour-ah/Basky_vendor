import 'package:equatable/equatable.dart';
import '../../domain/entities/time_slot_entity.dart';

abstract class TimeSlotsState extends Equatable {
  const TimeSlotsState();

  @override
  List<Object?> get props => [];
}

class TimeSlotsInitial extends TimeSlotsState {}

class TimeSlotsLoading extends TimeSlotsState {}

class TimeSlotsLoaded extends TimeSlotsState {
  final List<TimeSlotEntity> slots;

  const TimeSlotsLoaded(this.slots);

  TimeSlotsLoaded copyWith({List<TimeSlotEntity>? slots}) {
    return TimeSlotsLoaded(slots ?? this.slots);
  }

  @override
  List<Object?> get props => [slots];
}

class TimeSlotsEmpty extends TimeSlotsState {}

class TimeSlotsError extends TimeSlotsState {
  final String message;
  final bool isNetworkError;

  const TimeSlotsError(this.message, {this.isNetworkError = false});

  @override
  List<Object?> get props => [message, isNetworkError];
}

/// Action (add/update) failed while keeping the current list on screen.
class TimeSlotsActionError extends TimeSlotsState {
  final String message;
  final List<TimeSlotEntity> slots;

  const TimeSlotsActionError(this.message, this.slots);

  @override
  List<Object?> get props => [message, slots];
}

class TimeSlotsActionSuccess extends TimeSlotsState {
  final String message;
  final List<TimeSlotEntity> slots;

  const TimeSlotsActionSuccess(this.message, this.slots);

  @override
  List<Object?> get props => [message, slots];
}

class TimeSlotsSubmitting extends TimeSlotsState {
  final List<TimeSlotEntity> slots;

  const TimeSlotsSubmitting(this.slots);

  @override
  List<Object?> get props => [slots];
}
