import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/validation_errors_model.dart';
import '../../../../core/network/api_constants.dart';
import '../models/variant_model.dart';

abstract class VariantsRemoteDataSource {
  Future<List<VariantModel>> getVariants();
  Future<void> addVariant(String name, List<String> options);
  Future<void> updateVariant(int id, String name, List<String> options);
  Future<void> deleteVariant(int id);
}

class VariantsRemoteDataSourceImpl implements VariantsRemoteDataSource {
  final Dio dio;

  VariantsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<VariantModel>> getVariants() async {
    debugPrint('🔵 VariantsRemoteDataSource: Sending GET ${ApiConstants.vendorVariants}');
    try {
      final response = await dio.get(ApiConstants.vendorVariants);
      debugPrint('✅ VariantsRemoteDataSource: Success');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(VariantModel.fromJson)
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ VariantsRemoteDataSource: Error ${e.message}');
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ VariantsRemoteDataSource: Error $e');
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<void> addVariant(String name, List<String> options) async {
    debugPrint('🔵 VariantsRemoteDataSource: Sending POST ${ApiConstants.vendorVariants}');
    try {
      final Map<String, dynamic> data = {
        'name': name,
      };
      for (int i = 0; i < options.length; i++) {
        data['options[$i]'] = options[i];
      }
      await dio.post(
        ApiConstants.vendorVariants,
        data: FormData.fromMap(data),
      );
      debugPrint('✅ VariantsRemoteDataSource: Success');
    } on DioException catch (e) {
      debugPrint('❌ VariantsRemoteDataSource: Error ${e.message}');
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ VariantsRemoteDataSource: Error $e');
      throw const ServerException();
    }
  }

  @override
  Future<void> updateVariant(int id, String name, List<String> options) async {
    debugPrint('🔵 VariantsRemoteDataSource: Sending PUT ${ApiConstants.vendorVariants}/$id');
    try {
      final Map<String, dynamic> data = {
        'name': name,
        '_method': 'PUT', // standard Laravel workaround just in case
      };
      for (int i = 0; i < options.length; i++) {
        data['options[$i]'] = options[i];
      }
      await dio.post(
        '${ApiConstants.vendorVariants}/$id',
        data: FormData.fromMap(data),
      );
      debugPrint('✅ VariantsRemoteDataSource: Success');
    } on DioException catch (e) {
      debugPrint('❌ VariantsRemoteDataSource: Error ${e.message}');
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ VariantsRemoteDataSource: Error $e');
      throw const ServerException();
    }
  }

  @override
  Future<void> deleteVariant(int id) async {
    debugPrint('🔵 VariantsRemoteDataSource: Sending DELETE ${ApiConstants.vendorVariants}/$id');
    try {
      await dio.delete('${ApiConstants.vendorVariants}/$id');
      debugPrint('✅ VariantsRemoteDataSource: Success');
    } on DioException catch (e) {
      debugPrint('❌ VariantsRemoteDataSource: Error ${e.message}');
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ VariantsRemoteDataSource: Error $e');
      throw const ServerException();
    }
  }

  void _handleDioException(DioException e) {
    if (e.response?.statusCode == 422) {
      final validationModel = ValidationErrorsModel.fromJson(e.response?.data['errors'] ?? {});
      throw ValidationException(errors: validationModel.errors);
    } else if (e.response?.statusCode == 401) {
      throw const UnauthorizedException();
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const NetworkException();
    }
    throw ServerException(message: e.message ?? 'Server Error');
  }
}
