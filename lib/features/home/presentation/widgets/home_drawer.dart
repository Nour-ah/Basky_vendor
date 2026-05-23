import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/localization/cubit/locale_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/presentation/pages/auth_options_page.dart';
import '../../../my_restaurant/presentation/pages/my_restaurant_page.dart';
import '../../../orders/presentation/pages/my_orders_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../reports/presentation/pages/reports_page.dart';
import '../../../reviews/presentation/pages/reviews_page.dart';
import '../../../time_slots/presentation/pages/time_slots_page.dart';
import '../../../wallet/presentation/pages/wallet_page.dart';
import '../models/drawer_item_model.dart';
import 'drawer_header_widget.dart';
import 'drawer_item_widget.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.userName,
    required this.userRating,
    required this.userImage,
  });

  final String userName;
  final double userRating;
  final String userImage;

  void _navigate(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _handleLogout(BuildContext context) async {
    Navigator.pop(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.logOut.tr()),
        content: Text(LocaleKeys.logoutConfirm.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(LocaleKeys.no.tr())),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(LocaleKeys.yes.tr())),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final authCubit = sl<AuthCubit>();
    await authCubit.logout();
    if (!context.mounted) return;

    final state = authCubit.state;
    if (state is AuthLogoutSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthOptionsPage()),
        (route) => false,
      );
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: AppColors.promoRed),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DrawerItemModel> drawerItems = [
      DrawerItemModel(
        icon: Icons.person_outline,
        title: LocaleKeys.personalInformation.tr(),
        onTap: () => _navigate(context, const ProfilePage()),
      ),
      DrawerItemModel(
        icon: Icons.list_alt,
        title: LocaleKeys.myOrders.tr(),
        onTap: () => _navigate(context, const MyOrdersPage()),
      ),
      DrawerItemModel(
        icon: Icons.restaurant_outlined,
        title: LocaleKeys.myRestaurant.tr(),
        onTap: () => _navigate(context, const MyRestaurantPage()),
      ),
      DrawerItemModel(
        icon: Icons.account_balance_wallet_outlined,
        title: LocaleKeys.wallet.tr(),
        onTap: () => _navigate(context, const WalletPage()),
      ),
      DrawerItemModel(
        icon: Icons.star_outline,
        title: LocaleKeys.reviews.tr(),
        onTap: () => _navigate(context, const ReviewsPage()),
      ),
      DrawerItemModel(
        icon: Icons.bar_chart_outlined,
        title: LocaleKeys.reports.tr(),
        onTap: () => _navigate(context, const ReportsPage()),
      ),
      DrawerItemModel(
        icon: Icons.schedule_outlined,
        title: LocaleKeys.timeSlots.tr(),
        onTap: () => _navigate(context, const TimeSlotsPage()),
      ),
      DrawerItemModel(
        icon: Icons.language_outlined,
        title: LocaleKeys.language.tr(),
        onTap: () {
          final newLangCode = context.locale.languageCode == 'ar' ? 'en' : 'ar';
          context.read<LocaleCubit>().changeLocale(newLangCode);
          Navigator.pop(context);
        },
      ),
    ];

    return Drawer(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeaderWidget(
              userName: userName,
              userRating: userRating,
              userImage: userImage,
              onClosePressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: drawerItems.length,
                itemBuilder: (context, index) {
                  return DrawerItemWidget(
                    item: drawerItems[index],
                    textStyle: AppTextStyle.fontBlack14Regular.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: DrawerItemWidget(
                item: DrawerItemModel(
                  icon: Icons.logout_outlined,
                  title: LocaleKeys.logOut.tr(),
                  onTap: () => _handleLogout(context),
                ),
                textStyle: AppTextStyle.fontPrimary14Regular.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                trailingColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
