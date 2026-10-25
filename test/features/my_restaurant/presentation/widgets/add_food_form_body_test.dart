import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:basky_vendor/features/my_restaurant/domain/entities/add_product_params.dart';
import 'package:basky_vendor/features/my_restaurant/presentation/cubit/add_food_cubit.dart';
import 'package:basky_vendor/features/my_restaurant/presentation/cubit/add_food_state.dart';
import 'package:basky_vendor/features/my_restaurant/presentation/widgets/add_food_form_body.dart';
import 'package:basky_vendor/features/my_restaurant/ui/widgets/add_food_type_dropdown.dart';

class MockAddFoodCubit extends Mock implements AddFoodCubit {}

void main() {
  late MockAddFoodCubit mockAddFoodCubit;

  setUp(() {
    mockAddFoodCubit = MockAddFoodCubit();
    when(() => mockAddFoodCubit.state).thenReturn(AddFoodInitial());
    when(() => mockAddFoodCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAddFoodCubit.close()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<AddFoodCubit>.value(
          value: mockAddFoodCubit,
          child: SingleChildScrollView(
            child: AddFoodFormBody(
              categories: const [],
              variants: const [],
              isEditMode: false,
              isLoading: false,
              validationErrors: const {},
              onSubmit: (AddProductParams params) {},
            ),
          ),
        ),
      ),
    );
  }

  group('AddFoodFormBody Widget Tests', () {
    testWidgets('renders ProductType selector (AddFoodTypeDropdown)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Let any animations or initializations complete
      await tester.pumpAndSettle();

      expect(find.byType(AddFoodTypeDropdown), findsOneWidget);
    });

    testWidgets('Product type selector shows simple and variable options', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.fastfood_outlined), findsOneWidget);
      expect(find.byIcon(Icons.dashboard_customize_outlined), findsOneWidget);
    });
  });
}
