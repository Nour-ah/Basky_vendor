import 'package:equatable/equatable.dart';

class VendorBranchEntity extends Equatable {
  final int id;
  final String name;
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

  const VendorBranchEntity({
    required this.id,
    required this.name,
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
  });

  @override
  List<Object?> get props => [
        id,
        name,
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
      ];
}
