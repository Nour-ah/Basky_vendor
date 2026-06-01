import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/state_view_widget.dart';
import '../cubit/reviews_cubit.dart';
import '../cubit/reviews_state.dart';
import '../widgets/review_card_widget.dart';
import '../widgets/rating_summary_widget.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<ReviewsCubit>()..fetchReviews(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
              color: AppColors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(LocaleKeys.ratingsAndReviews.tr(), style: AppTextStyle.fontBlack16Bold),
        ),
        body: BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            if (state is ReviewsLoading) {
              return const LoadingSkeletonList();
            }
            if (state is ReviewsError) {
              return StateViewWidget(
                message: state.isNetworkError
                    ? LocaleKeys.noInternetConnection.tr()
                    : state.message,
                icon: state.isNetworkError ? Icons.wifi_off : Icons.error_outline,
                onRetry: () => context.read<ReviewsCubit>().fetchReviews(),
              );
            }
            if (state is ReviewsEmpty) {
              return StateViewWidget(
                message: LocaleKeys.noReviewsFound.tr(),
                icon: Icons.star_outline,
              );
            }
            if (state is ReviewsLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<ReviewsCubit>().fetchReviews(),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    RatingSummaryWidget(
                      averageRating: state.summary.averageRating,
                      totalReviews: state.summary.totalReviews,
                    ),
                    const SizedBox(height: 20),
                    ...state.summary.reviews.map(
                      (review) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ReviewCardWidget(review: review),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
