import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/styled_icon_container_widget.dart';
import 'package:zoe/features/settings/widgets/setting_item_widget.dart';
import '../../../helpers/test_utils.dart';

void main() {
  late VoidCallback mockOnTap;

  setUp(() {
    mockOnTap = () {};
  });

  Future<void> createWidgetUnderTest({
    required WidgetTester tester,
    String title = 'Test Title',
    String subtitle = 'Test Subtitle',
    IconData icon = Icons.settings,
    Color iconColor = Colors.blue,
    VoidCallback? onTap,
  }) async {
    await tester.pumpMaterialWidget(
      child: SettingItemWidget(
        title: title,
        subtitle: subtitle,
        icon: icon,
        iconColor: iconColor,
        onTap: onTap ?? mockOnTap,
      ),
    );
  }

  testWidgets('displays title correctly', (tester) async {
    const testTitle = 'Settings Title';
    await createWidgetUnderTest(
      tester: tester,
      title: testTitle,
    );

    expect(find.text(testTitle), findsOneWidget);
  });

  testWidgets('displays subtitle correctly', (tester) async {
    const testSubtitle = 'Settings Subtitle';
    await createWidgetUnderTest(
      tester: tester,
      subtitle: testSubtitle,
    );

    expect(find.text(testSubtitle), findsOneWidget);
  });

  testWidgets('displays icon in StyledIconContainer', (tester) async {
    const testIcon = Icons.language;
    await createWidgetUnderTest(
      tester: tester,
      icon: testIcon,
    );

    final iconContainer = tester.widget<StyledIconContainer>(
      find.byType(StyledIconContainer),
    );
    expect(iconContainer.icon, equals(testIcon));
  });

  testWidgets('applies correct icon color', (tester) async {
    const testColor = Colors.red;
    await createWidgetUnderTest(
      tester: tester,
      iconColor: testColor,
    );

    final iconContainer = tester.widget<StyledIconContainer>(
      find.byType(StyledIconContainer),
    );
    expect(iconContainer.primaryColor, equals(testColor));
  });

  testWidgets('has correct padding', (tester) async {
    await createWidgetUnderTest(tester: tester);

    final listTile = tester.widget<ListTile>(find.byType(ListTile));
    expect(
      listTile.contentPadding,
      equals(const EdgeInsets.symmetric(horizontal: 20, vertical: 8)),
    );
  });

  testWidgets('shows chevron icon', (tester) async {
    await createWidgetUnderTest(tester: tester);

    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    bool wasTapped = false;
    await createWidgetUnderTest(
      tester: tester,
      onTap: () => wasTapped = true,
    );

    await tester.tap(find.byType(ListTile));
    await tester.pump();

    expect(wasTapped, isTrue);
  });

  testWidgets('truncates long subtitle with ellipsis', (tester) async {
    const longSubtitle = 'This is a very long subtitle that should be truncated '
        'because it exceeds the maximum number of lines allowed';
    await createWidgetUnderTest(
      tester: tester,
      subtitle: longSubtitle,
    );

    final subtitleWidget = tester.widget<Text>(
      find.text(longSubtitle),
    );
    expect(subtitleWidget.maxLines, equals(1));
    expect(subtitleWidget.overflow, equals(TextOverflow.ellipsis));
  });
}
