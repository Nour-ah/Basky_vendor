import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
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
        title: AppStrings.personalInformation,
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.list_alt,
        title: AppStrings.myOrders,
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.restaurant_outlined,
        title: AppStrings.myRestaurant,
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.account_balance_wallet_outlined,
        title: AppStrings.wallet,
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.credit_card_outlined,
        title: AppStrings.savedCards,
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.language_outlined,
        title: AppStrings.language,
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.headset_mic_outlined,
        title: AppStrings.customerService,
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.settings_outlined,
        title: AppStrings.appSettings,
        onTap: () {},
      ),
      DrawerItemModel(
        icon: Icons.shield_outlined,
        title: AppStrings.privacyPolicy,
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
                  title: AppStrings.logOut,
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
