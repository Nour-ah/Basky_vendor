import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/features/orders/data/models/order_model.dart';
import 'package:spider_restaurant/features/orders/domain/entities/order_entity.dart';

void main() {
  const tOrderModel = OrderModel(
    id: 19,
    orderCode: '545555',
    status: 'processing',
    dateTime: '2024-01-15T12:00:00Z',
    orderType: 'delivery',
    itemCount: 3,
  );

  group('OrderModel Tests', () {
    test('should be a subclass of OrderEntity', () {
      expect(tOrderModel, isA<OrderEntity>());
    });

    test('should return a valid model from JSON map', () {
      final Map<String, dynamic> jsonMap = {
        'id': 19,
        'order_code': '545555',
        'status': 'processing',
        'created_at': '2024-01-15T12:00:00Z',
        'delivery_type': 'delivery',
        'items_count': 3,
      };

      final result = OrderModel.fromJson(jsonMap);

      expect(result, tOrderModel);
    });

    test('should return a JSON map containing correct data', () {
      final result = tOrderModel.toJson();

      final expectedJsonMap = {
        'id': 19,
        'order_code': '545555',
        'status': 'processing',
        'created_at': '2024-01-15T12:00:00Z',
        'delivery_type': 'delivery',
        'items_count': 3,
      };

      expect(result, expectedJsonMap);
    });
  });
}
