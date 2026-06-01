import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../models/time_slot_model.dart';

abstract class TimeSlotsRemoteDataSource {
  Future<List<TimeSlotModel>> getTimeSlots();
  Future<TimeSlotModel> addTimeSlot(AddTimeSlotParams params);
  Future<TimeSlotModel> updateTimeSlot(UpdateTimeSlotParams params);
}

class TimeSlotsRemoteDataSourceImpl implements TimeSlotsRemoteDataSource {
  final Dio dio;

  TimeSlotsRemoteDataSourceImpl({required this.dio});

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
      _handleDioException(e);
    } catch (e) {
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<TimeSlotModel> addTimeSlot(AddTimeSlotParams params) async {
    debugPrint('🔵 TimeSlotsRemoteDataSource: POST ${ApiConstants.vendorTimeSlots}');
    try {
      final response = await dio.post(
        ApiConstants.vendorTimeSlots,
        data: FormData.fromMap({
          'day_of_week': params.dayOfWeek,
          'opens_at': params.opensAt,
          'closes_at': params.closesAt,
        }),
      );
      return TimeSlotModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<TimeSlotModel> updateTimeSlot(UpdateTimeSlotParams params) async {
    debugPrint('🔵 TimeSlotsRemoteDataSource: PUT ${ApiConstants.vendorTimeSlots}/${params.timeSlotId}');
    try {
      final response = await dio.put(
        '${ApiConstants.vendorTimeSlots}/${params.timeSlotId}',
        queryParameters: {
          'day_of_week': params.dayOfWeek,
          'opens_at': params.opensAt,
          'closes_at': params.closesAt,
        },
      );
      return TimeSlotModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw const ParsingException();
    }
    throw const ServerException();
  }

  void _handleDioException(DioException e) {
    if (e.response?.statusCode == 401) throw const UnauthorizedException();
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const NetworkException();
    }
    throw ServerException(message: e.message ?? 'Server Error');
  }
}
