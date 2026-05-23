import '../router/pagination_model.dart';

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationModel pagination;

  const PaginatedResponse({required this.data, required this.pagination});
}
