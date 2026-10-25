import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../cache_helper/local_storage.dart';
import '../network/api_constants.dart';
import '../network/dio_error_mapper.dart';

/// Singleton API Client with debug logging
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio _dio;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl + ApiConstants.apiVersion,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        connectTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
      ),
    );

    // Add logging interceptor for debug builds
    if (kDebugMode) {
      _dio.interceptors.add(LoggingInterceptor());
    }

    // Add auth interceptor
    _dio.interceptors.add(AuthInterceptor());

    // Add language interceptor
    _dio.interceptors.add(LanguageInterceptor());
  }

  Dio get dio => _dio;

  /// Perform GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  /// Perform POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Perform PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Perform DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

/// Interceptor for adding auth token to requests
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    debugPrint('🔐 AuthInterceptor: Reading token for ${options.method} ${options.uri}');
    final token = await LocalStorage.getAuthToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      debugPrint('✅ AuthInterceptor: Authorization header attached (Bearer ${token.substring(0, 10)}...)');
    } else {
      debugPrint('⚠️ AuthInterceptor: No token found — skipping Authorization header');
    }
    super.onRequest(options, handler);
  }
}

/// Interceptor for adding language header
class LanguageInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final language = await LocalStorage.getLanguage();
    // Default to 'ar' if no language is cached
    options.headers['Accept-Language'] = language ?? 'ar';
    super.onRequest(options, handler);
  }
}

/// Interceptor for debug logging
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _printBoxTop();
    debugPrint('📤 REQUEST[${options.method}] => ${options.uri}');
    debugPrint('Headers: ${_formatHeaders(options.headers)}');
    if (options.data != null) {
      debugPrint('Body: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      debugPrint('Query: ${options.queryParameters}');
    }
    _printBoxBottom();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _printBoxTop();
    debugPrint(
      '📥 RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}',
    );
    debugPrint('Data: ${_truncateData(response.data)}');
    _printBoxBottom();
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _printBoxTop();
    debugPrint(
      '❌ ERROR[${err.response?.statusCode ?? 'N/A'}] => ${err.requestOptions.uri}',
    );
    debugPrint('Message: ${DioErrorMapper.userFacingMessage(err)}');
    if (err.response?.data != null) {
      debugPrint('Response: ${err.response?.data}');
    }
    _printBoxBottom();
    super.onError(err, handler);
  }

  void _printBoxTop() {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  void _printBoxBottom() {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  }

  String _formatHeaders(Map<String, dynamic> headers) {
    // Hide full token for security, show only first 20 chars
    final safeHeaders = Map<String, dynamic>.from(headers);
    if (safeHeaders.containsKey('Authorization')) {
      final auth = safeHeaders['Authorization'] as String;
      if (auth.length > 30) {
        safeHeaders['Authorization'] = '${auth.substring(0, 30)}...';
      }
    }
    return safeHeaders.toString();
  }

  String _truncateData(dynamic data) {
    final str = data.toString();
    if (str.length > 500) {
      return '${str.substring(0, 500)}... [TRUNCATED]';
    }
    return str;
  }
}
