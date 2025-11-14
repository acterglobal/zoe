import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_popup_menu_widget.dart';
import 'package:zoe/features/sheet/models/sheet_model.dart';
import 'package:zoe/features/sheet/providers/sheet_providers.dart';
import 'package:zoe/features/sheet/widgets/sheet_app_bar.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/sheet_utils.dart';

void main() {
  group('SheetAppBar Tests', () {
    late ProviderContainer container;
    late SheetModel testSheet;

    setUp(() {
      container = ProviderContainer.test();
      testSheet = getSheetByIndex(container);
    });

    Future<void> pumpSheetAppBar(
      WidgetTester tester, {
      String? sheetId,
      bool isEditing = false,
      SheetModel? customSheet,
    }) async {
      final effectiveSheetId = sheetId ?? testSheet.id;
      final effectiveSheet = customSheet ?? testSheet;

      // Override the sheet provider if using custom sheet
      if (customSheet != null) {
        container = ProviderContainer.test(
          overrides: [
            sheetProvider(effectiveSheetId).overrideWithValue(effectiveSheet),
          ],
        );
      }

      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SheetAppBar(sheetId: effectiveSheetId, isEditing: isEditing),
            ],
          ),
        ),
      );
    }

    group('Basic Rendering', () {
      testWidgets('displays sheet app bar when sheet exists', (tester) async {
        await pumpSheetAppBar(tester);

        // Verify main components are present
        expect(find.byType(SheetAppBar), findsOneWidget);
        expect(find.byType(SliverAppBar), findsOneWidget);
        expect(find.byType(ZoeAppBar), findsOneWidget);
        expect(find.byType(ContentMenuButton), findsOneWidget);
      });

      testWidgets('has correct app bar properties with cover image', (
        tester,
      ) async {
        await pumpSheetAppBar(tester);

        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );

        expect(sliverAppBar.expandedHeight, equals(200));
        expect(sliverAppBar.collapsedHeight, equals(kToolbarHeight));
      });

      testWidgets('has correct app bar properties without cover image', (
        tester,
      ) async {
        await pumpSheetAppBar(
          tester,
          customSheet: testSheet.removeCoverImage(),
        );

        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );

        expect(sliverAppBar.expandedHeight, equals(kToolbarHeight));
        expect(sliverAppBar.collapsedHeight, equals(kToolbarHeight));
      });
    });

    group('Cover Image Handling', () {
      testWidgets('displays expanded app bar with network cover image', (
        tester,
      ) async {
        final sheetWithNetworkImage = testSheet.copyWith(
          coverImageUrl: 'https://example.com/image.jpg',
        );

        await pumpSheetAppBar(tester, customSheet: sheetWithNetworkImage);

        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );

        expect(sliverAppBar.expandedHeight, equals(200));
        expect(sliverAppBar.flexibleSpace, isNotNull);
        expect(find.byType(FlexibleSpaceBar), findsOneWidget);
        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });

      testWidgets('displays expanded app bar with file cover image', (
        tester,
      ) async {
        final sheetWithFileImage = testSheet.copyWith(
          coverImageUrl: '/path/to/local/image.jpg',
        );

        await pumpSheetAppBar(tester, customSheet: sheetWithFileImage);

        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );

        expect(sliverAppBar.expandedHeight, equals(200));
        expect(sliverAppBar.flexibleSpace, isNotNull);
        expect(find.byType(FlexibleSpaceBar), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('network image has correct properties', (tester) async {
        final networkImageUrl = 'https://example.com/image.jpg';
        final sheetWithNetworkImage = testSheet.copyWith(
          coverImageUrl: networkImageUrl,
        );

        await pumpSheetAppBar(tester, customSheet: sheetWithNetworkImage);

        final cachedNetworkImage = tester.widget<CachedNetworkImage>(
          find.byType(CachedNetworkImage),
        );

        expect(cachedNetworkImage.imageUrl, equals(networkImageUrl));
        expect(cachedNetworkImage.fit, equals(BoxFit.cover));
      });

      testWidgets('file image has correct properties', (tester) async {
        final sheetWithFileImage = testSheet.copyWith(
          coverImageUrl: '/path/to/local/image.jpg',
        );

        await pumpSheetAppBar(tester, customSheet: sheetWithFileImage);

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, equals(BoxFit.cover));
      });

      testWidgets('handles null cover image correctly', (tester) async {
        final sheetWithoutImage = testSheet.removeCoverImage();

        await pumpSheetAppBar(tester, customSheet: sheetWithoutImage);

        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );

        expect(sliverAppBar.expandedHeight, equals(kToolbarHeight));
        expect(find.byType(CachedNetworkImage), findsNothing);
        expect(find.byType(Image), findsNothing);
      });
    });

    group('Menu Button Interaction', () {
      testWidgets('menu button is tappable', (tester) async {
        await pumpSheetAppBar(tester);

        final menuButton = find.byType(ContentMenuButton);
        expect(menuButton, findsOneWidget);

        // Tap the menu button
        await tester.tap(menuButton);
        await tester.pump(const Duration(milliseconds: 100));

        // Verify popup menu is shown
        expect(find.byType(PopupMenuItem<ZoePopupMenuItem>), findsWidgets);
      });

      testWidgets('menu shows correct items without cover image', (
        tester,
      ) async {
        final sheetWithoutImage = testSheet.removeCoverImage();
        await pumpSheetAppBar(tester, customSheet: sheetWithoutImage);

        // Tap the menu button
        await tester.tap(find.byType(ContentMenuButton));
        await tester.pump(const Duration(milliseconds: 100));

        // Verify menu items are present
        expect(find.byType(PopupMenuItem<ZoePopupMenuItem>), findsWidgets);

        // Should have "Add Cover Image" option (not "Update" or "Remove")
        expect(find.text("Add cover image"), findsWidgets);
        expect(find.text("Update cover image"), findsNothing);
        expect(find.text("Remove cover image"), findsNothing);
      });

      testWidgets('menu shows correct items with cover image', (tester) async {
        final sheetWithImage = testSheet.copyWith(
          coverImageUrl: 'https://example.com/image.jpg',
        );

        await pumpSheetAppBar(tester, customSheet: sheetWithImage);

        // Tap the menu button
        await tester.tap(find.byType(ContentMenuButton));
        await tester.pump(const Duration(milliseconds: 100));

        // Verify menu items are present
        expect(find.byType(PopupMenuItem<ZoePopupMenuItem>), findsWidgets);

        // Should have "Update Cover Image" and "Remove Cover Image" options
        expect(find.text("Add cover image"), findsNothing);
        expect(find.text("Update cover image"), findsWidgets);
        expect(find.text("Remove cover image"), findsWidgets);
      });
    });

    group('Provider Integration', () {
      testWidgets('watches sheet provider correctly', (tester) async {
        // Remove cover image from the existing test sheet
        container
            .read(sheetListProvider.notifier)
            .updateSheetCoverImage(testSheet.id, null);

        // Pump the widget without customSheet so it uses the actual provider
        await pumpSheetAppBar(tester);

        // Verify initial state
        expect(find.byType(SheetAppBar), findsOneWidget);

        // Verify the app bar initially shows collapsed height for no cover image
        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );
        expect(sliverAppBar.expandedHeight, equals(kToolbarHeight));

        // Update sheet with cover image through provider
        container
            .read(sheetListProvider.notifier)
            .updateSheetCoverImage(
              testSheet.id,
              'https://example.com/new-image.jpg',
            );

        // Wait for the widget to rebuild
        await tester.pump(const Duration(milliseconds: 100));

        // Get the updated widget reference after the provider change
        final updatedSliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );

        // Verify the app bar now shows expanded height for cover image
        expect(updatedSliverAppBar.expandedHeight, equals(200));
      });

      testWidgets('handles null sheet gracefully', (tester) async {
        container = ProviderContainer.test(
          overrides: [sheetProvider(testSheet.id).overrideWithValue(null)],
        );

        await pumpSheetAppBar(tester);

        // Should still render the app bar structure
        expect(find.byType(SheetAppBar), findsOneWidget);
        expect(find.byType(SliverAppBar), findsOneWidget);

        // Should have default collapsed height when sheet is null
        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );
        expect(sliverAppBar.expandedHeight, equals(kToolbarHeight));
      });
    });

    group('Image URL Detection', () {
      testWidgets('correctly identifies network image URLs', (tester) async {
        final networkImageUrls = [
          'http://example.com/image.jpg',
          'https://example.com/image.png',
          'https://cdn.example.com/path/to/image.gif',
        ];

        for (final url in networkImageUrls) {
          final sheetWithNetworkImage = testSheet.copyWith(coverImageUrl: url);

          await pumpSheetAppBar(tester, customSheet: sheetWithNetworkImage);

          // Should use CachedNetworkImage for network URLs
          expect(find.byType(CachedNetworkImage), findsOneWidget);
        }
      });

      testWidgets('correctly identifies file image URLs', (tester) async {
        final fileImageUrls = [
          '/path/to/image.jpg',
          'file:///path/to/image.png',
          'assets/images/cover.jpg',
          'local_image.gif',
        ];

        for (final url in fileImageUrls) {
          final sheetWithFileImage = testSheet.copyWith(coverImageUrl: url);

          await pumpSheetAppBar(tester, customSheet: sheetWithFileImage);

          // Should use regular Image widget for file URLs
          expect(find.byType(Image), findsOneWidget);
        }
      });
    });

    group('Layout Structure', () {
      testWidgets('has correct widget hierarchy', (tester) async {
        await pumpSheetAppBar(tester);

        // Verify the main structure
        expect(find.byType(SheetAppBar), findsOneWidget);
        expect(find.byType(SliverAppBar), findsOneWidget);
        expect(find.byType(ZoeAppBar), findsOneWidget);
        expect(find.byType(ContentMenuButton), findsOneWidget);
      });

      testWidgets('app bar actions are correctly positioned', (tester) async {
        await pumpSheetAppBar(tester);

        final zoeAppBar = tester.widget<ZoeAppBar>(find.byType(ZoeAppBar));

        expect(zoeAppBar.actions, isNotNull);
        expect(
          zoeAppBar.actions!.length,
          equals(2),
        ); // SizedBox + ContentMenuButton
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty cover image URL', (tester) async {
        final sheetWithEmptyUrl = testSheet.copyWith(coverImageUrl: '');

        await pumpSheetAppBar(tester, customSheet: sheetWithEmptyUrl);

        // Empty string should be treated as no cover image
        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );
        expect(sliverAppBar.expandedHeight, equals(kToolbarHeight));
        expect(sliverAppBar.flexibleSpace, isNull);
      });

      testWidgets('handles different sheet IDs correctly', (tester) async {
        const differentSheetId = 'different-sheet-id';
        final differentSheet = testSheet.copyWith(
          id: differentSheetId,
          title: 'Different Sheet',
          coverImageUrl: 'https://example.com/different-image.jpg',
        );

        container = ProviderContainer.test(
          overrides: [
            sheetProvider(differentSheetId).overrideWithValue(differentSheet),
          ],
        );

        await pumpSheetAppBar(
          tester,
          sheetId: differentSheetId,
          customSheet: differentSheet,
        );

        // Should render correctly with different sheet
        expect(find.byType(SheetAppBar), findsOneWidget);
        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });

      testWidgets('handles malformed image URLs gracefully', (tester) async {
        final sheetWithMalformedUrl = testSheet.copyWith(
          coverImageUrl: 'not-a-valid-url',
        );

        await pumpSheetAppBar(tester, customSheet: sheetWithMalformedUrl);

        // Should still render without crashing
        expect(find.byType(SheetAppBar), findsOneWidget);
        // Should treat as file image since it doesn't start with 'http'
        expect(find.byType(Image), findsOneWidget);
      });
    });
  });
}
