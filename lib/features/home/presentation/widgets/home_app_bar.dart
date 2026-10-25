import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:basky_vendor/core/theme/app_text_styles.dart';
import 'package:basky_vendor/core/widgets/custom_image_view.dart';
import 'package:basky_vendor/core/widgets/marquee_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_images.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.scaffoldKey,
    required this.userName,
    required this.userAddress,
    this.userImageUrl,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String userName;
  final String userAddress;
  final String? userImageUrl;

  static const double _toolbarHeight = 80;

  @override
  Widget build(BuildContext context) {
    final imageUrl = userImageUrl?.trim() ?? '';
    final now = DateTime.now();
    final dateString = DateFormat(
      'EEEE, d MMM',
      context.locale.languageCode,
    ).format(now);

    return AppBar(
      elevation: 0,
      toolbarHeight: _toolbarHeight,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.white),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: GestureDetector(
        onTap: () {
          scaffoldKey.currentState?.openDrawer();
        },
        child: Row(
          children: [
            _ProfileAvatar(imageUrl: imageUrl, radius: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'welcomeBack'.tr(),
                    style: AppTextStyle.fontWhite12Regular.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  MarqueeWidget(
                    child: Text(
                      userName,
                      style: AppTextStyle.fontWhite16Bold.copyWith(height: 1.2),
                    ),
                  ),
                  Text(
                    dateString,
                    style: AppTextStyle.fontWhite12Regular.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const CustomImageView(
                imagePath: AppImages.notification,
                fit: BoxFit.scaleDown,
                width: 22,
                height: 22,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
              },
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_toolbarHeight);
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.imageUrl, required this.radius});

  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    final hasNetworkImage =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.white.withValues(alpha: 0.2),
        child: hasNetworkImage
            ? ClipOval(
                child: CustomImageView(
                  imagePath: imageUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(Icons.person, size: radius * 0.95, color: AppColors.white),
      ),
    );
  }
}
