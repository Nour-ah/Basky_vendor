import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/exceptions.dart';

/// Maps a [DioException] to the appropriate domain [Exception].
///
/// This is the ONLY place in the codebase that is allowed to
/// inspect [DioException]. Everything above the data layer must
/// only ever see [ServerException], [NetworkException],
/// [UnauthorizedException], or [ValidationException].
class DioErrorMapper {
  DioErrorMapper._();

  /// Converts a [DioException] into a domain-specific [Exception]
  /// and throws it so that the repository's catch blocks can handle it.
  static Never map(DioException e) {
    debugPrint('❌ DioErrorMapper: ${e.type} — status=${e.response?.statusCode}');

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw const NetworkException(
          message: 'Request timed out. Please check your connection.',
        );

      case DioExceptionType.connectionError:
        throw const NetworkException(
          message: 'No internet connection. Please try again.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(e);

      case DioExceptionType.cancel:
        throw const NetworkException(message: 'Request was cancelled.');

      default:
        throw ServerException(message: userFacingMessage(e));
    }
  }

  /// Short message safe for UI / snackbars / logs (never Dio boilerplate).
  static String userFacingMessage(DioException e) {
    final fromBody = _friendlyFromBody(e.response?.data);
    if (fromBody != null) return fromBody;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Request timed out. Please check your connection.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please try again.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        return switch (code) {
          401 => 'Session expired. Please login again.',
          403 => 'You do not have permission to perform this action.',
          404 => 'The requested resource was not found.',
          422 => 'Please check your input and try again.',
          500 || 502 || 503 => 'Server error. Please try again later.',
          _ => 'Something went wrong. Please try again.',
        };
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Strips Dio/HTTP boilerplate if it leaked into a failure string.
  static String sanitize(String? message) {
    final value = message?.trim() ?? '';
    if (value.isEmpty || _isDioBoilerplate(value)) {
      return 'Something went wrong. Please try again.';
    }
    return value;
  }

  static Never _handleBadResponse(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final data = e.response?.data;
    final serverMessage = _friendlyFromBody(data);

    debugPrint('❌ DioErrorMapper: HTTP $statusCode — $serverMessage');

    switch (statusCode) {
      case 401:
        throw UnauthorizedException(
          message: serverMessage ?? 'Session expired. Please login again.',
        );

      case 422:
        final errors = _extractValidationErrors(data);
        throw ValidationException(
          message: serverMessage ?? 'Please check your input and try again.',
          errors: errors,
        );

      case 403:
        throw UnauthorizedException(
          message:
              serverMessage ?? 'You do not have permission to perform this action.',
        );

      case 404:
        throw ServerException(
          message: serverMessage ?? 'The requested resource was not found.',
        );

      case 500:
      case 502:
      case 503:
        throw ServerException(
          message: serverMessage ?? 'Server error. Please try again later.',
        );

      default:
        throw ServerException(
          message: serverMessage ?? 'Something went wrong. Please try again.',
        );
    }
  }

  static String? _friendlyFromBody(dynamic data) {
    final map = _asStringKeyedMap(data);
    if (map == null) return null;

    final errors = _extractValidationErrors(map);
    if (errors.isNotEmpty) {
      final lines = errors.values.expand((e) => e).where((e) => e.trim().isNotEmpty);
      final joined = lines.join('\n');
      if (joined.isNotEmpty) return joined;
    }

    final message = map['message']?.toString().trim();
    if (message != null && message.isNotEmpty && !_isDioBoilerplate(message)) {
      return message;
    }
    return null;
  }

  static Map<String, dynamic>? _asStringKeyedMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }

  static Map<String, List<String>> _extractValidationErrors(dynamic data) {
    final map = _asStringKeyedMap(data);
    if (map == null) return {};

    final rawErrors = map['errors'];
    if (rawErrors is! Map) return {};

    final result = <String, List<String>>{};
    rawErrors.forEach((key, value) {
      if (value is List) {
        result[key.toString()] = value.map((e) => e.toString()).toList();
      } else if (value is String) {
        result[key.toString()] = [value];
      }
    });
    return result;
  }

  static bool _isDioBoilerplate(String message) {
    final lower = message.toLowerCase();
    return lower.contains('validatestatus') ||
        lower.contains('requestoptions') ||
        lower.contains('this exception was thrown because the response has a status code') ||
        lower.contains('read more about status codes at');
  }
}
