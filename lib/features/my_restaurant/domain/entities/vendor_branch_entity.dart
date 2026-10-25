import 'package:equatable/equatable.dart';

class VendorBranchEntity extends Equatable {
  final int id;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String address;
  final bool isOpen;
  final double rating;
  final String? deliveryTime;
  final String? deliveryFee;
  final String? logoUrl;
  final String? coverImageUrl;
  final String? phone;
  final String? latitude;
  final String? longitude;
  final int? countryId;

  const VendorBranchEntity({
    required this.id,
    required this.name,
    this.nameEn,
    this.nameAr,
    required this.address,
    required this.isOpen,
    required this.rating,
    this.deliveryTime,
    this.deliveryFee,
    this.logoUrl,
    this.coverImageUrl,
    this.phone,
    this.latitude,
    this.longitude,
    this.countryId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        nameEn,
        nameAr,
        address,
        isOpen,
        rating,
        deliveryTime,
        deliveryFee,
        logoUrl,
        coverImageUrl,
        phone,
        latitude,
        longitude,
        countryId,
      ];
}
