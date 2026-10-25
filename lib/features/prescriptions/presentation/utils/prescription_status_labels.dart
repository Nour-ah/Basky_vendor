import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/prescription_request_status.dart';
import '../../../../core/translations/locale_keys.g.dart';

extension PrescriptionRequestStatusX on PrescriptionRequestStatus {
  String get label {
    switch (this) {
      case PrescriptionRequestStatus.pending:
        return LocaleKeys.prescriptionStatusPending.tr();
      case PrescriptionRequestStatus.quoted:
        return LocaleKeys.prescriptionStatusQuoted.tr();
      case PrescriptionRequestStatus.converted:
        return LocaleKeys.prescriptionStatusConverted.tr();
      case PrescriptionRequestStatus.userRejected:
        return LocaleKeys.prescriptionStatusUserRejected.tr();
      case PrescriptionRequestStatus.cancelled:
        return LocaleKeys.prescriptionStatusCancelled.tr();
      case PrescriptionRequestStatus.all:
        return LocaleKeys.prescriptionTabAll.tr();
    }
  }
}
