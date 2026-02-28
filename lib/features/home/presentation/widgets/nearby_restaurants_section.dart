import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dummy_data.dart';
import '../pages/nearby_restaurants_see_all_page.dart';
import 'nearby_restaurant_item.dart';

class NearbyRestaurantsSection extends StatelessWidget {
  const NearbyRestaurantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.nearbyRestaurants,
                style: AppTextStyle.heading18Bold,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NearbyRestaurantsSeeAllPage(),
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 125, // equivalent height to category item
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: DummyData.nearbyRestaurants.length,
            itemBuilder: (context, index) {
              final rest = DummyData.nearbyRestaurants[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: NearbyRestaurantItem(
                  name: rest['name'],
                  imageUrl: rest['image'],
                  index: index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
