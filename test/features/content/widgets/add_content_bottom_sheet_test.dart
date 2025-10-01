import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/content/widgets/add_content_bottom_sheet.dart';
import 'package:zoe/features/content/widgets/content_menu_options.dart';

import '../../../test-utils/test_utils.dart';
import '../../../helpers/mock_gorouter.dart';

void main() {
  late ProviderContainer container;
  late MockGoRouter mockGoRouter;

  setUp(() {
    container = ProviderContainer();
    mockGoRouter = MockGoRouter();

    // Set up mock methods
    when(() => mockGoRouter.pop()).thenReturn(null);
  });

  tearDown(() {
    container.dispose();
  });

  group('AddContentBottomSheet', () {
    testWidgets('renders correctly with all required elements', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        router: mockGoRouter,
        child: const SizedBox(
          width: 600,
          height: 800,
          child: AddContentBottomSheet(
            parentId: 'parent123',
            sheetId: 'sheet123',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify title is displayed (using key instead of text)
      expect(find.byKey(const Key('add_content_title')), findsOneWidget);

      // Verify all menu options are present
      expect(find.byType(ContentMenuOptions), findsOneWidget);
    });

    testWidgets(
      'showAddContentBottomSheet displays the bottom sheet correctly',
      (tester) async {
        // Set a larger screen size to accommodate the bottom sheet
        await tester.binding.setSurfaceSize(const Size(800, 1200));

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          router: mockGoRouter,
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => showAddContentBottomSheet(
                    context,
                    parentId: 'parent123',
                    sheetId: 'sheet123',
                  ),
                  child: const Text('Show Sheet'),
                ),
              );
            },
          ),
        );

        // Tap the button to show the bottom sheet
        await tester.tap(find.text('Show Sheet'));
        await tester.pumpAndSettle();

        // Verify bottom sheet is displayed
        expect(find.byType(AddContentBottomSheet), findsOneWidget);
        expect(find.byKey(const Key('add_content_title')), findsOneWidget);

        // Reset the screen size
        await tester.binding.setSurfaceSize(null);
      },
    );

    testWidgets('closes bottom sheet when menu option is tapped', (
      tester,
    ) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        router: mockGoRouter,
        child: const SizedBox(
          width: 600,
          height: 800,
          child: AddContentBottomSheet(
            parentId: 'parent123',
            sheetId: 'sheet123',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap each menu option
      final contentMenuOptions = find.byType(ContentMenuOptions);
      expect(contentMenuOptions, findsOneWidget);

      // Get the ContentMenuOptions widget
      final widget = tester.widget<ContentMenuOptions>(contentMenuOptions);

      // Verify each callback closes the sheet
      widget.onTapText();
      verify(() => mockGoRouter.pop()).called(1);

      widget.onTapEvent();
      verify(() => mockGoRouter.pop()).called(1);

      widget.onTapBulletedList();
      verify(() => mockGoRouter.pop()).called(1);

      widget.onTapToDoList();
      verify(() => mockGoRouter.pop()).called(1);

      widget.onTapLink();
      verify(() => mockGoRouter.pop()).called(1);

      widget.onTapDocument();
      verify(() => mockGoRouter.pop()).called(1);

      widget.onTapPoll();
      verify(() => mockGoRouter.pop()).called(1);
    });

    testWidgets('has correct layout and spacing', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        router: mockGoRouter,
        child: const SizedBox(
          width: 600,
          height: 800,
          child: AddContentBottomSheet(
            parentId: 'parent123',
            sheetId: 'sheet123',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify the Column widget uses MainAxisSize.min
      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.mainAxisSize, MainAxisSize.min);

      // Find all SizedBox widgets that are direct children of the Column
      final sizedBoxes = find.byType(SizedBox).evaluate().where((element) {
        final widget = element.widget as SizedBox;
        return element.findAncestorWidgetOfExactType<Column>() != null &&
            (widget.height == 10 || widget.height == 20);
      });

      // Verify spacing widgets are present with correct heights
      expect(sizedBoxes.length, 2);
      expect(
        sizedBoxes.map((e) => (e.widget as SizedBox).height).toList(),
        containsAll([10.0, 20.0]),
      );

      // Verify padding
      final padding = tester.widget<Padding>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Padding &&
              widget.padding == const EdgeInsets.symmetric(horizontal: 16),
        ),
      );
      expect(padding, isNotNull);
    });

    testWidgets('title has correct text style', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        router: mockGoRouter,
        child: const SizedBox(
          width: 600,
          height: 800,
          child: AddContentBottomSheet(
            parentId: 'parent123',
            sheetId: 'sheet123',
          ),
        ),
      );
      await tester.pumpAndSettle();

      final titleText = tester.widget<Text>(
        find.byKey(const Key('add_content_title')),
      );
      expect(
        titleText.style?.fontSize,
        Theme.of(
          tester.element(find.byType(AddContentBottomSheet)),
        ).textTheme.titleLarge?.fontSize,
      );
    });
  });
}