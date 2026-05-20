import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/wallet_cubit.dart';
import '../cubit/wallet_state.dart';

class RequestWithdrawalSheet extends StatefulWidget {
  final WalletCubit walletCubit;

  const RequestWithdrawalSheet({super.key, required this.walletCubit});

  @override
  State<RequestWithdrawalSheet> createState() => _RequestWithdrawalSheetState();
}

class _RequestWithdrawalSheetState extends State<RequestWithdrawalSheet> {
  final _amountCtrl = TextEditingController();
  final _methodCtrl = TextEditingController(text: 'Bank Transfer');
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _methodCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LocaleKeys.wallet_requestWithdrawal.tr(),
            style: AppTextStyle.fontBlack18Medium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: LocaleKeys.wallet_amount.tr(),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _methodCtrl,
            decoration: InputDecoration(
              labelText: LocaleKeys.wallet_method.tr(),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesCtrl,
            decoration: InputDecoration(
              labelText: LocaleKeys.wallet_notes.tr(),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          BlocBuilder<WalletCubit, WalletState>(
            bloc: widget.walletCubit,
            builder: (context, state) {
              final isLoading = state is WalletWithdrawalLoading;
              return PrimaryButton(
                text: isLoading
                    ? LocaleKeys.wallet_submitting.tr()
                    : LocaleKeys.wallet_submitRequest.tr(),
                onPressed: isLoading
                    ? null
                    : () {
                        final amount = double.tryParse(_amountCtrl.text);
                        if (amount == null || amount <= 0) return;
                        widget.walletCubit.requestWithdrawal(
                          amount: amount,
                          method: _methodCtrl.text,
                          notes: _notesCtrl.text,
                        );
                      },
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
