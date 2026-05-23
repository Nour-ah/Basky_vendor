import '../../domain/entities/vendor_branch_entity.dart';

class RestaurantDetailsModel {
  final String name;
  final bool isOpen;
  final String address;
  final double rating;
  final String deliveryTime;
  final String deliveryFee;
  final String logoUrl;
  final String coverImageUrl;

  RestaurantDetailsModel({
    required this.name,
    required this.isOpen,
    required this.address,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.logoUrl,
    required this.coverImageUrl,
  });

  factory RestaurantDetailsModel.fromBranch(VendorBranchEntity branch) {
    return RestaurantDetailsModel(
      name: branch.name,
      isOpen: branch.isOpen,
      address: branch.address,
      rating: branch.rating,
      deliveryTime: branch.deliveryTime ?? '',
      deliveryFee: branch.deliveryFee ?? '',
      logoUrl: branch.logoUrl ?? '',
      coverImageUrl: branch.coverImageUrl ?? '',
    );
  }
}
