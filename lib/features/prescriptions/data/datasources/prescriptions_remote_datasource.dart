import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../../domain/entities/prescription_quote_item_input.dart';
import '../../domain/entities/prescription_request_status.dart';
import '../models/vendor_prescription_request_model.dart';
import '../models/vendor_prescription_requests_page_model.dart';

abstract class PrescriptionsRemoteDataSource {
  Future<VendorPrescriptionRequestsPageModel> getVendorPrescriptionRequests({
    PrescriptionRequestStatus status = PrescriptionRequestStatus.all,
    int page = 1,
    int perPage = 15,
  });

  Future<VendorPrescriptionRequestModel> getVendorPrescriptionRequestDetails(
    int requestId,
  );

  Future<VendorPrescriptionRequestModel> submitPrescriptionQuotation({
    required int requestId,
    required List<PrescriptionQuoteItemInput> items,
  });
}

class PrescriptionsRemoteDataSourceImpl
    implements PrescriptionsRemoteDataSource {
  final Dio dio;

  PrescriptionsRemoteDataSourceImpl({required this.dio});

  @override
  Future<VendorPrescriptionRequestsPageModel> getVendorPrescriptionRequests({
    PrescriptionRequestStatus status = PrescriptionRequestStatus.all,
    int page = 1,
    int perPage = 15,
  }) async {
    debugPrint(
      '🔵 PrescriptionsRemoteDataSource: GET ${ApiConstants.vendorPrescriptionRequests}',
    );
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (status.toApiString() != null) 'status': status.toApiString(),
      };

      final response = await dio.get(
        ApiConstants.vendorPrescriptionRequests,
        queryParameters: queryParams,
      );

      return VendorPrescriptionRequestsPageModel.fromJson(
        response.data as Map<String, dynamic>,
        appliedFilter: status,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ PrescriptionsRemoteDataSource: Error $e');
      throw const ParsingException();
    }
  }

  @override
  Future<VendorPrescriptionRequestModel> getVendorPrescriptionRequestDetails(
    int requestId,
  ) async {
    debugPrint(
      '🔵 PrescriptionsRemoteDataSource: GET ${ApiConstants.vendorPrescriptionRequests}/$requestId',
    );
    try {
      final response = await dio.get(
        '${ApiConstants.vendorPrescriptionRequests}/$requestId',
      );
      final data = response.data['data'];
      if (data is! Map<String, dynamic>) {
        throw const ParsingException();
      }
      return VendorPrescriptionRequestModel.fromJson(data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ PrescriptionsRemoteDataSource: Error $e');
      throw const ParsingException();
    }
  }

  @override
  Future<VendorPrescriptionRequestModel> submitPrescriptionQuotation({
    required int requestId,
    required List<PrescriptionQuoteItemInput> items,
  }) async {
    debugPrint(
      '🔵 PrescriptionsRemoteDataSource: POST ${ApiConstants.vendorPrescriptionRequests}/$requestId/quote',
    );
    try {
      final response = await dio.post(
        '${ApiConstants.vendorPrescriptionRequests}/$requestId/quote',
        data: {
          'items': items.map((e) => e.toJson()).toList(),
        },
      );
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        return VendorPrescriptionRequestModel.fromJson(data);
      }
      // Some APIs return the updated request nested or only a message.
      return getVendorPrescriptionRequestDetails(requestId);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ PrescriptionsRemoteDataSource: Error $e');
      throw const ParsingException();
    }
  }

  Never _handleDioException(DioException e) {
    debugPrint('❌ PrescriptionsRemoteDataSource: DioException ${e.type}');
    if (e.response?.statusCode == 401) {
      throw const UnauthorizedException();
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const NetworkException();
    }
    final responseData = e.response?.data;
    String errorMessage = e.message ?? 'Server Error';
    if (responseData is Map<String, dynamic>) {
      errorMessage = responseData['message']?.toString() ?? errorMessage;
    }
    throw ServerException(message: errorMessage);
  }
}
