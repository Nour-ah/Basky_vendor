import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_constants.dart';
import '../models/home_stats_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeStatsModel> getHomeStats();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<HomeStatsModel> getHomeStats() async {
    debugPrint('🔵 DataSource: Sending request GET ${ApiConstants.vendorHome}');
    try {
      final response = await dio.get(ApiConstants.vendorHome);
      debugPrint('✅ DataSource: Success');
      return HomeStatsModel.fromJson(response.data['data']);
    } catch (e) {
      debugPrint('❌ DataSource: Error $e');
      rethrow;
    }
  }
}
