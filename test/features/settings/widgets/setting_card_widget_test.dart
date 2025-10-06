import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/glassy_container_widget.dart';
import 'package:zoe/features/settings/widgets/setting_card_widget.dart';
import '../../../test-utils/test_utils.dart';

void main() {
  Future<void> createWidgetUnderTest({
    required WidgetTester tester,
    required String title,
    List<Widget> children = const [],
    Color? titleColor,
  }) async {
    await tester.pumpMaterialWidget(
      child: SettingCardWidget(
        title: title,
        titleColor: titleColor,
        children: children,
      ),
    );
  }

  testWidgets('displays title correctly', (tester) async {
    const testTitle = 'Test Settings';
    await createWidgetUnderTest(
      tester: tester,
      title: testTitle,
    );

    expect(find.text(testTitle), findsOneWidget);
  });

  testWidgets('displays children widgets', (tester) async {
    final testChildren = [
      const Text('Child 1'),
      const Text('Child 2'),
    ];

    await createWidgetUnderTest(
      tester: tester,
      title: 'Test',
      children: testChildren,
    );

    expect(find.text('Child 1'), findsOneWidget);
    expect(find.text('Child 2'), findsOneWidget);
  });

  testWidgets('uses GlassyContainer for content', (tester) async {
    await createWidgetUnderTest(
      tester: tester,
      title: 'Test',
      children: const [Text('Content')],
    );

    expect(find.byType(GlassyContainer), findsOneWidget);
  });

  testWidgets('applies custom title color when provided', (tester) async {
    const testColor = Colors.red;
    await createWidgetUnderTest(
      tester: tester,
      title: 'Test',
      titleColor: testColor,
    );

    final titleWidget = tester.widget<Text>(find.text('Test'));
    expect(
      titleWidget.style?.color,
      equals(testColor),
    );
  });

  testWidgets('uses theme color when titleColor is not provided',
      (tester) async {
    await createWidgetUnderTest(
      tester: tester,
      title: 'Test',
    );

    final titleWidget = tester.widget<Text>(find.text('Test'));
    // The color should come from the theme's titleSmall style
    expect(titleWidget.style?.color, isNotNull);
  });

  testWidgets('has correct padding for title', (tester) async {
    await createWidgetUnderTest(
      tester: tester,
      title: 'Test',
    );

    final paddingWidget = tester.widget<Padding>(
      find.ancestor(
        of: find.text('Test'),
        matching: find.byType(Padding),
      ),
    );

    expect(
      paddingWidget.padding,
      equals(const EdgeInsets.only(left: 8, bottom: 12)),
    );
  });
}
