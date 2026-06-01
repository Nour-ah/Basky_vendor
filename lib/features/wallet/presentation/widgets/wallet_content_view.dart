import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/wallet_cubit.dart';
import '../cubit/wallet_state.dart';
import 'transaction_card_widget.dart';
import 'request_withdrawal_sheet.dart';
import 'wallet_balance_card.dart';

class WalletContentView extends StatelessWidget {
  final WalletLoaded state;

  const WalletContentView({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<WalletCubit>().fetchWalletData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WalletBalanceCard(
              title: LocaleKeys.wallet_availableBalance.tr(),
              amount: state.wallet.availableBalance,
              currency: state.wallet.currency,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: WalletBalanceCard(
                    title: LocaleKeys.wallet_pending.tr(),
                    amount: state.wallet.pendingBalance,
                    currency: state.wallet.currency,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: WalletBalanceCard(
                    title: LocaleKeys.wallet_withdrawn.tr(),
                    amount: state.wallet.totalWithdrawn,
                    currency: state.wallet.currency,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: LocaleKeys.wallet_requestWithdrawal.tr(),
              onPressed: () => _showWithdrawalSheet(context),
            ),
            const SizedBox(height: 24),
            Text(LocaleKeys.wallet_recentTransactions.tr(), style: AppTextStyle.fontBlack16Bold),
            const SizedBox(height: 12),
            if (state.history.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(LocaleKeys.wallet_noTransactions.tr()),
                ),
              )
            else
              ...state.history.map((tx) => TransactionCardWidget(transaction: tx)),
          ],
        ),
      ),
    );
  }

  void _showWithdrawalSheet(BuildContext providerContext) {
    showModalBottomSheet(
      context: providerContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return RequestWithdrawalSheet(walletCubit: providerContext.read<WalletCubit>());
      },
    );
  }
}
