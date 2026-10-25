import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    required super.id,
    required super.name,
    super.code,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final nameValue = json['name'];
    String name;
    if (nameValue is Map) {
      name = JsonParsers.asString(nameValue['en']) ??
          JsonParsers.asString(nameValue['ar']) ??
          nameValue.values
              .map((e) => e?.toString() ?? '')
              .firstWhere((e) => e.isNotEmpty, orElse: () => '');
    } else {
      name = JsonParsers.asString(nameValue) ?? '';
    }

    return CountryModel(
      id: JsonParsers.asIntOr(json['id']),
      name: name,
      code: JsonParsers.asString(json['code']),
    );
  }
}
