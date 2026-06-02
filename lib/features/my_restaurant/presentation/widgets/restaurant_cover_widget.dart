import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/safe_network_image.dart';

class RestaurantCoverWidget extends StatelessWidget {
  final String coverImageUrl;
  final VoidCallback onBackPressed;

  const RestaurantCoverWidget({
    super.key,
    required this.coverImageUrl,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeNetworkImage(
          imageUrl: coverImageUrl,
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          placeholderIcon: Icons.storefront_outlined,
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildDot(true), _buildDot(false), _buildDot(false)],
          ),
        ),
        // Positioned(
        //   top: 50,
        //   left: 16,
        //   child: GestureDetector(
        //     onTap: onBackPressed,
        //     child: Container(
        //       padding: const EdgeInsets.all(8),
        //       decoration: BoxDecoration(
        //         color: AppColors.white.withValues(alpha: 0.9),
        //         shape: BoxShape.circle,
        //       ),
        //       child: const Icon(
        //
        //         Icons.arrow_back_ios,
        //         color: AppColors.black,
        //         size: 20,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: isActive ? 16 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? AppColors.red : AppColors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
