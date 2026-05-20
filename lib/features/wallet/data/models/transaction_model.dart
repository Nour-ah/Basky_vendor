import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.type,
    required super.amount,
    required super.status,
    required super.createdAt,
    super.notes,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'unknown',
      amount: json['amount'] is num ? (json['amount'] as num).toDouble() : double.tryParse(json['amount']?.toString() ?? '0.0') ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at']?.toString() ?? '',
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'status': status,
      'created_at': createdAt,
      'notes': notes,
    };
  }
}
