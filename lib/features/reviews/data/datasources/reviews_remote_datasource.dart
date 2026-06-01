import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../models/review_model.dart';

abstract class ReviewsRemoteDataSource {
  Future<ReviewsSummaryModel> getRatings();
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final Dio dio;

  ReviewsRemoteDataSourceImpl({required this.dio});

  @override
  Future<ReviewsSummaryModel> getRatings() async {
    debugPrint('🔵 ReviewsRemoteDataSource: GET ${ApiConstants.vendorRatings}');
    try {
      final response = await dio.get(ApiConstants.vendorRatings);
      final data = response.data['data'];
      return ReviewsSummaryModel.fromResponse(data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ ReviewsRemoteDataSource: $e');
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
