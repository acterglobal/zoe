import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/display_sheet_name_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_network_local_image_view.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_widget.dart';

import '../../features/sheet/utils/sheet_utils.dart';
import '../../test-utils/test_utils.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer.test();
  });

  group('DisplaySheetNameWidget Tests -', () {
    late SheetModel testSheet;

    setUp(() {
      testSheet = getSheetByIndex(container);
      container = ProviderContainer(
        overrides: [
          sheetListProvider.overrideWithValue([testSheet]),
        ],
      );
    });

    Future<void> pumpDisplaySheetNameWidget(
      WidgetTester tester, {
      ProviderContainer? testContainer,
      String? sheetId,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: testContainer ?? container,
        child: Row(
          children: [DisplaySheetNameWidget(sheetId: sheetId ?? testSheet.id)],
        ),
      );
    }

    testWidgets('renders with required properties', (tester) async {
      await pumpDisplaySheetNameWidget(tester);

      // Verify widget is rendered
      expect(find.byType(DisplaySheetNameWidget), findsOneWidget);
      expect(find.byType(Flexible), findsOneWidget);
      expect(find.byType(Row), findsAtLeastNWidgets(1));
      expect(find.byType(SheetAvatarWidget), findsOneWidget);
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(Text), findsAtLeastNWidgets(1)); // Sheet title text
    });

    testWidgets('displays sheet name and avatar correctly', (tester) async {
      await pumpDisplaySheetNameWidget(tester);

      // Verify sheet name is displayed
      expect(find.text(testSheet.title), findsOneWidget);

      // Verify SheetAvatarWidget is present with correct properties
      final sheetAvatarWidget = tester.widget<SheetAvatarWidget>(
        find.byType(SheetAvatarWidget),
      );
      expect(sheetAvatarWidget.sheetId, equals(testSheet.id));
      expect(sheetAvatarWidget.size, equals(20));
      expect(sheetAvatarWidget.iconSize, equals(12));
      expect(sheetAvatarWidget.imageSize, equals(12));
      expect(sheetAvatarWidget.emojiSize, equals(10));

      // Verify emoji is displayed within SheetAvatarWidget
      if (testSheet.sheetAvatar.type == AvatarType.emoji) {
        expect(find.text(testSheet.sheetAvatar.data), findsOneWidget);
      } else if (testSheet.sheetAvatar.type == AvatarType.image) {
        expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
      } else {
        expect(find.byType(Icon), findsOneWidget);
      }
    });

    testWidgets('handles null sheet gracefully', (tester) async {
      await pumpDisplaySheetNameWidget(tester, sheetId: 'non-existent-sheet');

      // Verify widget renders but shows nothing (SizedBox.shrink)
      expect(find.byType(DisplaySheetNameWidget), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(SheetAvatarWidget), findsNothing);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('wraps content in Flexible widget', (tester) async {
      await pumpDisplaySheetNameWidget(tester);

      // Verify Flexible wrapper
      final flexible = tester.widget<Flexible>(find.byType(Flexible));
      expect(flexible, isNotNull);

      // Verify Row is inside Flexible with correct properties
      // Find the Row that's a direct child of Flexible
      final flexibleWidget = tester.widget<Flexible>(find.byType(Flexible));
      final row = flexibleWidget.child as Row;
      expect(row.mainAxisSize, equals(MainAxisSize.min));
    });

    testWidgets('handles different avatar types', (tester) async {
      await pumpDisplaySheetNameWidget(tester);

      // Verify avatar is displayed through SheetAvatarWidget
      expect(find.byType(SheetAvatarWidget), findsOneWidget);
      if (testSheet.sheetAvatar.type == AvatarType.emoji) {
        expect(find.text(testSheet.sheetAvatar.data), findsOneWidget);
      } else if (testSheet.sheetAvatar.type == AvatarType.image) {
        expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
      } else {
        expect(find.byType(Icon), findsOneWidget);
      }
      expect(find.text(testSheet.title), findsOneWidget);
    });

    testWidgets('handles empty title', (tester) async {
      final emptyTitleSheet = testSheet.copyWith(
        title: '',
        sheetAvatar: testSheet.sheetAvatar.copyWith(
          type: AvatarType.emoji,
          data: '📄',
        ),
      );

      await pumpDisplaySheetNameWidget(
        tester,
        testContainer: ProviderContainer(
          overrides: [
            sheetListProvider.overrideWithValue([emptyTitleSheet]),
          ],
        ),
        sheetId: emptyTitleSheet.id,
      );

      // Verify empty title is handled
      expect(find.text('📄'), findsOneWidget);
      expect(find.text(''), findsOneWidget);
      expect(find.byType(SheetAvatarWidget), findsOneWidget);
    });

    testWidgets('handles multiple sheets in provider', (tester) async {
      final sheets = [
        testSheet.copyWith(
          id: 'sheet-1',
          sheetAvatar: testSheet.sheetAvatar.copyWith(
            type: AvatarType.emoji,
            data: '📊',
          ),
        ),
        testSheet.copyWith(
          id: 'sheet-2',
          sheetAvatar: testSheet.sheetAvatar.copyWith(
            type: AvatarType.image,
            data: 'https://via.placeholder.com/150',
          ),
        ),
        testSheet.copyWith(
          id: 'sheet-3',
          sheetAvatar: testSheet.sheetAvatar.copyWith(
            type: AvatarType.icon,
            data: ZoeIcon.file.name,
          ),
        ),
      ];

      await pumpDisplaySheetNameWidget(
        tester,
        testContainer: ProviderContainer(
          overrides: [sheetListProvider.overrideWithValue(sheets)],
        ),
        sheetId: 'sheet-2',
      );

      // Verify correct sheet is displayed (sheet-2 should have image)
      expect(find.text(testSheet.title), findsOneWidget);
      expect(find.byType(SheetAvatarWidget), findsOneWidget);
      // Sheet-2 has an image, so should show ZoeNetworkLocalImageView
      expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
    });

    testWidgets('handles sheet ID not found in provider', (tester) async {
      // Create a provider with only the existing testSheet, but try to access a different ID
      await pumpDisplaySheetNameWidget(
        tester,
        sheetId: 'non-existent-sheet-id', // Try to access non-existent ID
      );

      // Verify widget renders but shows nothing (SizedBox.shrink)
      expect(find.byType(DisplaySheetNameWidget), findsOneWidget);
      expect(
        find.byType(SizedBox),
        findsAtLeastNWidgets(1),
      ); // May have multiple SizedBox widgets
      expect(find.byType(SheetAvatarWidget), findsNothing);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('applies correct text style to title', (tester) async {
      await pumpDisplaySheetNameWidget(tester);

      // Get the theme from the context
      final BuildContext context = tester.element(
        find.byType(DisplaySheetNameWidget),
      );
      final theme = Theme.of(context);

      // Verify title uses bodySmall text style
      final titleText = tester.widget<Text>(find.text(testSheet.title));
      expect(titleText.style, equals(theme.textTheme.bodySmall));
    });

    testWidgets('applies correct spacing between avatar and title', (
      tester,
    ) async {
      await pumpDisplaySheetNameWidget(tester);

      // Verify SizedBox with correct width is present
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final spacingSizedBox = sizedBoxes.firstWhere(
        (sizedBox) => sizedBox.width == 4,
        orElse: () => throw Exception('SizedBox with width 4 not found'),
      );
      expect(spacingSizedBox.width, equals(4));
    });
  });
}
