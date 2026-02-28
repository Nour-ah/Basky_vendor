import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dummy_data.dart';
import '../widgets/top_offer_card.dart';

class TopOffersSeeAllPage extends StatelessWidget {
  const TopOffersSeeAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      8,
      (index) => DummyData.topOffers[index % DummyData.topOffers.length],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.topOffers, style: AppTextStyle.heading18Bold),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final offer = items[index];
          return Padding(
            // Space between cards
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              height: 120, // Match the expected card height so it doesn't break
              child: TopOfferCard(
                title: offer['title'],
                discount: offer['discount'],
                code: offer['code'],
                imageUrl: offer['image'],
                index: index % 6, // limits animation delay
              ),
            ),
          );
        },
      ),
    );
  }
}
