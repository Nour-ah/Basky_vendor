import 'package:equatable/equatable.dart';

class VendorType extends Equatable {
  final int id;
  final String key;
  final String name;
  final String? image;

  const VendorType({
    required this.id,
    required this.key,
    required this.name,
    this.image,
  });

  @override
  List<Object?> get props => [id, key, name, image];
}
