import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({
    super.key,
    required this.userName,
    required this.userRating,
    required this.userImage,
    required this.onClosePressed,
  });

  final String userName;
  final double userRating;
  final String userImage;
  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.greyLight, width: 2),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(userImage), // placeholder
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(userName, style: AppTextStyle.fontPrimary16Bold),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      userRating.toStringAsFixed(1),
                      style: AppTextStyle.fontPrimary12Regular.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, color: AppColors.yellow, size: 14),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.primary, size: 20),
            onPressed: onClosePressed,
          ),
        ],
      ),
    );
  }
}
