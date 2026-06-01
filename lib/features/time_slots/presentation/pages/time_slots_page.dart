import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/utils/app_snackbar_helper.dart';
import '../../../../core/widgets/state_view_widget.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../cubit/time_slots_cubit.dart';
import '../cubit/time_slots_state.dart';
import '../widgets/time_slot_card.dart';
import '../widgets/time_slot_form_sheet.dart';

class TimeSlotsPage extends StatelessWidget {
  const TimeSlotsPage({super.key});

  static const _dayNames = [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => sl<TimeSlotsCubit>()..fetchTimeSlots(),
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
          title: Text(LocaleKeys.openingTimes.tr(), style: AppTextStyle.fontBlack16Bold),
          actions: [
            BlocBuilder<TimeSlotsCubit, TimeSlotsState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.add, color: AppColors.primary),
                  onPressed: () => _showAddSheet(context),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<TimeSlotsCubit, TimeSlotsState>(
          listener: (context, state) {
            if (state is TimeSlotsActionSuccess) {
              AppSnackBarHelper.showSuccessSnackBar(
                message: state.message,
                context: context,
              );
            } else if (state is TimeSlotsError) {
              AppSnackBarHelper.showErrorSnackBar(message: state.message, context: context);
            }
          },
          builder: (context, state) {
            if (state is TimeSlotsLoading) {
              return const LoadingSkeletonList();
            }
            if (state is TimeSlotsError) {
              return StateViewWidget(
                message: (state).isNetworkError
                    ? LocaleKeys.noInternetConnection.tr()
                    : state.message,
                icon: state.isNetworkError ? Icons.wifi_off : Icons.error_outline,
                onRetry: () => context.read<TimeSlotsCubit>().fetchTimeSlots(),
              );
            }
            if (state is TimeSlotsEmpty) {
              return StateViewWidget(
                message: LocaleKeys.noTimeSlotsFound.tr(),
                icon: Icons.schedule,
                onRetry: () => _showAddSheet(context),
                actionLabel: LocaleKeys.addTimeSlot.tr(),
              );
            }
            if (state is TimeSlotsLoaded || state is TimeSlotsSubmitting) {
              final slots = state is TimeSlotsLoaded
                  ? state.slots
                  : (state as TimeSlotsSubmitting).slots;

              return RefreshIndicator(
                onRefresh: () => context.read<TimeSlotsCubit>().fetchTimeSlots(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: slots.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    return TimeSlotCard(
                      dayLabel: _dayLabel(slot.dayOfWeek),
                      opensAt: slot.opensAt,
                      closesAt: slot.closesAt,
                      onEdit: () => _showEditSheet(context, slot),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _dayLabel(int dayOfWeek) {
    if (dayOfWeek < 0 || dayOfWeek >= _dayNames.length) return '';
    return 'days.${_dayNames[dayOfWeek]}'.tr();
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return TimeSlotFormSheet(
          onSubmit: (params) {
            context.read<TimeSlotsCubit>().addSlot(params);
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  void _showEditSheet(BuildContext context, TimeSlotEntity slot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return TimeSlotFormSheet(
          initialDay: slot.dayOfWeek,
          initialOpensAt: slot.opensAt,
          initialClosesAt: slot.closesAt,
          isEdit: true,
          onSubmit: (params) {
            context.read<TimeSlotsCubit>().updateSlot(
                  UpdateTimeSlotParams(
                    timeSlotId: slot.id,
                    dayOfWeek: params.dayOfWeek,
                    opensAt: params.opensAt,
                    closesAt: params.closesAt,
                  ),
                );
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }
}
