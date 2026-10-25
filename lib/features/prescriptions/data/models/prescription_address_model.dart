import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/prescription_address.dart';

class PrescriptionAddressModel extends PrescriptionAddress {
  const PrescriptionAddressModel({
    required super.id,
    required super.address,
  });

  factory PrescriptionAddressModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PrescriptionAddressModel(id: 0, address: '');
    }
    return PrescriptionAddressModel(
      id: JsonParsers.asIntOr(json['id']),
      address: JsonParsers.asString(json['address']) ?? '',
    );
  }
}
