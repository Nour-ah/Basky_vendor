import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_snackbar_helper.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/wallet_cubit.dart';
import '../cubit/wallet_state.dart';
import '../widgets/transaction_card_widget.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletCubit>()..fetchWalletData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.wallet.tr(), style: AppTextStyle.fontBlack18Medium),
          centerTitle: true,
        ),
        body: BlocConsumer<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state is WalletWithdrawalSuccess) {
              AppSnackBarHelper.showSuccessSnackBar(message: 'Withdrawal requested successfully', context: context);
              Navigator.pop(context); // Close bottom sheet
            } else if (state is WalletError) {
              AppSnackBarHelper.showErrorSnackBar(message: state.message, context: context);
            }
          },
          buildWhen: (previous, current) => current is WalletLoading || current is WalletLoaded || current is WalletError,
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
              title: 'Available Balance',
              amount: state.wallet.availableBalance,
              currency: state.wallet.currency,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildBalanceCard(title: 'Pending', amount: state.wallet.pendingBalance, currency: state.wallet.currency, color: Colors.orange)),
                const SizedBox(width: 16),
                Expanded(child: _buildBalanceCard(title: 'Withdrawn', amount: state.wallet.totalWithdrawn, currency: state.wallet.currency, color: AppColors.success)),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Request Withdrawal',
              onPressed: () => _showWithdrawalSheet(context),
            ),
            const SizedBox(height: 24),
            Text('Recent Transactions', style: AppTextStyle.fontBlack16Bold),
            const SizedBox(height: 12),
            if (state.history.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('No transactions yet')))
            else
              ...state.history.map((tx) => TransactionCardWidget(transaction: tx)),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard({required String title, required double amount, required String currency, required Color color}) {
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
    final amountCtrl = TextEditingController();
    final methodCtrl = TextEditingController(text: 'Bank Transfer');
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: providerContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Request Withdrawal', style: AppTextStyle.fontBlack18Medium, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: methodCtrl, decoration: const InputDecoration(labelText: 'Method', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Notes (Optional)', border: OutlineInputBorder())),
              const SizedBox(height: 24),
              BlocBuilder<WalletCubit, WalletState>(
                bloc: providerContext.read<WalletCubit>(),
                builder: (context, state) {
                  return PrimaryButton(
                    text: state is WalletWithdrawalLoading ? 'Submitting...' : 'Submit Request',
                    onPressed: state is WalletWithdrawalLoading
                        ? null
                        : () {
                            final amount = double.tryParse(amountCtrl.text);
                            if (amount == null || amount <= 0) return;
                            providerContext.read<WalletCubit>().requestWithdrawal(amount: amount, method: methodCtrl.text, notes: notesCtrl.text);
                          },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
