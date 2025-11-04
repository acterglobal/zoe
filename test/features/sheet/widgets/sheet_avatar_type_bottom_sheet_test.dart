import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/bottom_sheet_option_widget.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_type_bottom_sheet.dart';
import 'package:zoe/l10n/generated/l10n.dart';

import '../../../test-utils/test_utils.dart';
import '../utils/sheet_utils.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer.test());

  Future<void> pumpSheetAvatarTypeBottomSheet(
    WidgetTester tester, {
    required String sheetId,
  }) async {
    await tester.pumpMaterialWidgetWithProviderScope(
      container: container,
      child: SheetAvatarTypeBottomSheet(sheetId: sheetId),
    );
    await tester.pumpAndSettle();

    // Verify bottom sheet is displayed
    expect(find.byType(SheetAvatarTypeBottomSheet), findsOneWidget);
  }

  Future<void> openSheetAvatarTypeBottomSheet(
    WidgetTester tester, {
    required String sheetId,
  }) async {
    final buttonText = 'Show Sheet';

    await tester.pumpActionsWidget(
      container: container,
      buttonText: buttonText,
      onPressed: (context, ref) =>
          SheetAvatarTypeBottomSheet.show(context, sheetId),
    );
    await tester.pumpAndSettle();

    // Tap the button to show the bottom sheet
    await tester.tap(find.text(buttonText));
    await tester.pumpAndSettle();

    // Verify bottom sheet is displayed
    expect(find.byType(SheetAvatarTypeBottomSheet), findsOneWidget);
  }

  L10n getL10n(WidgetTester tester) {
    return L10n.of(tester.element(find.byType(SheetAvatarTypeBottomSheet)));
  }

  group('SheetAvatarTypeBottomSheet Widget Tests', () {
    late SheetModel testSheet;

    setUp(() {
      testSheet = getSheetByIndex(container);
    });

    group('Basic Rendering Tests', () {
      testWidgets('renders correctly with all required elements', (
        tester,
      ) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        // Verify widget is rendered
        expect(find.byType(SheetAvatarTypeBottomSheet), findsOneWidget);

        // Verify title is displayed
        final l10n = getL10n(tester);
        expect(find.text(l10n.selectSheetAvatarType), findsOneWidget);

        // Verify subtitle is displayed
        expect(find.text(l10n.chooseSheetAvatarType), findsOneWidget);

        // Verify all three option widgets are present
        expect(find.byType(BottomSheetOptionWidget), findsNWidgets(3));
      });

      testWidgets('displays icon option with correct properties', (
        tester,
      ) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        final l10n = getL10n(tester);
        // Verify icon option title
        expect(find.text(l10n.icon), findsOneWidget);
        // Verify icon option subtitle
        expect(find.text(l10n.chooseIconDescription), findsOneWidget);
        // Verify icon option icon
        expect(find.byIcon(Icons.category_rounded), findsOneWidget);
      });

      testWidgets('displays image option with correct properties', (
        tester,
      ) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        final l10n = getL10n(tester);
        // Verify image option title
        expect(find.text(l10n.image), findsOneWidget);
        // Verify image option subtitle
        expect(find.text(l10n.chooseImageDescription), findsOneWidget);
        // Verify image option icon
        expect(find.byIcon(Icons.image_rounded), findsOneWidget);
      });

      testWidgets('displays emoji option with correct properties', (
        tester,
      ) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        final l10n = getL10n(tester);
        // Verify emoji option title
        expect(find.text(l10n.emoji), findsOneWidget);
        // Verify emoji option subtitle
        expect(find.text(l10n.chooseEmojiDescription), findsOneWidget);
        // Verify emoji option icon
        expect(find.byIcon(Icons.emoji_emotions_rounded), findsOneWidget);
      });

      testWidgets('title has correct text style', (tester) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        final l10n = getL10n(tester);
        final titleText = tester.widget<Text>(
          find.text(l10n.selectSheetAvatarType),
        );

        expect(titleText.textAlign, TextAlign.center);
        expect(titleText.style?.fontWeight, FontWeight.w600);
      });

      testWidgets('subtitle has correct text style', (tester) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        final l10n = getL10n(tester);
        final subtitleText = tester.widget<Text>(
          find.text(l10n.chooseSheetAvatarType),
        );

        expect(subtitleText.textAlign, TextAlign.center);
      });
    });

    group('Static show Method Tests', () {
      testWidgets('show displays the bottom sheet correctly', (tester) async {
        // Set a larger screen size to accommodate the bottom sheet
        await tester.binding.setSurfaceSize(const Size(800, 1200));

        // Open the bottom sheet
        await openSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        // Verify bottom sheet is displayed
        expect(find.byType(SheetAvatarTypeBottomSheet), findsOneWidget);

        // Verify bottom sheet properties
        final bottomSheet =
            find.byType(Material).evaluate().last.widget as Material;
        expect(bottomSheet.shape, isA<RoundedRectangleBorder>());

        // Reset the screen size
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('show bottom sheet has correct shape', (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 1200));

        // Open the bottom sheet
        await openSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        final bottomSheet =
            find.byType(Material).evaluate().last.widget as Material;
        final shape = bottomSheet.shape as RoundedRectangleBorder;
        expect(
          shape.borderRadius,
          equals(const BorderRadius.vertical(top: Radius.circular(20))),
        );

        await tester.binding.setSurfaceSize(null);
      });
    });

    group('Option Widget Interaction Tests', () {
      testWidgets('all option widgets are tappable', (tester) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        // Find all BottomSheetOptionWidget instances
        final optionWidgets = find.byType(BottomSheetOptionWidget);
        expect(optionWidgets, findsNWidgets(3));

        // Verify each option widget has an onTap callback
        for (final element in optionWidgets.evaluate()) {
          final widget = element.widget as BottomSheetOptionWidget;
          expect(widget.onTap, isNotNull);
        }
      });

      testWidgets('option widgets are displayed in correct order', (
        tester,
      ) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        final l10n = getL10n(tester);
        final optionWidgets = find
            .byType(BottomSheetOptionWidget)
            .evaluate()
            .toList();

        // Verify order: Icon, Image, Emoji
        expect(
          (optionWidgets[0].widget as BottomSheetOptionWidget).title,
          equals(l10n.icon),
        );
        expect(
          (optionWidgets[1].widget as BottomSheetOptionWidget).title,
          equals(l10n.image),
        );
        expect(
          (optionWidgets[2].widget as BottomSheetOptionWidget).title,
          equals(l10n.emoji),
        );
      });

      testWidgets('icon option has correct icon and color', (tester) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        final optionWidgets = find
            .byType(BottomSheetOptionWidget)
            .evaluate()
            .toList();
        final iconOption = optionWidgets[0].widget as BottomSheetOptionWidget;

        expect(iconOption.icon, equals(Icons.category_rounded));
        expect(iconOption.color, isNotNull);
      });

      testWidgets('image option has correct icon and color', (tester) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        final optionWidgets = find
            .byType(BottomSheetOptionWidget)
            .evaluate()
            .toList();
        final imageOption = optionWidgets[1].widget as BottomSheetOptionWidget;

        expect(imageOption.icon, equals(Icons.image_rounded));
        expect(imageOption.color, isNotNull);
      });

      testWidgets('emoji option has correct icon and color', (tester) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        final optionWidgets = find
            .byType(BottomSheetOptionWidget)
            .evaluate()
            .toList();
        final emojiOption = optionWidgets[2].widget as BottomSheetOptionWidget;

        expect(emojiOption.icon, equals(Icons.emoji_emotions_rounded));
        expect(emojiOption.color, isNotNull);
      });
    });

    group('Widget with Different Sheet States', () {
      testWidgets('works with sheet that has icon avatar', (tester) async {
        final iconSheet = testSheet.copyWith(
          title: 'Icon Sheet',
          sheetAvatar: SheetAvatar(icon: ZoeIcon.car, color: Colors.blue),
        );

        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: iconSheet.id);

        expect(find.byType(SheetAvatarTypeBottomSheet), findsOneWidget);
      });

      testWidgets('works with sheet that has image avatar', (tester) async {
        final imageSheet = testSheet.copyWith(
          title: 'Image Sheet',
          sheetAvatar: SheetAvatar(image: 'https://example.com/image.png'),
        );

        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: imageSheet.id);

        expect(find.byType(SheetAvatarTypeBottomSheet), findsOneWidget);
      });

      testWidgets('works with sheet that has emoji avatar', (tester) async {
        final emojiSheet = testSheet.copyWith(
          title: 'Emoji Sheet',
          sheetAvatar: SheetAvatar(emoji: '🎉'),
        );

        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: emojiSheet.id);

        expect(find.byType(SheetAvatarTypeBottomSheet), findsOneWidget);
      });
    });

    group('Spacing and Layout Tests', () {
      testWidgets('has correct spacing between elements', (tester) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        // Find all SizedBox widgets with height 8 or 16
        final sizedBoxes = find.byType(SizedBox).evaluate().where((element) {
          final widget = element.widget as SizedBox;
          return widget.height == 8 || widget.height == 16;
        });

        // Should have at least spacing widgets
        expect(sizedBoxes.length, greaterThanOrEqualTo(2));
      });

      testWidgets('padding includes viewInsets.bottom', (tester) async {
        await pumpSheetAvatarTypeBottomSheet(tester, sheetId: testSheet.id);

        final padding = tester.widget<Padding>(find.byType(Padding).first);
        final paddingValue = padding.padding as EdgeInsets;
        final viewInsets = MediaQuery.of(
          tester.element(find.byType(SheetAvatarTypeBottomSheet)),
        ).viewInsets.bottom;

        expect(paddingValue.bottom, equals(viewInsets + 16.0));
      });
    });
  });
}
