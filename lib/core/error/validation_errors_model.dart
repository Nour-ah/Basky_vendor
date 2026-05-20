class ValidationErrorsModel {
  final Map<String, List<String>> errors;

  ValidationErrorsModel({required this.errors});

  factory ValidationErrorsModel.fromJson(Map<String, dynamic> json) {
    final Map<String, List<String>> parsedErrors = {};
    
    json.forEach((key, value) {
      if (value is List) {
        parsedErrors[key] = value.map((e) => e.toString()).toList();
      } else if (value is String) {
        parsedErrors[key] = [value];
      }
    });

    return ValidationErrorsModel(errors: parsedErrors);
  }

  /// Helper to get the first error for a specific field
  String? getFirstError(String field) {
    if (errors.containsKey(field) && errors[field]!.isNotEmpty) {
      return errors[field]!.first;
    }
    return null;
  }
}
