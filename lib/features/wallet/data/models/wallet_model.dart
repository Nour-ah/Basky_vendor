import '../../domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  const WalletModel({
    required super.availableBalance,
    required super.pendingBalance,
    required super.totalWithdrawn,
    super.currency,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      availableBalance: json['available_balance'] is num ? (json['available_balance'] as num).toDouble() : double.tryParse(json['available_balance']?.toString() ?? '0.0') ?? 0.0,
      pendingBalance: json['pending_balance'] is num ? (json['pending_balance'] as num).toDouble() : double.tryParse(json['pending_balance']?.toString() ?? '0.0') ?? 0.0,
      totalWithdrawn: json['total_withdrawn'] is num ? (json['total_withdrawn'] as num).toDouble() : double.tryParse(json['total_withdrawn']?.toString() ?? '0.0') ?? 0.0,
      currency: json['currency']?.toString() ?? 'EGP',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available_balance': availableBalance,
      'pending_balance': pendingBalance,
      'total_withdrawn': totalWithdrawn,
      'currency': currency,
    };
  }
}
