import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/features/my_restaurant/ui/widgets/add_food_multi_image_picker.dart';

void main() {
  testWidgets('AddFoodMultiImagePicker renders title and pickHint', (WidgetTester tester) async {
    // arrange
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddFoodMultiImagePicker(
            title: 'Test Title',
            pickHint: 'Test Hint',
            onImagesPicked: (_) {},
          ),
        ),
      ),
    );

    // assert
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Hint'), findsOneWidget);
  });
}
