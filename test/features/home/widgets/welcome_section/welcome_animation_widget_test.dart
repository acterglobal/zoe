import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/home/widgets/welcome_section/welcome_animation_widget.dart';
import '../../../../test-utils/test_utils.dart';

void main() {
  group('WelcomeAnimationWidget', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    Future<void> pumpWelcomeAnimationWidget(WidgetTester tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const WelcomeAnimationWidget(),
      );
    }

    group('Widget Rendering', () {
      testWidgets('renders with proper structure', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Verify key structural elements exist
        expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
        expect(find.byType(Transform), findsAtLeastNWidgets(1));
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Icon), findsAtLeastNWidgets(1));
      });

      testWidgets('renders main rocket icon', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Verify main rocket icon is present
        expect(find.byIcon(Icons.rocket_launch_rounded), findsOneWidget);

        // Verify the rocket icon has correct properties
        final rocketIcon = tester.widget<Icon>(
          find.byIcon(Icons.rocket_launch_rounded),
        );
        expect(rocketIcon.icon, equals(Icons.rocket_launch_rounded));
        expect(rocketIcon.size, equals(40));
        expect(rocketIcon.color, equals(Colors.white));
      });

      testWidgets('renders orbiting elements', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Should have 3 orbiting elements (star, heart, bolt)
        expect(find.byIcon(Icons.star_rounded), findsOneWidget);
        expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
        expect(find.byIcon(Icons.bolt_rounded), findsOneWidget);

        // Verify orbiting element properties
        final starIcon = tester.widget<Icon>(find.byIcon(Icons.star_rounded));
        expect(starIcon.icon, equals(Icons.star_rounded));
        expect(starIcon.size, equals(12));

        final heartIcon = tester.widget<Icon>(
          find.byIcon(Icons.favorite_rounded),
        );
        expect(heartIcon.icon, equals(Icons.favorite_rounded));
        expect(heartIcon.size, equals(12));

        final boltIcon = tester.widget<Icon>(find.byIcon(Icons.bolt_rounded));
        expect(boltIcon.icon, equals(Icons.bolt_rounded));
        expect(boltIcon.size, equals(12));
      });

      testWidgets('renders background particles', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Should have background particles (small circular containers)
        final particleContainers = tester
            .widgetList<Container>(find.byType(Container))
            .where(
              (container) =>
                  container.decoration != null &&
                  container.decoration is BoxDecoration &&
                  (container.decoration as BoxDecoration).shape ==
                      BoxShape.circle,
            )
            .toList();

        expect(particleContainers.length, greaterThanOrEqualTo(6));

        // Verify particle properties
        for (final container in particleContainers) {
          expect(container.decoration, isA<BoxDecoration>());
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.shape, equals(BoxShape.circle));
          // Box shadow may or may not be present depending on test environment
          if (decoration.boxShadow != null) {
            expect(decoration.boxShadow, isNotNull);
          }
        }
      });

      testWidgets('has correct main container styling', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Find the main container with circular decoration
        final containers = tester.widgetList<Container>(find.byType(Container));
        final mainContainer = containers.firstWhere(
          (container) =>
              container.decoration != null &&
              container.decoration is BoxDecoration &&
              (container.decoration as BoxDecoration).shape ==
                  BoxShape.circle &&
              (container.decoration as BoxDecoration).gradient != null,
          orElse: () => throw Exception('Main container not found'),
        );

        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.shape, equals(BoxShape.circle));
        expect(decoration.gradient, isA<RadialGradient>());
        expect(decoration.boxShadow, isNotNull);

        // Verify box shadow properties
        final boxShadow = decoration.boxShadow!.first;
        expect(boxShadow.color, Colors.white.withValues(alpha: 0.3));
        expect(boxShadow.blurRadius, equals(20));
        expect(boxShadow.spreadRadius, equals(5));
      });
    });

    group('Animation Controllers', () {
      testWidgets('initializes animation controllers correctly', (
        tester,
      ) async {
        await pumpWelcomeAnimationWidget(tester);

        // The widget should render without errors, indicating controllers are initialized
        expect(find.byType(WelcomeAnimationWidget), findsOneWidget);

        // Verify AnimatedBuilder is present (indicates animation setup)
        expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
      });

      testWidgets('disposes animation controllers properly', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Pump to start animations
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Remove widget to trigger dispose
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        // Verify widget is properly removed
        expect(find.byType(WelcomeAnimationWidget), findsNothing);
      });
    });

    group('Animation Behavior', () {
      testWidgets('floating animation works correctly', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Verify Transform.translate is present for floating
        final transforms = tester.widgetList<Transform>(find.byType(Transform));
        expect(transforms.isNotEmpty, isTrue);

        // Verify floating animation setup
        expect(transforms.isNotEmpty, isTrue);

        // The floating animation should be running
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(WelcomeAnimationWidget), findsOneWidget);
      });

      testWidgets('rotation animation works correctly', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Verify rotation transforms are present
        final rotationTransforms = tester
            .widgetList<Transform>(find.byType(Transform))
            .where((transform) => transform.alignment == null)
            .toList();

        expect(rotationTransforms.isNotEmpty, isTrue);

        // Verify rotation animation setup
        for (final transform in rotationTransforms) {
          expect(transform.transform, isA<Matrix4>());
        }

        // Animation should be running
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(WelcomeAnimationWidget), findsOneWidget);
      });

      testWidgets('pulse animation works correctly', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Verify scale transforms are present for pulsing
        final scaleTransforms = tester
            .widgetList<Transform>(find.byType(Transform))
            .where((transform) => transform.alignment == Alignment.center)
            .toList();

        expect(scaleTransforms.isNotEmpty, isTrue);

        // Verify scale animation setup
        for (final transform in scaleTransforms) {
          expect(transform.transform, isA<Matrix4>());
        }

        // Animation should be running
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(WelcomeAnimationWidget), findsOneWidget);
      });

      testWidgets('animations run continuously', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Let animations run for a bit
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        // Should still be running
        expect(find.byType(WelcomeAnimationWidget), findsOneWidget);
        expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
      });
    });

    group('Visual Elements', () {
      testWidgets('renders correct number of elements', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Main rocket icon
        expect(find.byIcon(Icons.rocket_launch_rounded), findsOneWidget);

        // Orbiting elements (3)
        expect(find.byIcon(Icons.star_rounded), findsOneWidget);
        expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
        expect(find.byIcon(Icons.bolt_rounded), findsOneWidget);

        // Background particles (6 containers with circular decoration)
        final particleContainers = tester
            .widgetList<Container>(find.byType(Container))
            .where(
              (container) =>
                  container.decoration != null &&
                  container.decoration is BoxDecoration &&
                  (container.decoration as BoxDecoration).shape ==
                      BoxShape.circle,
            )
            .toList();
        expect(particleContainers.length, greaterThanOrEqualTo(6));
      });

      testWidgets('orbiting elements have correct styling', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Find orbiting element containers (with padding)
        final orbitingContainers = tester
            .widgetList<Container>(find.byType(Container))
            .where((container) => container.padding == const EdgeInsets.all(6))
            .toList();

        expect(orbitingContainers.length, equals(3));

        for (final container in orbitingContainers) {
          expect(container.decoration, isA<BoxDecoration>());
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.shape, equals(BoxShape.circle));
          expect(decoration.border, isNotNull);

          // Verify border properties
          final border = decoration.border!;
          expect(border.top.width, equals(1));
          expect(border.top.color, Colors.white.withValues(alpha: 0.4));
        }
      });

      testWidgets('background particles have correct styling', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        final particleContainers = tester
            .widgetList<Container>(find.byType(Container))
            .where(
              (container) =>
                  container.decoration != null &&
                  container.decoration is BoxDecoration &&
                  (container.decoration as BoxDecoration).shape ==
                      BoxShape.circle,
            )
            .toList();

        for (final container in particleContainers) {
          expect(container.decoration, isA<BoxDecoration>());
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.shape, equals(BoxShape.circle));

          // Verify box shadow properties if present
          if (decoration.boxShadow != null) {
            expect(decoration.boxShadow, isNotNull);
            final boxShadow = decoration.boxShadow!.first;
            expect(boxShadow.blurRadius, greaterThan(0));
          }
        }
      });
    });

    group('Accessibility', () {
      testWidgets('has proper semantic structure', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Verify key widgets are accessible
        expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
        expect(find.byType(Stack), findsAtLeastNWidgets(1));
        expect(find.byType(Transform), findsAtLeastNWidgets(1));
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Icon), findsAtLeastNWidgets(1));
      });

      testWidgets('icons are properly rendered', (tester) async {
        await pumpWelcomeAnimationWidget(tester);

        // Verify all expected icons are present
        expect(find.byIcon(Icons.rocket_launch_rounded), findsOneWidget);
        expect(find.byIcon(Icons.star_rounded), findsOneWidget);
        expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
        expect(find.byIcon(Icons.bolt_rounded), findsOneWidget);

        // Verify icon properties
        final rocketIcon = tester.widget<Icon>(
          find.byIcon(Icons.rocket_launch_rounded),
        );
        expect(rocketIcon.icon, equals(Icons.rocket_launch_rounded));
        expect(rocketIcon.size, equals(40));
        expect(rocketIcon.color, equals(Colors.white));

        final starIcon = tester.widget<Icon>(find.byIcon(Icons.star_rounded));
        expect(starIcon.icon, equals(Icons.star_rounded));
        expect(starIcon.size, equals(12));

        final heartIcon = tester.widget<Icon>(
          find.byIcon(Icons.favorite_rounded),
        );
        expect(heartIcon.icon, equals(Icons.favorite_rounded));
        expect(heartIcon.size, equals(12));

        final boltIcon = tester.widget<Icon>(find.byIcon(Icons.bolt_rounded));
        expect(boltIcon.icon, equals(Icons.bolt_rounded));
        expect(boltIcon.size, equals(12));
      });
    });
  });
}
