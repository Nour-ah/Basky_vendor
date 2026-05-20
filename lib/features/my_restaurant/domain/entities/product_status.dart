enum ProductStatus {
  active,
  inactive,
  hidden,
  outOfStock,
  unknown;

  static ProductStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'published':
      case '1':
      case 'true':
        return ProductStatus.active;
      case 'inactive':
      case 'unpublished':
      case '0':
      case 'false':
        return ProductStatus.inactive;
      case 'hidden':
        return ProductStatus.hidden;
      case 'out_of_stock':
      case 'outofstock':
        return ProductStatus.outOfStock;
      default:
        return ProductStatus.unknown;
    }
  }

  String toApiString() {
    switch (this) {
      case ProductStatus.active:
        return '1';
      case ProductStatus.inactive:
        return '0';
      case ProductStatus.hidden:
        return 'hidden';
      case ProductStatus.outOfStock:
        return 'out_of_stock';
      case ProductStatus.unknown:
        return '1'; // fallback
    }
  }
}
