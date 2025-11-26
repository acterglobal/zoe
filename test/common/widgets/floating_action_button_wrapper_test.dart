import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/floating_action_button_wrapper.dart';
import 'package:zoe/common/widgets/toolkit/zoe_floating_action_button_widget.dart';
import 'package:zoe/features/content/models/content_model.dart';
import 'package:zoe/features/content/providers/content_providers.dart';
import 'package:zoe/features/text/models/text_model.dart';
import '../../test-utils/test_utils.dart';

/// Test utilities for FloatingActionButtonWrapper tests
class FloatingActionButtonWrapperTestUtils {
  /// Creates a test wrapper for the FloatingActionButtonWrapper
  static Widget createTestWidget({
    required String parentId,
    required String sheetId,
    String? editContentId,
    List<ContentModel>? contentList,
  }) {
    return FloatingActionButtonWrapper(parentId: parentId, sheetId: sheetId);
  }

  /// Creates a mock ContentModel for testing
  static TextModel createTestContent({
    required String id,
    required String parentId,
    String? title,
    int orderIndex = 0,
  }) {
    return TextModel(
      id: id,
      parentId: parentId,
      sheetId: 'test-sheet',
      title: title ?? 'Test Content',
      description: (plainText: 'Test description', htmlText: null),
      orderIndex: orderIndex,
    );
  }
}

void main() {
  group('FloatingActionButtonWrapper Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(),
        child: FloatingActionButtonWrapperTestUtils.createTestWidget(
          parentId: 'parent-1',
          sheetId: 'sheet-1',
        ),
      );

      // Verify widget is rendered
      expect(find.byType(FloatingActionButtonWrapper), findsOneWidget);
      expect(find.byType(ZoeFloatingActionButton), findsOneWidget);
    });

    testWidgets('displays add icon when not editing', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(),
        child: FloatingActionButtonWrapperTestUtils.createTestWidget(
          parentId: 'parent-1',
          sheetId: 'sheet-1',
        ),
      );

      // Verify add icon is displayed
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.save_rounded), findsNothing);
    });

    testWidgets('displays save icon when editing current content', (
      tester,
    ) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [editContentIdProvider.overrideWith((ref) => 'parent-1')],
        ),
        child: FloatingActionButtonWrapperTestUtils.createTestWidget(
          parentId: 'parent-1',
          sheetId: 'sheet-1',
        ),
      );

      // Verify save icon is displayed
      expect(find.byIcon(Icons.save_rounded), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsNothing);
    });

    testWidgets('displays save icon when editing child content', (
      tester,
    ) async {
      final testContent =
          FloatingActionButtonWrapperTestUtils.createTestContent(
            id: 'child-1',
            parentId: 'parent-1',
          );

      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [
            editContentIdProvider.overrideWith((ref) => 'child-1'),
            contentListProvider.overrideWith((ref) => [testContent]),
          ],
        ),
        child: FloatingActionButtonWrapperTestUtils.createTestWidget(
          parentId: 'parent-1',
          sheetId: 'sheet-1',
        ),
      );

      // Verify save icon is displayed
      expect(find.byIcon(Icons.save_rounded), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsNothing);
    });

    testWidgets('displays add icon when editing unrelated content', (
      tester,
    ) async {
      final testContent =
          FloatingActionButtonWrapperTestUtils.createTestContent(
            id: 'child-1',
            parentId: 'other-parent',
          );

      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [
            editContentIdProvider.overrideWith((ref) => 'child-1'),
            contentListProvider.overrideWith((ref) => [testContent]),
          ],
        ),
        child: FloatingActionButtonWrapperTestUtils.createTestWidget(
          parentId: 'parent-1',
          sheetId: 'sheet-1',
        ),
      );

      // Verify add icon is displayed (not save)
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.save_rounded), findsNothing);
    });

    testWidgets('handles null editContentId', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [editContentIdProvider.overrideWith((ref) => null)],
        ),
        child: FloatingActionButtonWrapperTestUtils.createTestWidget(
          parentId: 'parent-1',
          sheetId: 'sheet-1',
        ),
      );

      // Verify add icon is displayed
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.save_rounded), findsNothing);
    });

    testWidgets('handles content not found in provider', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [
            editContentIdProvider.overrideWith((ref) => 'non-existent'),
            contentListProvider.overrideWith((ref) => []),
          ],
        ),
        child: FloatingActionButtonWrapperTestUtils.createTestWidget(
          parentId: 'parent-1',
          sheetId: 'sheet-1',
        ),
      );

      // Verify add icon is displayed when content is not found
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.save_rounded), findsNothing);
    });

    testWidgets('handles empty content list', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [
            editContentIdProvider.overrideWith((ref) => 'child-1'),
            contentListProvider.overrideWith((ref) => []),
          ],
        ),
        child: FloatingActionButtonWrapperTestUtils.createTestWidget(
          parentId: 'parent-1',
          sheetId: 'sheet-1',
        ),
      );

      // Verify add icon is displayed when content list is empty
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.save_rounded), findsNothing);
    });
  });
  testWidgets('applies primaryColor to ZoeFloatingActionButton', (
    tester,
  ) async {
    const customColor = Colors.purple;

    await tester.pumpMaterialWidgetWithProviderScope(
      container: ProviderContainer(),
      child: FloatingActionButtonWrapper(
        parentId: 'parent-1',
        sheetId: 'sheet-1',
        primaryColor: customColor,
      ),
    );

    // Ensure the ZoeFloatingActionButton is present
    final fabFinder = find.byType(ZoeFloatingActionButton);
    expect(fabFinder, findsOneWidget);

    final fab = tester.widget<ZoeFloatingActionButton>(fabFinder);

    // Verify the primaryColor was passed to the internal FAB
    expect(fab.primaryColor, equals(customColor));
  });
}
