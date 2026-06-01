import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../models/reports_summary_model.dart';

abstract class ReportsRemoteDataSource {
  Future<ReportsSummaryModel> getSummary({required String range});
}

class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final Dio dio;

  ReportsRemoteDataSourceImpl({required this.dio});

  @override
  Future<ReportsSummaryModel> getSummary({required String range}) async {
    debugPrint('🔵 ReportsRemoteDataSource: GET ${ApiConstants.vendorReports}?range=$range');
    try {
      final response = await dio.get(
        ApiConstants.vendorReports,
        queryParameters: {'range': range},
      );
      return ReportsSummaryModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
        range: range,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ ReportsRemoteDataSource: $e');
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
