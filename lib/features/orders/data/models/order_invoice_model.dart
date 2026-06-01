import 'dart:typed_data';

import '../../domain/entities/order_invoice_entity.dart';

class OrderInvoiceModel extends OrderInvoiceEntity {
  const OrderInvoiceModel({
    required super.orderId,
    required super.pdfBytes,
  });

  factory OrderInvoiceModel.fromBytes({
    required int orderId,
    required Uint8List bytes,
  }) {
    return OrderInvoiceModel(
      orderId: orderId,
      pdfBytes: bytes,
    );
  }
}
