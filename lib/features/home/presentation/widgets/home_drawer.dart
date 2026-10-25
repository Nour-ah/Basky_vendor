import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cache_helper/local_storage.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/localization/cubit/locale_cubit.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../../auth/presentation/pages/auth_options_page.dart';
import '../../../my_restaurant/presentation/pages/my_branches_page.dart';
import '../../../my_restaurant/presentation/pages/my_products_page.dart';
import '../../../orders/presentation/pages/my_orders_page.dart';
import '../../../prescriptions/presentation/pages/vendor_prescription_requests_page.dart';
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
    this.isPharmacyVendor = false,
    this.pendingPrescriptionCount,
  });

  final String userName;
  final double userRating;
  final String userImage;
  final bool isPharmacyVendor;
  final int? pendingPrescriptionCount;

  void _navigate(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(LocaleKeys.logOut.tr()),
        content: Text(LocaleKeys.logoutConfirm.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(LocaleKeys.no.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              LocaleKeys.yes.tr(),
              style: const TextStyle(color: AppColors.promoRed),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    // Save navigator BEFORE closing drawer (context dies after pop)
    final navigator = Navigator.of(context);

    // Close the drawer
    navigator.pop();

    // Try API logout — don't block the user
    try {
      await sl<LogoutUseCase>().call().timeout(const Duration(seconds: 5));
    } catch (_) {}

    // Always clear cache and go to login
    await LocalStorage.clearAuthData();
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthOptionsPage()),
      (route) => false,
    );
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
      if (isPharmacyVendor)
        DrawerItemModel(
          icon: Icons.medication_outlined,
          title: LocaleKeys.prescriptionRequests.tr(),
          subtitle: LocaleKeys.prescriptionRequestsSubtitle.tr(),
          badgeCount: pendingPrescriptionCount,
          onTap: () =>
              _navigate(context, const VendorPrescriptionRequestsPage()),
        ),
      DrawerItemModel(
        icon: Icons.storefront_outlined,
        title: LocaleKeys.myBranches.tr(),
        onTap: () => _navigate(context, const MyBranchesPage()),
      ),
      DrawerItemModel(
        icon: Icons.inventory_2_outlined,
        title: LocaleKeys.myProducts.tr(),
        onTap: () => _navigate(context, const MyProductsPage()),
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
