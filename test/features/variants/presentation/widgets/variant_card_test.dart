import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:basky_vendor/features/variants/domain/entities/variant_entity.dart';
import 'package:basky_vendor/features/variants/ui/widgets/variant_card.dart';

void main() {
  const tVariant = VariantEntity(
    id: 1,
    name: 'Size',
    options: [
      VariantOptionEntity(id: 1, name: 'Small'),
      VariantOptionEntity(id: 2, name: 'Medium'),
    ],
  );

  testWidgets('VariantCard renders variant name and options as chips', (WidgetTester tester) async {
    bool editCalled = false;
    bool deleteCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VariantCard(
            variant: tVariant,
            onEdit: () => editCalled = true,
            onDelete: () => deleteCalled = true,
          ),
        ),
      ),
    );

    expect(find.text('Size'), findsOneWidget);
    expect(find.text('Small'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);

    final editBtn = find.byIcon(Icons.edit_outlined);
    expect(editBtn, findsOneWidget);
    await tester.tap(editBtn);
    expect(editCalled, true);

    final deleteBtn = find.byIcon(Icons.delete_outline);
    expect(deleteBtn, findsOneWidget);
    await tester.tap(deleteBtn);
    expect(deleteCalled, true);
  });
}
