import 'package:equatable/equatable.dart';

import 'product_image_entity.dart';

class AddBranchParams extends Equatable {
  final String nameEn;
  final String nameAr;
  final String address;
  final String phone;
  final String? latitude;
  final String? longitude;
  final int countryId;
  final bool isActive;
  final ProductImageEntity? image;
  final bool isEditMode;
  final int? branchId;

  const AddBranchParams({
    required this.nameEn,
    required this.nameAr,
    required this.address,
    required this.phone,
    this.latitude,
    this.longitude,
    this.countryId = 1,
    this.isActive = true,
    this.image,
    this.isEditMode = false,
    this.branchId,
  });

  @override
  List<Object?> get props => [
        nameEn,
        nameAr,
        address,
        phone,
        latitude,
        longitude,
        countryId,
        isActive,
        image,
        isEditMode,
        branchId,
      ];
}
