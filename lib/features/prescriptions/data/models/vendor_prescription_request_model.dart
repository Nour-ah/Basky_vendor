import '../../../../core/utils/api_image_url.dart';
import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/prescription_request_status.dart';
import '../../domain/entities/vendor_prescription_request.dart';
import 'prescription_address_model.dart';
import 'prescription_medicine_item_model.dart';

class VendorPrescriptionRequestModel extends VendorPrescriptionRequest {
  const VendorPrescriptionRequestModel({
    required super.id,
    required super.status,
    super.notes,
    super.image,
    super.quotedSubtotal,
    super.quotedShipping,
    super.quotedTotal,
    super.orderId,
    super.address,
    super.items,
    super.createdAt,
  });

  factory VendorPrescriptionRequestModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? const [];
    final addressJson = json['address'];

    return VendorPrescriptionRequestModel(
      id: JsonParsers.asIntOr(json['id']),
      status: PrescriptionRequestStatus.fromString(
        JsonParsers.asString(json['status']),
      ),
      notes: JsonParsers.asString(json['notes']),
      image: resolveApiImageUrl(JsonParsers.asString(json['image'])),
      quotedSubtotal: JsonParsers.asNum(json['quoted_subtotal']),
      quotedShipping: JsonParsers.asNum(json['quoted_shipping']),
      quotedTotal: JsonParsers.asNum(json['quoted_total']),
      orderId: JsonParsers.asInt(json['order_id']),
      address: addressJson is Map<String, dynamic>
          ? PrescriptionAddressModel.fromJson(addressJson)
          : null,
      items: itemsJson
          .whereType<Map<String, dynamic>>()
          .map(PrescriptionMedicineItemModel.fromJson)
          .toList(),
      createdAt: JsonParsers.asString(json['created_at']),
    );
  }
}
