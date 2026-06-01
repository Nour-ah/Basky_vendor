import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../core/widgets/state_view_widget.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<AuthCubit>()..getCurrentUser(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
              color: AppColors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            LocaleKeys.personalInformation.tr(),
            style: AppTextStyle.fontBlack16Bold,
          ),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AuthError) {
              return StateViewWidget(
                message: state.message,
                icon: Icons.error_outline,
                onRetry: () => context.read<AuthCubit>().getCurrentUser(),
              );
            }
            if (state is AuthUserLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (user.image != null && user.image!.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Scaffold(
                                backgroundColor: Colors.black,
                                appBar: AppBar(
                                  backgroundColor: Colors.transparent,
                                  iconTheme: const IconThemeData(color: Colors.white),
                                ),
                                body: Center(
                                  child: InteractiveViewer(
                                    child: Hero(
                                      tag: 'profile_pic',
                                      child: CustomImageView(
                                        imagePath: user.image!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Hero(
                        tag: 'profile_pic',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: CustomImageView(
                            imagePath: user.image ?? '',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(user.name, style: AppTextStyle.fontBlack18Medium),
                    const SizedBox(height: 24),
                    _ProfileTile(
                      icon: Icons.email_outlined,
                      label: LocaleKeys.email.tr(),
                      value: user.email,
                    ),
                    _ProfileTile(
                      icon: Icons.phone_outlined,
                      label: LocaleKeys.phoneNumber.tr(),
                      value: user.phone.isNotEmpty
                          ? user.phone
                          : LocaleKeys.notAvailable.tr(),
                    ),
                    _ProfileTile(
                      icon: Icons.verified_outlined,
                      label: LocaleKeys.emailVerified.tr(),
                      value: user.emailVerifiedAt != null
                          ? LocaleKeys.yes.tr()
                          : LocaleKeys.no.tr(),
                    ),
                    _ProfileTile(
                      icon: Icons.phone_android_outlined,
                      label: LocaleKeys.phoneVerified.tr(),
                      value: user.phoneVerifiedAt != null
                          ? LocaleKeys.yes.tr()
                          : LocaleKeys.no.tr(),
                    ),
                    _ProfileTile(
                      icon: Icons.admin_panel_settings_outlined,
                      label: LocaleKeys.roles.tr(),
                      value: user.roles.join(', '),
                    ),
                    _ProfileTile(
                      icon: Icons.check_circle_outline,
                      label: LocaleKeys.accountStatus.tr(),
                      value: user.isVerified ? LocaleKeys.yes.tr() : LocaleKeys.no.tr(),
                    ),
                    _ProfileTile(
                      icon: Icons.power_settings_new_outlined,
                      label: LocaleKeys.activeStatus.tr(),
                      value: user.isActive ? LocaleKeys.active.tr() : LocaleKeys.inactive.tr(),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyle.fontGrey12Regular),
                Text(value, style: AppTextStyle.fontBlack14Regular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
