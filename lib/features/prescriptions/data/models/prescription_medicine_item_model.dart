import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/prescription_medicine_item.dart';

class PrescriptionMedicineItemModel extends PrescriptionMedicineItem {
  const PrescriptionMedicineItemModel({
    required super.id,
    required super.medicineName,
    super.price,
    required super.quantity,
    required super.isAvailable,
    super.notes,
  });

  factory PrescriptionMedicineItemModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionMedicineItemModel(
      id: JsonParsers.asIntOr(json['id']),
      medicineName: JsonParsers.asString(json['medicine_name']) ?? '',
      price: JsonParsers.asNum(json['price']),
      quantity: JsonParsers.asIntOr(json['quantity'], 1),
      isAvailable: JsonParsers.asBool(json['is_available'], fallback: true),
      notes: JsonParsers.asString(json['notes']),
    );
  }
}
