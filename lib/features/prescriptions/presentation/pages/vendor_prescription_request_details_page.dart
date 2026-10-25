import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/utils/vendor_access.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/state_view_widget.dart';
import '../../domain/entities/prescription_request_status.dart';
import '../../domain/entities/vendor_prescription_request.dart';
import '../cubit/prescription_details_cubit.dart';
import '../cubit/prescription_details_state.dart';
import '../widgets/pharmacy_access_guard.dart';
import '../widgets/prescription_image_preview.dart';
import '../widgets/prescription_medicine_items_section.dart';
import '../widgets/prescription_status_badge.dart';
import 'prescription_quotation_page.dart';

class VendorPrescriptionRequestDetailsPage extends StatefulWidget {
  const VendorPrescriptionRequestDetailsPage({
    super.key,
    required this.requestId,
  });

  final int requestId;

  @override
  State<VendorPrescriptionRequestDetailsPage> createState() =>
      _VendorPrescriptionRequestDetailsPageState();
}

class _VendorPrescriptionRequestDetailsPageState
    extends State<VendorPrescriptionRequestDetailsPage> {
  late final PrescriptionDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<PrescriptionDetailsCubit>();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final allowed = await VendorAccess.isPharmacyVendorCached();
    if (!allowed || !mounted) return;
    _cubit.fetchDetails(widget.requestId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
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
              LocaleKeys.prescriptionRequestDetails.tr(),
              style: AppTextStyle.fontBlack16Bold,
            ),
          ),
          body: BlocBuilder<PrescriptionDetailsCubit, PrescriptionDetailsState>(
            builder: (context, state) {
              if (state is PrescriptionDetailsLoading) {
                return const LoadingSkeletonList(itemCount: 4);
              }
              if (state is PrescriptionDetailsUnauthorized) {
                return StateViewWidget(
                  message: LocaleKeys.prescriptionFeatureUnavailable.tr(),
                  icon: Icons.lock_outline,
                );
              }
              if (state is PrescriptionDetailsError) {
                return StateViewWidget(
                  message: state.isNetworkError
                      ? LocaleKeys.noInternetConnection.tr()
                      : state.message,
                  icon: state.isNetworkError
                      ? Icons.wifi_off
                      : Icons.error_outline,
                  onRetry: () => _cubit.fetchDetails(widget.requestId),
                );
              }
              if (state is PrescriptionDetailsLoaded) {
                return RefreshIndicator(
                  onRefresh: () => _cubit.fetchDetails(widget.requestId),
                  child: _DetailsBody(
                    request: state.request,
                    onPrepareQuote: () async {
                      final refreshed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrescriptionQuotationPage(
                            request: state.request,
                          ),
                        ),
                      );
                      if (refreshed == true && mounted) {
                        await _cubit.fetchDetails(widget.requestId);
                      }
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({
    required this.request,
    required this.onPrepareQuote,
  });

  final VendorPrescriptionRequest request;
  final VoidCallback onPrepareQuote;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${LocaleKeys.prescriptionRequestNumber.tr()} #${request.id}',
                style: AppTextStyle.fontBlack16Bold,
              ),
            ),
            PrescriptionStatusBadge(status: request.status),
          ],
        ),
        const SizedBox(height: 16),
        PrescriptionImagePreview(imageUrl: request.image, height: 220),
        const SizedBox(height: 16),
        if (request.createdAt != null && request.createdAt!.isNotEmpty)
          _InfoRow(
            icon: Icons.access_time_outlined,
            label: LocaleKeys.prescriptionCreatedAt.tr(),
            value: request.createdAt!,
          ),
        if (request.address?.address.isNotEmpty == true)
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: LocaleKeys.deliveryAddress.tr(),
            value: request.address!.address,
          ),
        if (request.notes != null && request.notes!.isNotEmpty)
          _InfoRow(
            icon: Icons.notes_outlined,
            label: LocaleKeys.notes.tr(),
            value: request.notes!,
          ),
        const SizedBox(height: 16),
        PrescriptionMedicineItemsSection(request: request),
        if (request.quotedSubtotal != null ||
            request.quotedShipping != null ||
            request.quotedTotal != null) ...[
          const SizedBox(height: 16),
          PrescriptionTotalsSection(request: request),
        ],
        const SizedBox(height: 20),
        ..._statusMessages(request),
        const SizedBox(height: 12),
        ..._actions(request),
        const SizedBox(height: 24),
      ],
    );
  }

  List<Widget> _statusMessages(VendorPrescriptionRequest request) {
    switch (request.status) {
      case PrescriptionRequestStatus.quoted:
        return [
          Text(
            LocaleKeys.prescriptionQuoteSent.tr(),
            style: AppTextStyle.fontBlack14Bold,
          ),
          const SizedBox(height: 4),
          Text(
            LocaleKeys.prescriptionWaitingCustomer.tr(),
            style: AppTextStyle.fontGrey14Regular,
          ),
        ];
      case PrescriptionRequestStatus.converted:
        return [
          Text(
            LocaleKeys.prescriptionCustomerAccepted.tr(),
            style: AppTextStyle.fontBlack14Bold.copyWith(
              color: AppColors.success,
            ),
          ),
          if (request.orderId != null) ...[
            const SizedBox(height: 8),
            Text(
              LocaleKeys.prescriptionOrderNumber
                  .tr(namedArgs: {'id': '${request.orderId}'}),
              style: AppTextStyle.fontGrey14Regular,
            ),
          ],
        ];
      case PrescriptionRequestStatus.userRejected:
        return [
          Text(
            LocaleKeys.prescriptionCustomerRejected.tr(),
            style: AppTextStyle.fontBlack14Bold.copyWith(
              color: AppColors.promoRed,
            ),
          ),
        ];
      case PrescriptionRequestStatus.cancelled:
        return [
          Text(
            LocaleKeys.prescriptionCustomerCancelled.tr(),
            style: AppTextStyle.fontBlack14Bold.copyWith(
              color: AppColors.promoRed,
            ),
          ),
        ];
      case PrescriptionRequestStatus.pending:
      case PrescriptionRequestStatus.all:
        return const [];
    }
  }

  List<Widget> _actions(VendorPrescriptionRequest request) {
    if (request.status.canQuote) {
      return [
        PrimaryButton(
          text: LocaleKeys.prescriptionPrepareQuote.tr(),
          onPressed: onPrepareQuote,
        ),
      ];
    }
    return const [];
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyle.fontGrey12Regular),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyle.fontBlack14Regular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
