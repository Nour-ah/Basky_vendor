import '../../domain/entities/branch_details_response_entity.dart';
import 'product_summary_model.dart';
import 'vendor_branch_model.dart';

class BranchDetailsResponseModel extends BranchDetailsResponseEntity {
  const BranchDetailsResponseModel({
    required super.branch,
    required super.products,
  });

  factory BranchDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return BranchDetailsResponseModel(
      branch: VendorBranchModel.fromJson(json['branch'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => ProductSummaryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
