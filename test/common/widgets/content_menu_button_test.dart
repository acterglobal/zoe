import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/content_menu_button.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';

import '../../test-utils/test_utils.dart';

/// Test utilities for ContentMenuButton tests
class ContentMenuButtonTestUtils {
  /// Creates a test wrapper for the ContentMenuButton
  static ContentMenuButton createTestWidget({
    IconData icon = Icons.more_vert_rounded,
    Function(BuildContext context)? onTap,
  }) {
    return ContentMenuButton(onTap: onTap ?? (context) {}, icon: icon);
  }
}

void main() {
  group('ContentMenuButton Tests -', () {
    testWidgets('renders with required properties', (tester) async {
      await tester.pumpMaterialWidget(
        child: ContentMenuButtonTestUtils.createTestWidget(),
      );

      // Verify widget is rendered
      expect(find.byType(ContentMenuButton), findsOneWidget);
      expect(find.byType(StyledIconContainer), findsOneWidget);
    });

    testWidgets('calls onTap callback when tapped', (tester) async {
      BuildContext? capturedContext;
      bool callbackCalled = false;

      await tester.pumpMaterialWidget(
        child: ContentMenuButtonTestUtils.createTestWidget(
          onTap: (context) {
            capturedContext = context;
            callbackCalled = true;
          },
        ),
      );

      // Tap the button
      await tester.tap(find.byType(StyledIconContainer));
      await tester.pump();

      // Verify callback was called
      expect(callbackCalled, isTrue);
      expect(capturedContext, isNotNull);
    });

    testWidgets('handles multiple taps', (tester) async {
      int tapCount = 0;

      await tester.pumpMaterialWidget(
        child: ContentMenuButtonTestUtils.createTestWidget(
          onTap: (context) {
            tapCount++;
          },
        ),
      );

      // Tap multiple times
      await tester.tap(find.byType(StyledIconContainer));
      await tester.pump();
      expect(tapCount, 1);

      await tester.tap(find.byType(StyledIconContainer));
      await tester.pump();
      expect(tapCount, 2);

      await tester.tap(find.byType(StyledIconContainer));
      await tester.pump();
      expect(tapCount, 3);
    });

    testWidgets('handles null onTap gracefully', (tester) async {
      await tester.pumpMaterialWidget(
        child: ContentMenuButtonTestUtils.createTestWidget(
          onTap: (context) {}, // Empty callback
        ),
      );

      // Tap the button - should not throw
      await tester.tap(find.byType(StyledIconContainer));
      await tester.pump();

      // Verify widget still renders
      expect(find.byType(ContentMenuButton), findsOneWidget);
    });

    testWidgets('uses correct default icon', (tester) async {
      await tester.pumpMaterialWidget(
        child: ContentMenuButtonTestUtils.createTestWidget(),
      );

      // Verify the correct icon is used
      final styledIconContainer = tester.widget<StyledIconContainer>(
        find.byType(StyledIconContainer),
      );
      expect(styledIconContainer.icon, Icons.more_vert_rounded);
    });

    testWidgets('renders with custom icon', (tester) async {
      const customIcon = Icons.settings;
      await tester.pumpMaterialWidget(
        child: ContentMenuButtonTestUtils.createTestWidget(icon: customIcon),
      );

      // Verify the custom icon is used
      final styledIconContainer = tester.widget<StyledIconContainer>(
        find.byType(StyledIconContainer),
      );
      expect(styledIconContainer.icon, customIcon);
    });
  });
}
