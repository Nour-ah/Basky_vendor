import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/validation_errors_model.dart';
import '../../../../core/network/api_constants.dart';
import '../models/transaction_model.dart';
import '../models/wallet_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getWalletDetails();
  Future<List<TransactionModel>> getWalletHistory();
  Future<void> requestWithdrawal({
    required double amount,
    required String method,
    String? notes,
  });
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final Dio dio;

  WalletRemoteDataSourceImpl({required this.dio});

  @override
  Future<WalletModel> getWalletDetails() async {
    debugPrint('🔵 WalletDataSource: Sending GET ${ApiConstants.vendorWallet}');
    try {
      final response = await dio.get(ApiConstants.vendorWallet);
      debugPrint('✅ WalletDataSource: Success fetching wallet details');
      return WalletModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ WalletDataSource: Error parsing $e');
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<List<TransactionModel>> getWalletHistory() async {
    debugPrint('🔵 WalletDataSource: Sending GET ${ApiConstants.walletHistory}');
    try {
      final response = await dio.get(ApiConstants.walletHistory);
      debugPrint('✅ WalletDataSource: Success fetching wallet history');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ WalletDataSource: Error parsing $e');
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<void> requestWithdrawal({
    required double amount,
    required String method,
    String? notes,
  }) async {
    debugPrint('🔵 WalletDataSource: Sending POST ${ApiConstants.vendorWithdrawals}');
    try {
      final formData = FormData.fromMap({
        'amount': amount,
        'method': method,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });

      await dio.post(
        ApiConstants.vendorWithdrawals,
        data: formData,
      );
      debugPrint('✅ WalletDataSource: Success requesting withdrawal');
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ WalletDataSource: Error requesting withdrawal $e');
      throw const ParsingException();
    }
  }

  void _handleDioException(DioException e) {
    debugPrint('❌ WalletDataSource: DioException ${e.type} (Code: ${e.response?.statusCode})');
    if (e.response?.statusCode == 422) {
      final validationModel = ValidationErrorsModel.fromJson(e.response?.data['errors'] ?? {});
      debugPrint('❌ WalletDataSource: Validation Error: ${validationModel.errors}');
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
