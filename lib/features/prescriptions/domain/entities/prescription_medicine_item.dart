import 'package:equatable/equatable.dart';

class PrescriptionMedicineItem extends Equatable {
  final int id;
  final String medicineName;
  final num? price;
  final int quantity;
  final bool isAvailable;
  final String? notes;

  const PrescriptionMedicineItem({
    required this.id,
    required this.medicineName,
    this.price,
    required this.quantity,
    required this.isAvailable,
    this.notes,
  });

  num get lineTotal {
    if (!isAvailable) return 0;
    return (price ?? 0) * quantity;
  }

  @override
  List<Object?> get props =>
      [id, medicineName, price, quantity, isAvailable, notes];
}
