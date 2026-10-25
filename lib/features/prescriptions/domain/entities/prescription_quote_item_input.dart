import 'package:equatable/equatable.dart';

class PrescriptionQuoteItemInput extends Equatable {
  final String medicineName;
  final bool isAvailable;
  final num? price;
  final int quantity;
  final String? notes;

  const PrescriptionQuoteItemInput({
    required this.medicineName,
    required this.isAvailable,
    this.price,
    required this.quantity,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'medicine_name': medicineName,
        'is_available': isAvailable,
        'price': isAvailable ? (price ?? 0) : (price ?? 0),
        'quantity': quantity,
        'notes': notes,
      };

  @override
  List<Object?> get props =>
      [medicineName, isAvailable, price, quantity, notes];
}
