import 'package:equatable/equatable.dart';
import 'product_summary_entity.dart';
import 'vendor_branch_entity.dart';

class BranchDetailsResponseEntity extends Equatable {
  final VendorBranchEntity branch;
  final List<ProductSummaryEntity> products;

  const BranchDetailsResponseEntity({
    required this.branch,
    required this.products,
  });

  @override
  List<Object?> get props => [branch, products];
}
