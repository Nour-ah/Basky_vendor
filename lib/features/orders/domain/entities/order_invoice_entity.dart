import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Entity representing a PDF invoice fetched from the server.
class OrderInvoiceEntity extends Equatable {
  final int orderId;
  final Uint8List pdfBytes;

  const OrderInvoiceEntity({
    required this.orderId,
    required this.pdfBytes,
  });

  @override
  List<Object?> get props => [orderId, pdfBytes];
}
