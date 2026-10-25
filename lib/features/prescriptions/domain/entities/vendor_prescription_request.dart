import 'package:equatable/equatable.dart';
import 'prescription_address.dart';
import 'prescription_medicine_item.dart';
import 'prescription_request_status.dart';

class VendorPrescriptionRequest extends Equatable {
  final int id;
  final PrescriptionRequestStatus status;
  final String? notes;
  final String? image;
  final num? quotedSubtotal;
  final num? quotedShipping;
  final num? quotedTotal;
  final int? orderId;
  final PrescriptionAddress? address;
  final List<PrescriptionMedicineItem> items;
  final String? createdAt;

  const VendorPrescriptionRequest({
    required this.id,
    required this.status,
    this.notes,
    this.image,
    this.quotedSubtotal,
    this.quotedShipping,
    this.quotedTotal,
    this.orderId,
    this.address,
    this.items = const [],
    this.createdAt,
  });

  List<PrescriptionMedicineItem> get availableItems =>
      items.where((item) => item.isAvailable).toList();

  List<PrescriptionMedicineItem> get unavailableItems =>
      items.where((item) => !item.isAvailable).toList();

  @override
  List<Object?> get props => [
        id,
        status,
        notes,
        image,
        quotedSubtotal,
        quotedShipping,
        quotedTotal,
        orderId,
        address,
        items,
        createdAt,
      ];
}
