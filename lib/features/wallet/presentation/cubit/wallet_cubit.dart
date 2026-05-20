import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_wallet_details_usecase.dart';
import '../../domain/usecases/get_wallet_history_usecase.dart';
import '../../domain/usecases/request_withdrawal_usecase.dart';
import 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final GetWalletDetailsUseCase getWalletDetailsUseCase;
  final GetWalletHistoryUseCase getWalletHistoryUseCase;
  final RequestWithdrawalUseCase requestWithdrawalUseCase;

  WalletCubit({
    required this.getWalletDetailsUseCase,
    required this.getWalletHistoryUseCase,
    required this.requestWithdrawalUseCase,
  }) : super(WalletInitial());

  Future<void> fetchWalletData() async {
    if (isClosed) return;
    emit(WalletLoading());

    final walletResult = await getWalletDetailsUseCase();
    
    walletResult.fold(
      (failure) => _emitError(failure),
      (wallet) async {
        final historyResult = await getWalletHistoryUseCase();
        historyResult.fold(
          (failure) => _emitError(failure),
          (history) {
            if (!isClosed) {
              emit(WalletLoaded(wallet: wallet, history: history));
            }
          },
        );
      },
    );
  }

  Future<void> requestWithdrawal({
    required double amount,
    required String method,
    String? notes,
  }) async {
    if (isClosed) return;
    if (state is! WalletLoaded) return;

    final currentState = state as WalletLoaded;
    emit(WalletWithdrawalLoading(currentState));

    final result = await requestWithdrawalUseCase(
      amount: amount,
      method: method,
      notes: notes,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(WalletError(failure.message, validationErrors: failure.errors, previousState: currentState));
        } else {
          emit(WalletError(failure.message, previousState: currentState));
        }
        // Rollback to loaded view so UI doesn't break
        emit(currentState);
      },
      (_) {
        emit(WalletWithdrawalSuccess(currentState));
        // Refresh wallet data automatically after successful withdrawal
        fetchWalletData();
      },
    );
  }

  void _emitError(Failure failure) {
    if (isClosed) return;
    emit(WalletError(failure.message));
  }
}
