import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/prescription_request_status.dart';
import '../../domain/entities/vendor_prescription_requests_page.dart';
import 'vendor_prescription_request_model.dart';

class VendorPrescriptionRequestsPageModel
    extends VendorPrescriptionRequestsPage {
  const VendorPrescriptionRequestsPageModel({
    required super.data,
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.appliedFilter,
  });

  factory VendorPrescriptionRequestsPageModel.fromJson(
    Map<String, dynamic> json, {
    required PrescriptionRequestStatus appliedFilter,
  }) {
    final dataJson = json['data'] as List<dynamic>? ?? const [];
    final metaJson = json['meta'] as Map<String, dynamic>? ?? const {};

    return VendorPrescriptionRequestsPageModel(
      data: dataJson
          .whereType<Map<String, dynamic>>()
          .map(VendorPrescriptionRequestModel.fromJson)
          .toList(),
      currentPage: JsonParsers.asIntOr(metaJson['current_page'], 1),
      lastPage: JsonParsers.asIntOr(metaJson['last_page'], 1),
      perPage: JsonParsers.asIntOr(metaJson['per_page'], 15),
      total: JsonParsers.asIntOr(metaJson['total']),
      appliedFilter: appliedFilter,
    );
  }
}
