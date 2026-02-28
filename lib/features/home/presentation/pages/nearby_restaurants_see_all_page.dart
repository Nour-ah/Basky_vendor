import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dummy_data.dart';
import '../widgets/nearby_restaurant_item.dart';

class NearbyRestaurantsSeeAllPage extends StatelessWidget {
  const NearbyRestaurantsSeeAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate an extended dummy list for grid view
    final items = List.generate(
      15,
      (index) =>
          DummyData.nearbyRestaurants[index %
              DummyData.nearbyRestaurants.length],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.nearbyRestaurants,
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
          crossAxisCount: 3, // Shows 3 restaurants per row clearly
          mainAxisSpacing: 24,
          crossAxisSpacing: 16,
          childAspectRatio:
              0.75, // Adjusting the aspect ratio to allow both circular image and bottom text
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final rest = items[index];
          return FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topCenter,
            child: NearbyRestaurantItem(
              name: rest['name'],
              imageUrl: rest['image'],
              index:
                  index % 6, // Allows for repeating smooth staggered animation
            ),
          );
        },
      ),
    );
  }
}
