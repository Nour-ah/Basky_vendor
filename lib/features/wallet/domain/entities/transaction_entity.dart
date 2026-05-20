import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String type;
  final double amount;
  final String status;
  final String createdAt;
  final String? notes;

  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        amount,
        status,
        createdAt,
        notes,
      ];
}
