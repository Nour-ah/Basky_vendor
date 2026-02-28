import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dummy_data.dart';
import '../widgets/trending_place_card.dart';

class TrendingPlacesSeeAllPage extends StatelessWidget {
  const TrendingPlacesSeeAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate an extended dummy list for demonstration
    final items = List.generate(
      12,
      (index) =>
          DummyData.trendingPlaces[index % DummyData.trendingPlaces.length],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.discoverTrendingPlaces,
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
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.75, // Matches the Aspect Ratio of the custom card
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final place = items[index];
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: TrendingPlaceCard(
              title: place['title'],
              imageUrl: place['image'],
              distance: place['distance'],
              price: place['price'],
              rating: place['rating'],
              index: index % 5, // Limit the animation delay to keep it snappy
            ),
          );
        },
      ),
    );
  }
}
