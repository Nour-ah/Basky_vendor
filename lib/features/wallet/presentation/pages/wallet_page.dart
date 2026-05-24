import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/utils/app_snackbar_helper.dart';
import '../cubit/wallet_cubit.dart';
import '../cubit/wallet_state.dart';
import '../widgets/wallet_content_view.dart';

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
              return WalletContentView(state: state);
            } else if (state is WalletError && state.previousState == null) {
              return Center(child: Text(state.message, style: AppTextStyle.fontBlack14Regular));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

