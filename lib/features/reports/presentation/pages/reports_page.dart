import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/state_view_widget.dart';
import '../cubit/reports_cubit.dart';
import '../cubit/reports_state.dart';
import '../widgets/report_stat_card.dart';
import '../widgets/revenue_chart_widget.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  static const _ranges = [
  'today',
    'yesterday',
    'last_7_days',
    'last_30_days',
  ];

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<ReportsCubit>()..fetchReports(range: 'last_30_days'),
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
          title: Text(LocaleKeys.reportsAndAnalytics.tr(), style: AppTextStyle.fontBlack16Bold),
        ),
        body: BlocBuilder<ReportsCubit, ReportsState>(
          builder: (context, state) {
            if (state is ReportsLoading) {
              return const LoadingSkeletonList(itemCount: 4);
            }
            if (state is ReportsError) {
              return StateViewWidget(
                message: state.isNetworkError
                    ? LocaleKeys.noInternetConnection.tr()
                    : state.message,
                icon: state.isNetworkError ? Icons.wifi_off : Icons.error_outline,
                onRetry: () => context.read<ReportsCubit>().fetchReports(),
              );
            }
            if (state is ReportsLoaded) {
              final summary = state.summary;
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<ReportsCubit>().fetchReports(range: state.selectedRange),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _ranges.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final range = _ranges[index];
                          final isSelected = state.selectedRange == range;
                          return ChoiceChip(
                            label: Text(_rangeLabel(range)),
                            selected: isSelected,
                            onSelected: (_) =>
                                context.read<ReportsCubit>().fetchReports(range: range),
                            selectedColor: AppColors.primary.withValues(alpha: 0.15),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ReportStatCard(
                            title: LocaleKeys.totalOrders.tr(),
                            value: '${summary.totalOrders}',
                            icon: Icons.receipt_long_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ReportStatCard(
                            title: LocaleKeys.totalRevenue.tr(),
                            value:
                                '${summary.totalRevenue.toStringAsFixed(0)} ${LocaleKeys.currency.tr()}',
                            icon: Icons.payments_outlined,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ReportStatCard(
                            title: LocaleKeys.averageRating.tr(),
                            value: summary.averageRating.toStringAsFixed(1),
                            icon: Icons.star_outline,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ReportStatCard(
                            title: LocaleKeys.totalCustomers.tr(),
                            value: '${summary.totalCustomers}',
                            icon: Icons.people_outline,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(LocaleKeys.revenueOverview.tr(), style: AppTextStyle.fontBlack16Bold),
                    const SizedBox(height: 12),
                    RevenueChartWidget(points: summary.revenueChart),
                    const SizedBox(height: 24),
                    Text(LocaleKeys.ordersByStatus.tr(), style: AppTextStyle.fontBlack16Bold),
                    const SizedBox(height: 12),
                    ReportStatCard(
                      title: LocaleKeys.pending.tr(),
                      value: '${summary.pendingOrders}',
                      icon: Icons.hourglass_empty,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    ReportStatCard(
                      title: LocaleKeys.delivered.tr(),
                      value: '${summary.completedOrders}',
                      icon: Icons.check_circle_outline,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 8),
                    ReportStatCard(
                      title: LocaleKeys.cancelled.tr(),
                      value: '${summary.cancelledOrders}',
                      icon: Icons.cancel_outlined,
                      color: AppColors.promoRed,
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

  String _rangeLabel(String range) {
    switch (range) {
      case 'today':
        return LocaleKeys.today.tr();
      case 'yesterday':
        return LocaleKeys.yesterday.tr();
      case 'last_7_days':
        return LocaleKeys.thisWeek.tr();
      case 'last_30_days':
        return LocaleKeys.thisMonth.tr();
      default:
        return range;
    }
  }
}
