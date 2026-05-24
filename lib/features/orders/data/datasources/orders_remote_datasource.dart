import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../../domain/entities/order_status.dart';
import '../models/order_details_model.dart';
import '../models/order_filter_result_model.dart';
import '../models/order_invoice_model.dart';
import '../models/order_summary_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderSummaryModel>> getOrders({OrderStatus? status, int page = 1, int limit = 15});
  Future<OrderFilterResultModel> getFilteredOrders({OrderStatus? status, int page = 1, int limit = 15});
  Future<OrderDetailsModel> getOrderDetails(int orderId);
  Future<OrderInvoiceModel> getOrderInvoice(int orderId);
  Future<void> updateOrderStatus({required int orderId, required OrderStatus newStatus});
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final Dio dio;

  OrdersRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<OrderSummaryModel>> getOrders({OrderStatus? status, int page = 1, int limit = 15}) async {
    debugPrint('🔵 OrdersRemoteDataSource: Sending GET ${ApiConstants.vendorOrders}');
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (status != null && status != OrderStatus.unknown) 'status': status.toApiString(),
      };

      final response = await dio.get(
        ApiConstants.vendorOrders,
        queryParameters: queryParams,
      );

      debugPrint('✅ OrdersRemoteDataSource: Success fetching orders');
      
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => OrderSummaryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ OrdersRemoteDataSource: Error $e');
      throw const ParsingException();
    }
    throw const ServerException(); // fallback
  }

  @override
  Future<OrderFilterResultModel> getFilteredOrders({OrderStatus? status, int page = 1, int limit = 15}) async {
    debugPrint('🔵 OrdersRemoteDataSource: Sending GET ${ApiConstants.vendorOrders} (filtered)');
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (status != null && status != OrderStatus.unknown) 'status': status.toApiString(),
      };

      final response = await dio.get(
        ApiConstants.vendorOrders,
        queryParameters: queryParams,
      );

      debugPrint('✅ OrdersRemoteDataSource: Success fetching filtered orders');
      return OrderFilterResultModel.fromJson(
        response.data as Map<String, dynamic>,
        appliedFilter: status ?? OrderStatus.unknown,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ OrdersRemoteDataSource: Error $e');
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<OrderDetailsModel> getOrderDetails(int orderId) async {

    debugPrint('🔵 OrdersRemoteDataSource: Sending GET ${ApiConstants.vendorOrders}/$orderId');
    try {
      final response = await dio.get('${ApiConstants.vendorOrders}/$orderId');
      debugPrint('✅ OrdersRemoteDataSource: Success fetching details');
      return OrderDetailsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ OrdersRemoteDataSource: Error $e');
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<OrderInvoiceModel> getOrderInvoice(int orderId) async {
    debugPrint('🔵 OrdersRemoteDataSource: Sending GET ${ApiConstants.vendorOrders}/$orderId/invoice');
    try {
      final response = await dio.get('${ApiConstants.vendorOrders}/$orderId/invoice');
      debugPrint('✅ OrdersRemoteDataSource: Success fetching invoice');
      return OrderInvoiceModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ OrdersRemoteDataSource: Error $e');
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<void> updateOrderStatus({required int orderId, required OrderStatus newStatus}) async {
    debugPrint('🔵 OrdersRemoteDataSource: Sending POST ${ApiConstants.vendorOrders}/$orderId/update-status');
    try {
      await dio.post(
        '${ApiConstants.vendorOrders}/$orderId/update-status',
        queryParameters: {'status': newStatus.toApiString()},
      );
      debugPrint('✅ OrdersRemoteDataSource: Success updating status');
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ OrdersRemoteDataSource: Error $e');
      throw const ParsingException();
    }
  }

  void _handleDioException(DioException e) {
    debugPrint('❌ OrdersRemoteDataSource: DioException ${e.type}');
    if (e.response?.statusCode == 401) {
      throw const UnauthorizedException();
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const NetworkException();
    }
    throw ServerException(message: e.message ?? 'Server Error');
  }
}
