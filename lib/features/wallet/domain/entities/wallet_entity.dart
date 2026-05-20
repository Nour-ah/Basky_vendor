import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable {
  final double availableBalance;
  final double pendingBalance;
  final double totalWithdrawn;
  final String currency;

  const WalletEntity({
    required this.availableBalance,
    required this.pendingBalance,
    required this.totalWithdrawn,
    this.currency = 'EGP',
  });

  @override
  List<Object?> get props => [
        availableBalance,
        pendingBalance,
        totalWithdrawn,
        currency,
      ];
}
