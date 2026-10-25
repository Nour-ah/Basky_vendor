import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../models/app_notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<AppNotificationModel>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final Dio dio;

  NotificationsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AppNotificationModel>> getNotifications() async {
    try {
      final response = await dio.get(ApiConstants.notifications);
      final raw = response.data;
      final list = _extractList(raw);
      return list
          .whereType<Map>()
          .map((e) => AppNotificationModel.fromJson(Map<String, dynamic>.from(e)))
          .where((n) => n.id.isNotEmpty)
          .toList();
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('Notifications parse error: $e');
      throw const ParsingException();
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await dio.post(ApiConstants.notificationRead(notificationId));
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await dio.post(ApiConstants.notificationsReadAll);
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  List<dynamic> _extractList(dynamic raw) {
    if (raw is List) return raw;
    if (raw is Map<String, dynamic>) {
      final data = raw['data'];
      if (data is List) return data;
      if (data is Map && data['data'] is List) {
        return data['data'] as List;
      }
      if (data is Map && data['notifications'] is List) {
        return data['notifications'] as List;
      }
    }
    return const [];
  }

  Never _handleDioException(DioException e) {
    if (e.response?.statusCode == 401) {
      throw const UnauthorizedException();
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const NetworkException();
    }
    final responseData = e.response?.data;
    String message = e.message ?? 'Server Error';
    if (responseData is Map<String, dynamic>) {
      message = responseData['message']?.toString() ?? message;
    }
    throw ServerException(message: message);
  }
}
