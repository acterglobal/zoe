import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/display_sheet_name_widget.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';

import '../../test-utils/test_utils.dart';

/// Test utilities for DisplaySheetNameWidget tests
class DisplaySheetNameWidgetTestUtils {
  /// Creates a test sheet model
  static SheetModel createTestSheet({
    String? id,
    String? emoji,
    String? title,
  }) {
    return SheetModel(
      id: id ?? 'test-sheet-id',
      emoji: emoji ?? '📄',
      title: title ?? 'Test Sheet',
    );
  }

  /// Creates a test wrapper for the DisplaySheetNameWidget
  static Widget createTestWidget({
    required String sheetId,
    List<SheetModel>? sheets,
  }) {
    return Row(children: [DisplaySheetNameWidget(sheetId: sheetId)]);
  }
}

void main() {
  group('DisplaySheetNameWidget Tests -', () {
    testWidgets('renders with valid sheet', (tester) async {
      final testSheet = DisplaySheetNameWidgetTestUtils.createTestSheet(
        id: 'test-sheet-1',
        emoji: '📊',
        title: 'Analytics Sheet',
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [
            sheetListProvider.overrideWithValue([testSheet]),
          ],
        ),
        child: DisplaySheetNameWidgetTestUtils.createTestWidget(
          sheetId: 'test-sheet-1',
          sheets: [testSheet],
        ),
      );

      // Verify widget is rendered
      expect(find.byType(DisplaySheetNameWidget), findsOneWidget);
      expect(find.byType(Flexible), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('displays sheet name and emoji correctly', (tester) async {
      final testSheet = DisplaySheetNameWidgetTestUtils.createTestSheet(
        id: 'test-sheet-1',
        emoji: '📊',
        title: 'Analytics Sheet',
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [
            sheetListProvider.overrideWithValue([testSheet]),
          ],
        ),
        child: DisplaySheetNameWidgetTestUtils.createTestWidget(
          sheetId: 'test-sheet-1',
          sheets: [testSheet],
        ),
      );

      // Verify sheet name and emoji are displayed
      expect(find.text('📊 Analytics Sheet'), findsOneWidget);
    });

    testWidgets('handles null sheet gracefully', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [sheetListProvider.overrideWithValue([])],
        ),
        child: DisplaySheetNameWidgetTestUtils.createTestWidget(
          sheetId: 'non-existent-sheet',
          sheets: [],
        ),
      );

      // Verify widget renders but shows nothing (SizedBox.shrink)
      expect(find.byType(DisplaySheetNameWidget), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('wraps content in Flexible widget', (tester) async {
      final testSheet = DisplaySheetNameWidgetTestUtils.createTestSheet(
        id: 'test-sheet-1',
        emoji: '📊',
        title: 'Analytics Sheet',
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [
            sheetListProvider.overrideWithValue([testSheet]),
          ],
        ),
        child: DisplaySheetNameWidgetTestUtils.createTestWidget(
          sheetId: 'test-sheet-1',
          sheets: [testSheet],
        ),
      );

      // Verify Flexible wrapper
      final flexible = tester.widget<Flexible>(find.byType(Flexible));
      expect(flexible, isNotNull);
    });

    testWidgets('handles different emoji types', (tester) async {
      final testSheet = DisplaySheetNameWidgetTestUtils.createTestSheet(
        id: 'test-sheet-1',
        emoji: '📊',
        title: 'Test Sheet',
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [
            sheetListProvider.overrideWithValue([testSheet]),
          ],
        ),
        child: DisplaySheetNameWidgetTestUtils.createTestWidget(
          sheetId: 'test-sheet-1',
          sheets: [testSheet],
        ),
      );

      // Verify emoji is displayed
      expect(find.text('📊 Test Sheet'), findsOneWidget);
    });

    testWidgets('handles empty title', (tester) async {
      final testSheet = DisplaySheetNameWidgetTestUtils.createTestSheet(
        id: 'test-sheet-1',
        emoji: '📄',
        title: '',
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [
            sheetListProvider.overrideWithValue([testSheet]),
          ],
        ),
        child: DisplaySheetNameWidgetTestUtils.createTestWidget(
          sheetId: 'test-sheet-1',
          sheets: [testSheet],
        ),
      );

      // Verify empty title is handled
      expect(find.text('📄 '), findsOneWidget);
    });

    testWidgets('handles empty emoji', (tester) async {
      final testSheet = DisplaySheetNameWidgetTestUtils.createTestSheet(
        id: 'test-sheet-1',
        emoji: '',
        title: 'Test Sheet',
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [
            sheetListProvider.overrideWithValue([testSheet]),
          ],
        ),
        child: DisplaySheetNameWidgetTestUtils.createTestWidget(
          sheetId: 'test-sheet-1',
          sheets: [testSheet],
        ),
      );

      // Verify empty emoji is handled
      expect(find.text(' Test Sheet'), findsOneWidget);
    });

    testWidgets('handles multiple sheets in provider', (tester) async {
      final sheets = [
        DisplaySheetNameWidgetTestUtils.createTestSheet(
          id: 'sheet-1',
          emoji: '📊',
          title: 'Analytics',
        ),
        DisplaySheetNameWidgetTestUtils.createTestSheet(
          id: 'sheet-2',
          emoji: '📝',
          title: 'Notes',
        ),
        DisplaySheetNameWidgetTestUtils.createTestSheet(
          id: 'sheet-3',
          emoji: '📋',
          title: 'Tasks',
        ),
      ];

      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [sheetListProvider.overrideWithValue(sheets)],
        ),
        child: DisplaySheetNameWidgetTestUtils.createTestWidget(
          sheetId: 'sheet-2',
          sheets: sheets,
        ),
      );

      // Verify correct sheet is displayed
      expect(find.text('📝 Notes'), findsOneWidget);
    });

    testWidgets('handles sheet ID not found in provider', (tester) async {
      final sheets = [
        DisplaySheetNameWidgetTestUtils.createTestSheet(
          id: 'sheet-1',
          emoji: '📊',
          title: 'Analytics',
        ),
      ];

      await tester.pumpMaterialWidgetWithProviderScope(
        container: ProviderContainer(
          overrides: [sheetListProvider.overrideWithValue(sheets)],
        ),
        child: DisplaySheetNameWidgetTestUtils.createTestWidget(
          sheetId: 'non-existent-sheet',
          sheets: sheets,
        ),
      );

      // Verify widget renders but shows nothing
      expect(find.byType(DisplaySheetNameWidget), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });
  });
}
