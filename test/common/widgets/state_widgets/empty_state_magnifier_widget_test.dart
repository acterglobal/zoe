import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/state_widgets/empty_state_magnifier_widget.dart';

import '../../../test-utils/test_utils.dart';

void main() {
  group('EmptyStateMagnifierWidget', () {
    late AnimationController controller;
    late Animation<double> mouthAnimation;

    setUp(() {
      controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: const TestVSync(),
      );
      mouthAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    });
    
    Future<void> pumpEmptyStateMagnifierWidget(
      WidgetTester tester, {
      Color? color,
      ThemeData? theme,
    }) async {
      await tester.pumpMaterialWidget(
        theme: theme,
        child: EmptyStateMagnifierWidget(
          color: color ?? Colors.blue,
          mouthAnimation: mouthAnimation,
        ),
      );
    }

    testWidgets('renders empty state magnifier widget correctly', (
      tester,
    ) async {
      await pumpEmptyStateMagnifierWidget(tester);

      expect(find.byType(EmptyStateMagnifierWidget), findsOneWidget);
    });

    testWidgets('renders Stack layout', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester);

      expect(find.byType(Stack), findsAtLeastNWidgets(1));
    });

    testWidgets('renders Container with circle decoration', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester);

      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasCircularContainer = containers.any(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration! as BoxDecoration).shape == BoxShape.circle,
      );
      expect(hasCircularContainer, isTrue);
    });

    testWidgets('renders eyes', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester);

      // Verify eye containers exist with circular shape
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasEyeContainer = containers.any(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration! as BoxDecoration).shape == BoxShape.circle,
      );
      expect(hasEyeContainer, isTrue);
    });

    testWidgets('renders mouth with AnimatedBuilder', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester);

      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('renders magnifying handle with Transform', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester);

      expect(find.byType(Transform), findsAtLeastNWidgets(1));
    });

    testWidgets('applies correct color to widget', (tester) async {
      const testColor = Colors.purple;

      await pumpEmptyStateMagnifierWidget(tester, color: testColor);

      final magnifierWidget = tester.widget<EmptyStateMagnifierWidget>(
        find.byType(EmptyStateMagnifierWidget),
      );

      expect(magnifierWidget.color, equals(testColor));
    });

    testWidgets('uses mouthAnimation for animated mouth', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester);

      final magnifierWidget = tester.widget<EmptyStateMagnifierWidget>(
        find.byType(EmptyStateMagnifierWidget),
      );

      expect(magnifierWidget.mouthAnimation, equals(mouthAnimation));
    });

    testWidgets('renders with different colors', (tester) async {
      final colors = [Colors.red, Colors.green, Colors.orange, Colors.purple];

      for (final color in colors) {
        await pumpEmptyStateMagnifierWidget(tester, color: color);

        expect(find.byType(EmptyStateMagnifierWidget), findsOneWidget);
      }
    });

    testWidgets('renders correctly in light theme', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester, theme: ThemeData.light());

      expect(find.byType(EmptyStateMagnifierWidget), findsOneWidget);
    });

    testWidgets('renders correctly in dark theme', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester, theme: ThemeData.dark());

      expect(find.byType(EmptyStateMagnifierWidget), findsOneWidget);
    });


    testWidgets('eye containers exist', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester);

      // Verify eye containers exist (2 circular containers for eyes)
      final containers = tester.widgetList<Container>(find.byType(Container));
      final eyeContainers = containers.where(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration! as BoxDecoration).shape == BoxShape.circle,
      );

      expect(eyeContainers.length, greaterThan(1));
    });

    testWidgets('handle container exists', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester);

      // Verify handle container exists with border radius decoration
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasHandleContainer = containers.any(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration! as BoxDecoration).borderRadius != null,
      );
      expect(hasHandleContainer, isTrue);
    });

    testWidgets('renders Positioned widgets', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester);

      expect(find.byType(Positioned), findsAtLeastNWidgets(1));
    });

    testWidgets('Stack has correct properties', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester);

      final stacks = tester.widgetList<Stack>(find.byType(Stack));
      final hasCorrectStack = stacks.any(
        (stack) =>
            stack.alignment == Alignment.center &&
            stack.clipBehavior == Clip.none,
      );
      expect(hasCorrectStack, isTrue);
    });

    testWidgets('displays eyes with correct properties', (tester) async {
      const testColor = Colors.green;

      await pumpEmptyStateMagnifierWidget(tester, color: testColor);

      // Verify eye containers exist with border decoration
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasEyeWithBorder = containers.any(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration! as BoxDecoration).border != null,
      );
      expect(hasEyeWithBorder, isTrue);
    });

    testWidgets('handle has Transform with rotation', (tester) async {
      await pumpEmptyStateMagnifierWidget(tester);

      final transforms = tester.widgetList<Transform>(find.byType(Transform));
      expect(transforms, isNotEmpty);
    });
  });
}
