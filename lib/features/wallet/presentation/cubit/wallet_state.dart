import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/wallet_entity.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;
  final List<TransactionEntity> history;

  const WalletLoaded({
    required this.wallet,
    required this.history,
  });

  @override
  List<Object?> get props => [wallet, history];

  WalletLoaded copyWith({
    WalletEntity? wallet,
    List<TransactionEntity>? history,
  }) {
    return WalletLoaded(
      wallet: wallet ?? this.wallet,
      history: history ?? this.history,
    );
  }
}

class WalletWithdrawalLoading extends WalletState {
  final WalletLoaded previousState;

  const WalletWithdrawalLoading(this.previousState);

  @override
  List<Object?> get props => [previousState];
}

class WalletWithdrawalSuccess extends WalletState {
  final WalletLoaded previousState;

  const WalletWithdrawalSuccess(this.previousState);

  @override
  List<Object?> get props => [previousState];
}

class WalletError extends WalletState {
  final String message;
  final Map<String, List<String>>? validationErrors;
  final WalletLoaded? previousState;

  const WalletError(this.message, {this.validationErrors, this.previousState});

  @override
  List<Object?> get props => [message, validationErrors, previousState];
}
