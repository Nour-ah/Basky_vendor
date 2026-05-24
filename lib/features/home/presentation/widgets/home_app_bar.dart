import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:spider_restaurant/core/theme/app_text_styles.dart';
import 'package:spider_restaurant/core/widgets/custom_image_view.dart';
import '../../../../core/theme/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    final imageUrl = userImageUrl?.trim() ?? '';
    final now = DateTime.now();
    final dateString = DateFormat('EEEE, d MMM', context.locale.languageCode).format(now);

    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)],
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
      title: Row(
        children: [
          _ProfileAvatar(imageUrl: imageUrl, radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'greetUser'.tr(namedArgs: {'name': userName}),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.fontWhite16Bold,
                ),
                const SizedBox(height: 2),
                Text(
                  dateString,
                  style: AppTextStyle.fontWhite12Regular.copyWith(
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.white, size: 22),
            onPressed: () {},
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
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
        border: Border.all(color: AppColors.white.withValues(alpha: 0.5), width: 2),
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

