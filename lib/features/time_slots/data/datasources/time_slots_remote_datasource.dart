import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_error_mapper.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/utils/time_slot_time_format.dart';
import '../models/time_slot_model.dart';

abstract class TimeSlotsRemoteDataSource {
  Future<List<TimeSlotModel>> getTimeSlots();
  Future<TimeSlotModel> addTimeSlot(AddTimeSlotParams params);
  Future<TimeSlotModel> updateTimeSlot(UpdateTimeSlotParams params);
}

class TimeSlotsRemoteDataSourceImpl implements TimeSlotsRemoteDataSource {
  final Dio dio;

  TimeSlotsRemoteDataSourceImpl({required this.dio});

  Map<String, dynamic> _slotPayload({
    required int dayOfWeek,
    required String opensAt,
    required String closesAt,
  }) {
    final opens = toApiTimeHi(opensAt);
    final closes = toApiTimeHi(closesAt);
    debugPrint(
      '🕐 TimeSlots payload: day=$dayOfWeek opens_at=$opens closes_at=$closes',
    );
    return {
      'day_of_week': dayOfWeek,
      'opens_at': opens,
      'closes_at': closes,
    };
  }

  @override
  Future<List<TimeSlotModel>> getTimeSlots() async {
    debugPrint('🔵 TimeSlotsRemoteDataSource: GET ${ApiConstants.vendorTimeSlots}');
    try {
      final response = await dio.get(ApiConstants.vendorTimeSlots);
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(TimeSlotModel.fromJson)
          .toList();
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
  }

  @override
  Future<TimeSlotModel> addTimeSlot(AddTimeSlotParams params) async {
    debugPrint('🔵 TimeSlotsRemoteDataSource: POST ${ApiConstants.vendorTimeSlots}');
    try {
      final payload = _slotPayload(
        dayOfWeek: params.dayOfWeek,
        opensAt: params.opensAt,
        closesAt: params.closesAt,
      );
      final response = await dio.post(
        ApiConstants.vendorTimeSlots,
        data: FormData.fromMap(payload),
      );
      return TimeSlotModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
  }

  @override
  Future<TimeSlotModel> updateTimeSlot(UpdateTimeSlotParams params) async {
    debugPrint(
      '🔵 TimeSlotsRemoteDataSource: PUT ${ApiConstants.vendorTimeSlots}/${params.timeSlotId}',
    );
    try {
      final payload = _slotPayload(
        dayOfWeek: params.dayOfWeek,
        opensAt: params.opensAt,
        closesAt: params.closesAt,
      );
      // Backend reads these from the query string (same as before); format must be H:i.
      final response = await dio.put(
        '${ApiConstants.vendorTimeSlots}/${params.timeSlotId}',
        queryParameters: payload,
        data: payload,
      );
      return TimeSlotModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
  }
}
