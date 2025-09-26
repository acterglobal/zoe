import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/features/quick-search/widgets/quick_search_tab_section_header_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../helpers/test_utils.dart';

void main() {
  group('QuickSearchTabSectionHeaderWidget', () {
    late VoidCallback mockOnTap;

    setUp(() {
      mockOnTap = () {};
    });

    testWidgets('renders all required components correctly', (tester) async {
      const title = 'Test Title';
      const icon = Icons.search;
      const color = Colors.blue;

      await tester.pumpMaterialWidget(
        child: QuickSearchTabSectionHeaderWidget(
          title: title,
          icon: icon,
          onTap: mockOnTap,
          color: color,
        ),
      );

      // Verify all components are rendered
      expect(find.text(title), findsOneWidget);
      expect(find.byType(StyledIconContainer), findsOneWidget);
      
      // Find View All text and verify it's wrapped in GestureDetector
      final viewAllFinder = find.text(L10n.of(tester.element(find.byType(QuickSearchTabSectionHeaderWidget))).viewAll);
      expect(viewAllFinder, findsOneWidget);
      expect(find.ancestor(of: viewAllFinder, matching: find.byType(GestureDetector)), findsOneWidget);
    });

    testWidgets('calls onTap when View All is tapped', (tester) async {
      bool wasTapped = false;
      await tester.pumpMaterialWidget(
        child: QuickSearchTabSectionHeaderWidget(
          title: 'Test',
          icon: Icons.search,
          onTap: () => wasTapped = true,
          color: Colors.blue,
        ),
      );

      // Find and tap the View All text
      final viewAllFinder = find.text(L10n.of(tester.element(find.byType(QuickSearchTabSectionHeaderWidget))).viewAll);
      await tester.tap(find.ancestor(of: viewAllFinder, matching: find.byType(GestureDetector)));
      await tester.pumpAndSettle();

      expect(wasTapped, true);
    });

    testWidgets('applies correct styling and colors', (tester) async {
      const testColor = Colors.red;
      await tester.pumpMaterialWidget(
        child: QuickSearchTabSectionHeaderWidget(
          title: 'Test',
          icon: Icons.search,
          onTap: mockOnTap,
          color: testColor,
        ),
      );

      // Verify StyledIconContainer has correct color
      final iconContainer = tester.widget<StyledIconContainer>(
        find.byType(StyledIconContainer),
      );
      expect(iconContainer.primaryColor, testColor);

      // Verify View All text has correct color
      final viewAllText = tester.widget<Text>(
        find.text(L10n.of(tester.element(find.byType(QuickSearchTabSectionHeaderWidget))).viewAll),
      );
      expect(viewAllText.style?.color, testColor);
    });

    testWidgets('displays localized View All text', (tester) async {
      await tester.pumpMaterialWidget(
        child: QuickSearchTabSectionHeaderWidget(
          title: 'Test',
          icon: Icons.search,
          onTap: mockOnTap,
          color: Colors.blue,
        ),
      );

      // Verify localized View All text is displayed
      expect(find.text(L10n.of(tester.element(find.byType(QuickSearchTabSectionHeaderWidget))).viewAll), findsOneWidget);
    });
  });
}
