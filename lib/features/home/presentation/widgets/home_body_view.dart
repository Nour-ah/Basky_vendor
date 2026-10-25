import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_in_slide.dart';
import '../../../../core/widgets/app_skeleton_loading.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/utils/vendor_access.dart';
import '../../../prescriptions/presentation/widgets/prescription_home_shortcut.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'home_orders_section.dart';
import 'statistics_cards.dart';

class HomeBodyView extends StatelessWidget {
  final HomeState state;
  final List<String> orderTabs;

  const HomeBodyView({super.key, required this.state, required this.orderTabs});

  @override
  Widget build(BuildContext context) {
    if (state is HomeLoading || state is HomeInitial) {
      return const HomeSkeleton();
    }
    if (state is HomeError) {
      return Center(
        child: Text(
          '${LocaleKeys.unknown.tr()}: ${(state as HomeError).message}',
          style: AppTextStyle.fontPrimary14Regular,
        ),
      );
    }
    if (state is HomeLoaded) {
      final loadedState = state as HomeLoaded;
      final stats = loadedState.stats;

      return RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () async {
          context.read<HomeCubit>().fetchHomeData();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // ─── Restaurant Status Switch ──────────────────────
                  // FadeInSlide(
                  //   delay: 100,
                  //   child: BlocProvider(
                  //     create: (_) => sl<ToggleStatusCubit>(),
                  //     child: RestaurantStatusSwitch(
                  //       initialIsOpen: loadedState.branch?.isOpen ?? false,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 16),

                  // ─── Statistics Cards ─────────────────────────────
                  FadeInSlide(
                    delay: 200,
                    child: StatisticsCards(
                      todayOrders: stats.todayOrders,
                      todayEarnings: stats.todayEarnings,
                    ),
                  ),
                  if (loadedState.user.isPharmacyVendor) ...[
                    const SizedBox(height: 16),
                    FadeInSlide(
                      delay: 250,
                      child: PrescriptionHomeShortcut(
                        pendingCount: loadedState.pendingPrescriptionCount,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // ─── Orders Filter Tabs + Shimmer + List ──────────
                  FadeInSlide(
                    delay: 300,
                    child: const HomeOrdersSectionProvider(),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
