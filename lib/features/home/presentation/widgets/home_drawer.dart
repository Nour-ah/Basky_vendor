import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/localization/cubit/locale_cubit.dart';
import '../../../my_restaurant/presentation/pages/my_restaurant_page.dart';
import '../../../orders/presentation/pages/my_orders_page.dart';
import '../../../wallet/presentation/pages/wallet_page.dart';
import '../models/drawer_item_model.dart';
import 'drawer_header_widget.dart';
import 'drawer_item_widget.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    this.userName = 'Heba yasser',
    this.userRating = 5.0,
    this.userImage = 'https://randomuser.me/api/portraits/women/44.jpg',
  });

  final String userName;
  final double userRating;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    // List of drawer items
    final List<DrawerItemModel> drawerItems = [
      DrawerItemModel(
        icon: Icons.person_outline,
        title: LocaleKeys.personalInformation.tr(),
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.list_alt,
        title: LocaleKeys.myOrders.tr(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyOrdersPage()),
          );
        },
      ),
      DrawerItemModel(
        icon: Icons.restaurant_outlined,
        title: LocaleKeys.myRestaurant.tr(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyRestaurantPage()),
          );
        },
      ),
      DrawerItemModel(
        icon: Icons.account_balance_wallet_outlined,
        title: LocaleKeys.wallet.tr(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WalletPage()),
          );
        },
      ),
      DrawerItemModel(
        icon: Icons.credit_card_outlined,
        title: LocaleKeys.savedCards.tr(),
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.language_outlined,
        title: LocaleKeys.language.tr(),
        onTap: () {
          final newLangCode = context.locale.languageCode == 'ar' ? 'en' : 'ar';
          context.read<LocaleCubit>().changeLocale(newLangCode);
          Navigator.pop(context); // Close the drawer
        },
      ),
      DrawerItemModel(
        icon: Icons.headset_mic_outlined,
        title: LocaleKeys.customerService.tr(),
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.settings_outlined,
        title: LocaleKeys.appSettings.tr(),
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.shield_outlined,
        title: LocaleKeys.privacyPolicy.tr(),
        onTap: () {},
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
                  onTap: () {},
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
