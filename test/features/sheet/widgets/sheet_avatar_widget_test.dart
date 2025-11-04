import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/styled_content_container_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_network_local_image_view.dart';
import 'package:zoe/common/widgets/zoe_icon_picker/models/zoe_icons.dart';
import 'package:zoe/features/sheet/models/sheet_avatar.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_widget.dart';
import 'package:zoe/features/sheet/widgets/sheet_avatar_type_bottom_sheet.dart';

import '../../../test-utils/test_utils.dart';
import '../utils/sheet_utils.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer.test());

  Future<void> pumpSheetAvatarWidget(
    WidgetTester tester, {
    SheetModel? sheetOverride,
    required String sheetId,
    bool isWithBackground = true,
    bool isCompact = false,
    EdgeInsetsGeometry? padding,
    double? size,
    double? iconSize,
    double? imageSize,
    double? emojiSize,
  }) async {
    if (sheetOverride != null) {
      container = ProviderContainer.test(
        overrides: [
          sheetListProvider.overrideWithValue([sheetOverride]),
        ],
      );
    }

    await tester.pumpMaterialWidgetWithProviderScope(
      container: container,
      child: SheetAvatarWidget(
        sheetId: sheetId,
        isWithBackground: isWithBackground,
        isCompact: isCompact,
        padding: padding,
        size: size,
        iconSize: iconSize,
        imageSize: imageSize,
        emojiSize: emojiSize,
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }

  group('SheetAvatarWidget Tests', () {
    late SheetModel testSheet;

    setUp(() => testSheet = getSheetByIndex(container));

    group('Basic Rendering Tests', () {
      testWidgets('renders correctly with valid sheet', (tester) async {
        await pumpSheetAvatarWidget(tester, sheetId: testSheet.id);

        expect(find.byType(SheetAvatarWidget), findsOneWidget);
      });

      testWidgets('returns SizedBox.shrink when sheet is null', (tester) async {
        await pumpSheetAvatarWidget(tester, sheetId: 'non-existent-sheet');

        expect(find.byType(SheetAvatarWidget), findsOneWidget);
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('renders with default properties', (tester) async {
        await pumpSheetAvatarWidget(tester, sheetId: testSheet.id);

        expect(find.byType(SheetAvatarWidget), findsOneWidget);
        expect(find.byType(Padding), findsWidgets);
      });
    });

    group('Avatar Type Tests', () {
      testWidgets('displays icon when sheet has icon avatar', (tester) async {
        final sheetIcon = ZoeIcon.car;
        final iconSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(icon: sheetIcon, color: Colors.blue),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: iconSheet,
          sheetId: iconSheet.id,
        );

        expect(find.byType(Icon), findsOneWidget);
        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.icon, equals(sheetIcon.data));
      });

      testWidgets('displays emoji when sheet has emoji avatar', (tester) async {
        final sheetEmoji = '🎉';
        final emojiSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(emoji: sheetEmoji),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: emojiSheet,
          sheetId: emojiSheet.id,
        );

        expect(find.text(sheetEmoji), findsOneWidget);
      });

      testWidgets('displays image when sheet has image avatar', (tester) async {
        final sheetImage = 'https://example.com/image.png';
        final imageSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(image: sheetImage),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: imageSheet,
          sheetId: imageSheet.id,
        );

        final image = tester.widget<ZoeNetworkLocalImageView>(
          find.byType(ZoeNetworkLocalImageView),
        );
        expect(image.imageUrl, equals(sheetImage));
      });

      testWidgets('prioritizes image over emoji and icon', (tester) async {
        final mixedSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(
            image: 'https://example.com/image.png',
            emoji: '🎉',
            icon: ZoeIcon.car,
          ),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: mixedSheet,
          sheetId: mixedSheet.id,
        );

        expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
        expect(find.text('🎉'), findsNothing);
        expect(find.byType(Icon), findsNothing);
      });

      testWidgets('prioritizes emoji over icon when no image', (tester) async {
        final mixedSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(emoji: '🎉', icon: ZoeIcon.car),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: mixedSheet,
          sheetId: mixedSheet.id,
        );

        expect(find.text('🎉'), findsOneWidget);
        expect(find.byType(Icon), findsNothing);
      });
    });

    group('Background Mode Tests', () {
      testWidgets('renders with background by default', (tester) async {
        await pumpSheetAvatarWidget(tester, sheetId: testSheet.id);

        expect(find.byType(StyledContentContainer), findsOneWidget);
      });

      testWidgets('renders without background when isWithBackground is false', (
        tester,
      ) async {
        await pumpSheetAvatarWidget(
          tester,
          sheetId: testSheet.id,
          isWithBackground: false,
        );

        expect(find.byType(StyledContentContainer), findsNothing);
      });

      testWidgets('background uses correct size and color', (tester) async {
        final coloredSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(icon: ZoeIcon.car, color: Colors.red),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: coloredSheet,
          sheetId: coloredSheet.id,
        );

        final styledContainer = tester.widget<StyledContentContainer>(
          find.byType(StyledContentContainer),
        );
        expect(styledContainer.size, equals(56)); // Default non-compact size
        expect(styledContainer.primaryColor, equals(Colors.red));
      });
    });

    group('Compact Mode Tests', () {
      testWidgets('uses compact sizes when isCompact is true', (tester) async {
        final iconSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(icon: ZoeIcon.car),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: iconSheet,
          sheetId: iconSheet.id,
          isCompact: true,
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(24)); // Compact icon size
      });

      testWidgets('uses non-compact sizes when isCompact is false', (
        tester,
      ) async {
        final iconSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(icon: ZoeIcon.car),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: iconSheet,
          sheetId: iconSheet.id,
          isCompact: false,
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(34)); // Non-compact icon size
      });

      testWidgets('compact mode affects background size', (tester) async {
        await pumpSheetAvatarWidget(
          tester,
          sheetId: testSheet.id,
          isCompact: true,
        );

        final styledContainer = tester.widget<StyledContentContainer>(
          find.byType(StyledContentContainer),
        );
        expect(styledContainer.size, equals(34)); // Compact size
      });

      testWidgets('compact mode affects emoji size', (tester) async {
        final emojiSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(emoji: '🎉'),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: emojiSheet,
          sheetId: emojiSheet.id,
          isCompact: true,
        );

        final text = tester.widget<Text>(find.text('🎉'));
        expect(text.style?.fontSize, equals(18)); // Compact emoji size
      });

      testWidgets('compact mode affects image size', (tester) async {
        final imageSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(image: 'https://example.com/image.png'),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: imageSheet,
          sheetId: imageSheet.id,
          isCompact: true,
        );

        final image = tester.widget<ZoeNetworkLocalImageView>(
          find.byType(ZoeNetworkLocalImageView),
        );
        expect(image.height, equals(24)); // Compact image size
        expect(image.width, equals(24)); // Compact image size
      });
    });

    group('Custom Size Tests', () {
      testWidgets('uses custom size when provided', (tester) async {
        await pumpSheetAvatarWidget(tester, sheetId: testSheet.id, size: 100);

        final styledContainer = tester.widget<StyledContentContainer>(
          find.byType(StyledContentContainer),
        );
        expect(styledContainer.size, equals(100));
      });

      testWidgets('uses custom iconSize when provided', (tester) async {
        final iconSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(icon: ZoeIcon.car),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: iconSheet,
          sheetId: iconSheet.id,
          iconSize: 50,
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.size, equals(50));
      });

      testWidgets('uses custom imageSize when provided', (tester) async {
        final imageSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(image: 'https://example.com/image.png'),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: imageSheet,
          sheetId: imageSheet.id,
          imageSize: 60,
        );

        final image = tester.widget<ZoeNetworkLocalImageView>(
          find.byType(ZoeNetworkLocalImageView),
        );
        expect(image.height, equals(60));
        expect(image.width, equals(60));
      });

      testWidgets('uses custom emojiSize when provided', (tester) async {
        final emojiSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(emoji: '🎉'),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: emojiSheet,
          sheetId: emojiSheet.id,
          emojiSize: 40,
        );

        final text = tester.widget<Text>(find.text('🎉'));
        expect(text.style?.fontSize, equals(40));
      });
    });

    group('Color Tests', () {
      testWidgets('uses sheet avatar color when provided', (tester) async {
        final coloredSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(icon: ZoeIcon.car, color: Colors.green),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: coloredSheet,
          sheetId: coloredSheet.id,
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        expect(icon.color, equals(Colors.green));
      });

      testWidgets('uses theme primary color when avatar color is null', (
        tester,
      ) async {
        final iconSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(icon: ZoeIcon.car),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: iconSheet,
          sheetId: iconSheet.id,
        );

        final icon = tester.widget<Icon>(find.byType(Icon));
        final theme = Theme.of(tester.element(find.byType(SheetAvatarWidget)));
        expect(icon.color, equals(theme.colorScheme.primary));
      });

      testWidgets('background uses sheet color when provided', (tester) async {
        final coloredSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(icon: ZoeIcon.car, color: Colors.purple),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: coloredSheet,
          sheetId: coloredSheet.id,
        );

        final styledContainer = tester.widget<StyledContentContainer>(
          find.byType(StyledContentContainer),
        );
        expect(styledContainer.primaryColor, equals(Colors.purple));
      });
    });

    group('Editing Mode Tests', () {
      testWidgets('is tappable when sheet is being edited', (tester) async {
        // Set the sheet as editing
        container.read(editContentIdProvider.notifier).state = testSheet.id;

        await pumpSheetAvatarWidget(tester, sheetId: testSheet.id);

        final gestureDetector = tester.widget<GestureDetector>(
          find.byType(GestureDetector),
        );
        expect(gestureDetector.onTap, isNotNull);
      });

      testWidgets('is not tappable when sheet is not being edited', (
        tester,
      ) async {
        // Ensure sheet is not editing
        container.read(editContentIdProvider.notifier).state = 'other-sheet';

        await pumpSheetAvatarWidget(tester, sheetId: testSheet.id);

        final gestureDetector = tester.widget<GestureDetector>(
          find.byType(GestureDetector),
        );
        expect(gestureDetector.onTap, isNull);
      });

      testWidgets('opens bottom sheet when tapped in editing mode', (
        tester,
      ) async {
        // Set the sheet as editing
        container.read(editContentIdProvider.notifier).state = testSheet.id;

        await pumpSheetAvatarWidget(tester, sheetId: testSheet.id);

        // Tap the avatar
        await tester.tap(find.byType(SheetAvatarWidget));
        await tester.pumpAndSettle();

        // Verify bottom sheet is displayed
        expect(find.byType(SheetAvatarTypeBottomSheet), findsOneWidget);
      });
    });

    group('Padding Tests', () {
      testWidgets('uses default padding when not provided', (tester) async {
        await pumpSheetAvatarWidget(tester, sheetId: testSheet.id);

        final padding = tester.widget<Padding>(find.byType(Padding).first);
        final paddingValue = padding.padding as EdgeInsets;
        expect(paddingValue, equals(EdgeInsets.zero));
      });

      testWidgets('uses custom padding when provided', (tester) async {
        const customPadding = EdgeInsets.all(16);

        await pumpSheetAvatarWidget(
          tester,
          sheetId: testSheet.id,
          padding: customPadding,
        );

        final padding = tester.widget<Padding>(find.byType(Padding).first);
        final paddingValue = padding.padding as EdgeInsets;
        expect(paddingValue, equals(customPadding));
      });

      testWidgets('uses symmetric padding when provided', (tester) async {
        const customPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);

        await pumpSheetAvatarWidget(
          tester,
          sheetId: testSheet.id,
          padding: customPadding,
        );

        final padding = tester.widget<Padding>(find.byType(Padding).first);
        final paddingValue = padding.padding as EdgeInsets;
        expect(paddingValue, equals(customPadding));
      });
    });

    group('Widget Integration Tests', () {
      testWidgets('all components render together correctly', (tester) async {
        final iconSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(icon: ZoeIcon.car, color: Colors.blue),
        );

        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: iconSheet,
          sheetId: iconSheet.id,
        );

        expect(find.byType(SheetAvatarWidget), findsOneWidget);
        expect(find.byType(Padding), findsWidgets);
        expect(find.byType(StyledContentContainer), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
      });

      testWidgets('widget handles icon avatar types correctly', (tester) async {
        final iconSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(icon: ZoeIcon.book),
        );
        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: iconSheet,
          sheetId: iconSheet.id,
        );
        expect(find.byType(Icon), findsOneWidget);
      });

      testWidgets('widget handles image avatar types correctly', (
        tester,
      ) async {
        final imageSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(image: 'https://example.com/image.png'),
        );
        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: imageSheet,
          sheetId: imageSheet.id,
        );
        expect(find.byType(ZoeNetworkLocalImageView), findsOneWidget);
      });

      testWidgets('widget handles emoji avatar types correctly', (
        tester,
      ) async {
        final emojiSheet = testSheet.copyWith(
          sheetAvatar: SheetAvatar(emoji: '🎉'),
        );
        await pumpSheetAvatarWidget(
          tester,
          sheetOverride: emojiSheet,
          sheetId: emojiSheet.id,
        );
        expect(find.text('🎉'), findsOneWidget);
      });
    });
  });
}
