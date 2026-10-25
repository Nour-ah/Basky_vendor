import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/utils/vendor_access.dart';
import '../../../../core/widgets/state_view_widget.dart';
import '../cubit/prescriptions_list_cubit.dart';
import '../cubit/prescriptions_list_state.dart';
import '../models/prescription_list_filter.dart';
import '../widgets/pharmacy_access_guard.dart';
import '../widgets/prescription_filter_tabs.dart';
import '../widgets/prescription_request_card.dart';
import 'vendor_prescription_request_details_page.dart';

class VendorPrescriptionRequestsPage extends StatefulWidget {
  const VendorPrescriptionRequestsPage({super.key});

  @override
  State<VendorPrescriptionRequestsPage> createState() =>
      _VendorPrescriptionRequestsPageState();
}

class _VendorPrescriptionRequestsPageState
    extends State<VendorPrescriptionRequestsPage> {
  late final PrescriptionsListCubit _cubit;
  final ScrollController _scrollController = ScrollController();
  PrescriptionListFilter _selectedFilter = PrescriptionListFilter.all;

  @override
  void initState() {
    super.initState();
    _cubit = sl<PrescriptionsListCubit>();
    _scrollController.addListener(_onScroll);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final allowed = await VendorAccess.isPharmacyVendorCached();
    if (!allowed || !mounted) return;
    _cubit.fetchRequests(filter: _selectedFilter);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return PharmacyAccessGuard(
      child: BlocProvider.value(
        value: _cubit,
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
            title: Text(
              LocaleKeys.prescriptionRequests.tr(),
              style: AppTextStyle.fontBlack16Bold,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                PrescriptionFilterTabs(
                  selected: _selectedFilter,
                  onChanged: (filter) {
                    setState(() => _selectedFilter = filter);
                    _cubit.fetchRequests(filter: filter, isRefresh: true);
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<PrescriptionsListCubit, PrescriptionsListState>(
                    builder: (context, state) {
                      if (state is PrescriptionsListLoading) {
                        return const LoadingSkeletonList(itemCount: 4);
                      }
                      if (state is PrescriptionsListNetworkError) {
                        return StateViewWidget(
                          message: LocaleKeys.noInternetConnection.tr(),
                          icon: Icons.wifi_off,
                          onRetry: () => _cubit.fetchRequests(
                            filter: state.filter,
                            isRefresh: true,
                          ),
                        );
                      }
                      if (state is PrescriptionsListError) {
                        return StateViewWidget(
                          message: state.message,
                          icon: Icons.error_outline,
                          onRetry: () => _cubit.fetchRequests(
                            filter: state.filter,
                            isRefresh: true,
                          ),
                        );
                      }
                      if (state is PrescriptionsListEmpty) {
                        return StateViewWidget(
                          message: LocaleKeys.prescriptionNoRequests.tr(),
                          icon: Icons.medication_outlined,
                          onRetry: () => _cubit.fetchRequests(
                            filter: state.filter,
                            isRefresh: true,
                          ),
                        );
                      }
                      if (state is PrescriptionsListLoaded) {
                        return RefreshIndicator(
                          onRefresh: () => _cubit.fetchRequests(
                            filter: state.filter,
                            isRefresh: true,
                          ),
                          child: ListView.separated(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.requests.length +
                                (state.hasReachedMax ? 0 : 1),
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              if (index >= state.requests.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final request = state.requests[index];
                              return PrescriptionRequestCard(
                                request: request,
                                onAction: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          VendorPrescriptionRequestDetailsPage(
                                        requestId: request.id,
                                      ),
                                    ),
                                  );
                                  if (!mounted) return;
                                  _cubit.fetchRequests(
                                    filter: _selectedFilter,
                                    isRefresh: true,
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
