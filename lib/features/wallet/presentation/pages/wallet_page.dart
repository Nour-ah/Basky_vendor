import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/utils/app_snackbar_helper.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/wallet_cubit.dart';
import '../cubit/wallet_state.dart';
import '../widgets/transaction_card_widget.dart';
import '../widgets/request_withdrawal_sheet.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<WalletCubit>()..fetchWalletData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.wallet.tr(), style: AppTextStyle.fontBlack18Medium),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
              color: AppColors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state is WalletWithdrawalSuccess) {
              AppSnackBarHelper.showSuccessSnackBar(
                message: LocaleKeys.withdrawalRequestedSuccessfully.tr(),
                context: context,
              );
              Navigator.pop(context); // Close bottom sheet
            } else if (state is WalletError) {
              AppSnackBarHelper.showErrorSnackBar(message: state.message, context: context);
            }
          },
          buildWhen: (previous, current) =>
              current is WalletLoading || current is WalletLoaded || current is WalletError,
          builder: (context, state) {
            if (state is WalletLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WalletLoaded) {
              return _buildContent(context, state);
            } else if (state is WalletError && state.previousState == null) {
              return Center(child: Text(state.message, style: AppTextStyle.fontBlack14Regular));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WalletLoaded state) {
    return RefreshIndicator(
      onRefresh: () => context.read<WalletCubit>().fetchWalletData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBalanceCard(
              title: LocaleKeys.wallet_availableBalance.tr(),
              amount: state.wallet.availableBalance,
              currency: state.wallet.currency,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildBalanceCard(
                    title: LocaleKeys.wallet_pending.tr(),
                    amount: state.wallet.pendingBalance,
                    currency: state.wallet.currency,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildBalanceCard(
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

  Widget _buildBalanceCard({
    required String title,
    required double amount,
    required String currency,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyle.fontGrey14Medium.copyWith(color: color)),
          const SizedBox(height: 8),
          Text('$amount $currency', style: AppTextStyle.fontBlack24Bold.copyWith(color: color)),
        ],
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
