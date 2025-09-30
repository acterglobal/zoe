import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/content/providers/content_menu_providers.dart';
import 'package:zoe/features/content/widgets/add_content_widget.dart';
import 'package:zoe/features/content/widgets/content_menu_options.dart';
import 'package:zoe/l10n/generated/l10n.dart';

import '../../../helpers/test_utils.dart';

void main() {
  late ProviderContainer providerContainer;
  late ToggleContentMenu menuController;

  setUp(() {
    menuController = ToggleContentMenu();
    providerContainer = ProviderContainer(
      overrides: [
        toggleContentMenuProvider.overrideWith(() => menuController),
      ],
    );
  });

  tearDown(() {
    providerContainer.dispose();
  });

  group('AddContentWidget', () {
    testWidgets('shows nothing when not editing', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: providerContainer,
        child: AddContentWidget(
          isEditing: false,
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AddContentWidget), findsOneWidget);
      expect(find.byType(ContentMenuOptions), findsNothing);
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('shows toggle button when editing', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: providerContainer,
        child: AddContentWidget(
          isEditing: true,
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = L10n.of(tester.element(find.byType(AddContentWidget)));
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text(l10n.addContent), findsOneWidget);
    });

    testWidgets('toggles menu on button tap', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: providerContainer,
        child: AddContentWidget(
          isEditing: true,
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = L10n.of(tester.element(find.byType(AddContentWidget)));

      // Initially menu is hidden
      expect(find.byType(ContentMenuOptions), findsNothing);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.text(l10n.addContent), findsOneWidget);
      expect(find.text(l10n.cancel), findsNothing);

      // Tap toggle button
      await tester.tap(find.text(l10n.addContent));
      await tester.pump();

      // Menu should be visible
      expect(find.byType(ContentMenuOptions), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text(l10n.addContent), findsNothing);
      expect(find.text(l10n.cancel), findsOneWidget);

      // Tap toggle button again
      await tester.tap(find.text(l10n.cancel));
      await tester.pump();

      // Menu should be hidden
      expect(find.byType(ContentMenuOptions), findsNothing);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.text(l10n.addContent), findsOneWidget);
      expect(find.text(l10n.cancel), findsNothing);
    });

    testWidgets('triggers haptic feedback on toggle', (tester) async {
      bool hapticFeedbackTriggered = false;
      
      // Set up the mock before any widget interaction
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        SystemChannels.platform.name,
        SystemChannels.platform.codec.encodeMethodCall(
          const MethodCall('HapticFeedback.mediumImpact'),
        ),
        (_) {
          hapticFeedbackTriggered = true;
        },
      );

      await tester.pumpMaterialWidgetWithProviderScope(
        container: providerContainer,
        child: AddContentWidget(
          isEditing: true,
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = L10n.of(tester.element(find.byType(AddContentWidget)));
      await tester.tap(find.text(l10n.addContent));
      await tester.pumpAndSettle(); // Wait for all animations and effects to complete
      
      expect(hapticFeedbackTriggered, isTrue);
    });

    testWidgets('calls correct callback and closes menu when option is tapped', (tester) async {
      bool textTapped = false;
      await tester.pumpMaterialWidgetWithProviderScope(
        container: providerContainer,
        child: AddContentWidget(
          isEditing: true,
          onTapText: () => textTapped = true,
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      final l10n = L10n.of(tester.element(find.byType(AddContentWidget)));

      // Open menu
      await tester.tap(find.text(l10n.addContent));
      await tester.pump();

      // Tap text option
      await tester.tap(find.text(l10n.text).last);
      await tester.pump();

      // Verify callback was called and menu is closed
      expect(textTapped, isTrue);
      expect(find.byType(ContentMenuOptions), findsNothing);
    });
    testWidgets('has correct styling', (tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: providerContainer,
        child: AddContentWidget(
          isEditing: true,
          onTapText: () {},
          onTapEvent: () {},
          onTapBulletedList: () {},
          onTapToDoList: () {},
          onTapLink: () {},
          onTapDocument: () {},
          onTapPoll: () {},
        ),
      );
      await tester.pumpAndSettle();

      // Verify toggle button styling
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, equals(const EdgeInsets.symmetric(vertical: 12, horizontal: 4)));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, equals(20));
      expect(icon.color, equals(Theme.of(tester.element(find.byType(AddContentWidget))).colorScheme.primary));

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.color, equals(Theme.of(tester.element(find.byType(AddContentWidget))).colorScheme.primary));
    });  });
}

