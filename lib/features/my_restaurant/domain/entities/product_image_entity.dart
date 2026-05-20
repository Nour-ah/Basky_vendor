import 'package:equatable/equatable.dart';

class ProductImageEntity extends Equatable {
  final String path;
  final String? mimeType;
  final int? sizeBytes;

  const ProductImageEntity({
    required this.path,
    this.mimeType,
    this.sizeBytes,
  });

  @override
  List<Object?> get props => [path, mimeType, sizeBytes];
}
