import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dummy_data.dart';

class SpiderWorldSeeAllPage extends StatelessWidget {
  const SpiderWorldSeeAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      12,
      (index) =>
          DummyData.spiderWorldImages[index %
              DummyData.spiderWorldImages.length],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.discoverSpiderWorld,
          style: AppTextStyle.heading18Bold,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 500 + ((index % 6) * 150)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (value * 0.2), // Pop-in scaling animation
                child: Opacity(opacity: value, child: child),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                items[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.greyLight,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
