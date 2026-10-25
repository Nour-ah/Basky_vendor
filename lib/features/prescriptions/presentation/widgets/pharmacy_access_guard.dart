import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/widgets/state_view_widget.dart';
import '../../../../core/utils/vendor_access.dart';

/// Protects prescription screens for pharmacy vendors only.
class PharmacyAccessGuard extends StatefulWidget {
  const PharmacyAccessGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<PharmacyAccessGuard> createState() => _PharmacyAccessGuardState();
}

class _PharmacyAccessGuardState extends State<PharmacyAccessGuard> {
  late Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = VendorAccess.isPharmacyVendorCached();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          return widget.child;
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Text(
              LocaleKeys.prescriptionRequests.tr(),
              style: AppTextStyle.fontBlack16Bold,
            ),
          ),
          body: StateViewWidget(
            message: LocaleKeys.prescriptionFeatureUnavailable.tr(),
            icon: Icons.lock_outline,
            onRetry: () => Navigator.pop(context),
            actionLabel: LocaleKeys.cancel.tr(),
          ),
        );
      },
    );
  }
}
