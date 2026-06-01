/// Product type enum matching the backend API contract.
/// The API accepts ONLY 'simple' or 'variable' for the [type] field.
enum ProductType {
  simple,
  variable;

  /// Serializes to the exact string the Laravel API expects.
  /// Uses Dart's built-in [name] getter → 'simple' | 'variable'.
  String toApiString() => name;

  static ProductType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'variable':
        return ProductType.variable;
      case 'simple':
      default:
        return ProductType.simple;
    }
  }
}
