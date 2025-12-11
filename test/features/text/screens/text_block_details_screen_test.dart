import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/providers/common_providers.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/emoji_widget.dart';
import 'package:zoe/common/widgets/floating_action_button_wrapper.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_html_inline_text_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_inline_text_edit_widget.dart';
import 'package:zoe/features/content/widgets/content_widget.dart';
import 'package:zoe/features/text/data/text_list.dart';
import 'package:zoe/features/text/providers/text_providers.dart';
import 'package:zoe/features/text/screens/text_block_details_screen.dart';
import 'package:zoe/features/users/providers/user_providers.dart';

import '../../../test-utils/test_utils.dart';
import '../utils/mock_fakefirestore_text.dart';

void main() {
  group('TextBlockDetailsScreen', () {
    late ProviderContainer container;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() async {
      fakeFirestore = FakeFirebaseFirestore();
      container = ProviderContainer(
        overrides: [
          firestoreProvider.overrideWithValue(fakeFirestore),
          loggedInUserProvider.overrideWithValue(AsyncValue.data(testUser)),
        ],
      );

      for (final text in textList) {
        await fakeFirestore.collection('texts').doc(text.id).set(text.toJson());
      }

      int retries = 0;
      while (container.read(textListProvider).length < textList.length &&
          retries < 20) {
        await Future.delayed(const Duration(milliseconds: 50));
        retries++;
      }
    });

    testWidgets('renders empty state when text block not found', (
      tester,
    ) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'non-existent-id'),
        container: container,
      );

      await tester.pump();

      // Should render empty state components
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.byType(ZoeAppBar), findsOneWidget);
    });

    testWidgets('renders correctly with valid text block', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'text-content-1'),
        container: container,
      );

      await tester.pump();

      // Should render main components
      expect(find.byType(ZoeAppBar), findsOneWidget);
      expect(find.byType(MaxWidthWidget), findsOneWidget);
      expect(find.byType(FloatingActionButtonWrapper), findsOneWidget);

      // Should render text block elements
      expect(find.byType(ZoeInlineTextEditWidget), findsAtLeastNWidgets(1));
      expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
      expect(find.byType(ContentMenuButton), findsOneWidget);
      expect(find.byType(EmojiWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('renders ContentWidget', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'text-content-2'),
        container: container,
      );

      await tester.pump();

      // Should render ContentWidget
      expect(find.byType(ContentWidget), findsOneWidget);
    });

    testWidgets('handles different text IDs', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'text-content-3'),
        container: container,
      );

      await tester.pump();

      // Should render correctly for specific text ID
      expect(find.byType(ZoeInlineTextEditWidget), findsOneWidget);
    });

    testWidgets('responds to editing state changes', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'text-content-1'),
        container: container,
      );

      await tester.pump();

      // Trigger editing mode
      container.read(editContentIdProvider.notifier).state = 'text-content-1';
      await tester.pump();

      // Widgets should still be present
      expect(find.byType(MaxWidthWidget), findsOneWidget);

      // Stop editing
      container.read(editContentIdProvider.notifier).state = null;
      await tester.pump();
    });

    testWidgets('applies correct styling defaults', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'text-content-1'),
        container: container,
      );

      await tester.pump();

      // Check app bar configuration
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.automaticallyImplyLeading, false);
    });

    testWidgets('renders emoji widget correctly', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'text-content-1'),
        container: container,
      );

      await tester.pump();

      // Should render emoji widget
      expect(find.byType(EmojiWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('renders title widget correctly', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'text-content-2'),
        container: container,
      );

      await tester.pump();

      // Should render title widget
      expect(find.byType(ZoeInlineTextEditWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('renders description widget correctly', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'text-content-3'),
        container: container,
      );

      await tester.pump();

      // Should render description widget
      expect(find.byType(ZoeHtmlTextEditWidget), findsOneWidget);
    });

    testWidgets('includes ContentMenuButton in app bar', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'text-content-1'),
        container: container,
      );

      await tester.pump();

      // Should render ContentMenuButton
      expect(find.byType(ContentMenuButton), findsOneWidget);

      // Should include ZoeAppBar with actions
      expect(find.byType(ZoeAppBar), findsOneWidget);
    });

    testWidgets('includes FloatingActionButtonWrapper', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'text-content-2'),
        container: container,
      );

      await tester.pump();

      expect(find.byType(FloatingActionButtonWrapper), findsOneWidget);
    });

    testWidgets('handles empty/null text block gracefully', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        child: const TextBlockDetailsScreen(textBlockId: 'empty-id'),
        container: container,
      );

      await tester.pump();

      // Should show empty state
      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });
  });
}
