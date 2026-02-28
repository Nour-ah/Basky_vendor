import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dummy_data.dart';
import '../pages/top_offers_see_all_page.dart';
import 'top_offer_card.dart';

class TopOffersSection extends StatelessWidget {
  const TopOffersSection({super.key});

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
              Text(AppStrings.topOffers, style: AppTextStyle.heading18Bold),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TopOffersSeeAllPage(),
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
          height: 120, // appropriate height for the card
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: DummyData.topOffers.length,
            itemBuilder: (context, index) {
              final offer = DummyData.topOffers[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TopOfferCard(
                  title: offer['title'],
                  discount: offer['discount'],
                  code: offer['code'],
                  imageUrl: offer['image'],
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
