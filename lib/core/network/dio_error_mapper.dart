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
      // ── No internet / timeout ──────────────────────────────────
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw const NetworkException(message: 'Request timed out. Please check your connection.');

      case DioExceptionType.connectionError:
        throw const NetworkException(message: 'No internet connection. Please try again.');

      // ── Server returned an HTTP error ──────────────────────────
      case DioExceptionType.badResponse:
        return _handleBadResponse(e);

      // ── Request was cancelled ──────────────────────────────────
      case DioExceptionType.cancel:
        throw const NetworkException(message: 'Request was cancelled.');

      // ── Anything else ─────────────────────────────────────────
      default:
        throw ServerException(
          message: e.message ?? 'An unexpected error occurred.',
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static Never _handleBadResponse(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final data = e.response?.data;

    // Extract server message from response body
    final serverMessage = _extractMessage(data);

    debugPrint('❌ DioErrorMapper: HTTP $statusCode — $serverMessage');

    switch (statusCode) {
      case 401:
        throw UnauthorizedException(
          message: serverMessage ?? 'Session expired. Please login again.',
        );

      case 422:
        // Validation errors — extract field-level errors map
        final errors = _extractValidationErrors(data);
        throw ValidationException(
          message: serverMessage ?? 'Validation failed.',
          errors: errors,
        );

      case 403:
        throw UnauthorizedException(
          message: serverMessage ?? 'You do not have permission to perform this action.',
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
          message: serverMessage ?? 'Unexpected server error (HTTP $statusCode).',
        );
    }
  }

  /// Extracts the `message` field from the API response body.
  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return null;
  }

  /// Extracts field-level validation errors from a 422 response body.
  /// Expects format: `{ "errors": { "field": ["msg1", "msg2"] } }`
  static Map<String, List<String>> _extractValidationErrors(dynamic data) {
    if (data is! Map<String, dynamic>) return {};

    final rawErrors = data['errors'];
    if (rawErrors is! Map<String, dynamic>) return {};

    final result = <String, List<String>>{};
    rawErrors.forEach((key, value) {
      if (value is List) {
        result[key] = value.map((e) => e.toString()).toList();
      } else if (value is String) {
        result[key] = [value];
      }
    });
    return result;
  }
}
