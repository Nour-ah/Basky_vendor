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
}
