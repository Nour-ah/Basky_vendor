import 'package:equatable/equatable.dart';

class TimeSlotEntity extends Equatable {
  final int id;
  final int dayOfWeek;
  final String opensAt;
  final String closesAt;

  const TimeSlotEntity({
    required this.id,
    required this.dayOfWeek,
    required this.opensAt,
    required this.closesAt,
  });

  @override
  List<Object?> get props => [id, dayOfWeek, opensAt, closesAt];
}

class AddTimeSlotParams extends Equatable {
  final int dayOfWeek;
  final String opensAt;
  final String closesAt;

  const AddTimeSlotParams({
    required this.dayOfWeek,
    required this.opensAt,
    required this.closesAt,
  });

  @override
  List<Object?> get props => [dayOfWeek, opensAt, closesAt];
}

class UpdateTimeSlotParams extends Equatable {
  final int timeSlotId;
  final int dayOfWeek;
  final String opensAt;
  final String closesAt;

  const UpdateTimeSlotParams({
    required this.timeSlotId,
    required this.dayOfWeek,
    required this.opensAt,
    required this.closesAt,
  });

  @override
  List<Object?> get props => [timeSlotId, dayOfWeek, opensAt, closesAt];
}
