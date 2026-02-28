import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dummy_data.dart';
import '../pages/trending_places_see_all_page.dart';
import 'trending_place_card.dart';

class TrendingPlacesSection extends StatelessWidget {
  const TrendingPlacesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.discoverTrendingPlaces,
                style: AppTextStyle.heading18Bold,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrendingPlacesSeeAllPage(),
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
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: DummyData.trendingPlaces.length,
            itemBuilder: (context, index) {
              final place = DummyData.trendingPlaces[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TrendingPlaceCard(
                  title: place['title'],
                  imageUrl: place['image'],
                  distance: place['distance'],
                  price: place['price'],
                  rating: place['rating'],
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
