import '../../domain/entities/time_slot_entity.dart';

class TimeSlotModel extends TimeSlotEntity {
  const TimeSlotModel({
    required super.id,
    required super.dayOfWeek,
    required super.opensAt,
    required super.closesAt,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      dayOfWeek: json['day_of_week'] is int
          ? json['day_of_week']
          : int.tryParse(json['day_of_week']?.toString() ?? '0') ?? 0,
      opensAt: json['opens_at']?.toString().trim() ?? '',
      closesAt: json['closes_at']?.toString().trim() ?? '',
    );
  }
}
