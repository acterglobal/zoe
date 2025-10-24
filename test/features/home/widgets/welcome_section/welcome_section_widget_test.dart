import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/utils/date_time_utils.dart';
import 'package:zoe/common/widgets/state_widgets/error_state_widget.dart';
import 'package:zoe/common/widgets/state_widgets/loading_state_widget.dart';
import 'package:zoe/features/home/widgets/welcome_section/welcome_animation_widget.dart';
import 'package:zoe/features/home/widgets/welcome_section/welcome_section_widget.dart';
import 'package:zoe/features/users/models/user_model.dart';
import 'package:zoe/features/users/providers/user_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../../test-utils/test_utils.dart';

class MockUser extends Mock implements UserModel {}

void main() {
  group('WelcomeSectionWidget', () {
    late ProviderContainer container;
    late MockUser mockUser;

    setUp(() {
      container = ProviderContainer.test();
      mockUser = MockUser();
    });

    Future<void> pumpWelcomeSectionWidget(WidgetTester tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const WelcomeSectionWidget(),
      );
    }

    L10n getL10n(WidgetTester tester) {
      return L10n.of(tester.element(find.byType(WelcomeSectionWidget)));
    }

    group('Loading State', () {
      testWidgets('shows loading state when user data is loading', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(const AsyncValue.loading()),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        expect(find.byType(LoadingStateWidget), findsOneWidget);
      });
    });

    group('Error State', () {
      testWidgets('shows error state when user data fails to load', (
        tester,
      ) async {
        const errorMessage = 'Failed to load user data';
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(
              AsyncValue.error(errorMessage, StackTrace.current),
            ),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        expect(find.byType(ErrorStateWidget), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
      });
    });

    group('Data State - With User', () {
      testWidgets('renders welcome section with user name', (tester) async {
        when(() => mockUser.name).thenReturn('John Doe');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        // Verify main container is present
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsAtLeastNWidgets(1));

        // Verify welcome text (using L10n key
        expect(find.text(getL10n(tester).welcomeBack), findsOneWidget);
        expect(find.text('John'), findsOneWidget);

        // Verify animation widget is present
        expect(find.byType(WelcomeAnimationWidget), findsOneWidget);
      });

      testWidgets('renders welcome section with single name', (tester) async {
        when(() => mockUser.name).thenReturn('John');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        expect(find.text(getL10n(tester).welcomeBack), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
      });

      testWidgets('renders welcome section with long name', (tester) async {
        when(() => mockUser.name).thenReturn('John Michael Smith Johnson');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        expect(find.text(getL10n(tester).welcomeBack), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
      });
    });

    group('Data State - Without User', () {
      testWidgets('renders welcome section with guest when user is null', (
        tester,
      ) async {
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(const AsyncValue.data(null)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        // Verify main container is present
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsAtLeastNWidgets(1));

        // Verify welcome text with guest
        expect(find.text(getL10n(tester).welcomeBack), findsOneWidget);
        expect(find.text(getL10n(tester).guest), findsOneWidget);

        // Verify animation widget is present
        expect(find.byType(WelcomeAnimationWidget), findsOneWidget);
      });

      testWidgets(
        'renders welcome section with guest when user name is empty',
        (tester) async {
          when(() => mockUser.name).thenReturn('');
          container = ProviderContainer.test(
            overrides: [
              currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
            ],
          );

          await pumpWelcomeSectionWidget(tester);

          expect(find.text(getL10n(tester).welcomeBack), findsOneWidget);
          // The widget should render without errors when user name is empty
          expect(find.byType(WelcomeSectionWidget), findsOneWidget);
        },
      );
    });

    group('Layout and Styling', () {
      testWidgets('has correct container styling', (tester) async {
        when(() => mockUser.name).thenReturn('John Doe');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        // Find the main container
        final mainContainer = tester.widget<Container>(
          find.byType(Container).first,
        );

        expect(mainContainer.constraints?.maxWidth, equals(double.infinity));
        expect(mainContainer.padding, equals(const EdgeInsets.all(24)));

        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(BorderRadius.circular(20)));
        expect(decoration.gradient, isA<LinearGradient>());
        expect(decoration.boxShadow, isNotNull);
        expect(decoration.boxShadow!.length, equals(1));
      });

      testWidgets('has correct row layout', (tester) async {
        when(() => mockUser.name).thenReturn('John Doe');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        final rows = tester.widgetList<Row>(find.byType(Row));
        expect(rows.length, greaterThanOrEqualTo(1));

        // Find the main row (should have 3 children: Expanded, SizedBox, Expanded)
        final mainRow = rows.firstWhere(
          (row) => row.children.length == 3,
          orElse: () => throw Exception('Main row not found'),
        );

        expect(mainRow.children.length, equals(3));

        // Verify SizedBox spacing
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        final spacingSizedBox = sizedBoxes.firstWhere(
          (box) => box.width == 16,
          orElse: () => throw Exception('Spacing SizedBox not found'),
        );
        expect(spacingSizedBox.width, equals(16));
      });
    });

    group('Welcome Text Widget', () {
      testWidgets('renders welcome text with correct styling', (tester) async {
        when(() => mockUser.name).thenReturn('John Doe');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        // Verify welcome back text
        final welcomeText = find.text(getL10n(tester).welcomeBack);
        expect(welcomeText, findsOneWidget);

        final textWidget = tester.widget<Text>(welcomeText);
        expect(textWidget.style?.color, Colors.white.withValues(alpha: 0.9));
        expect(textWidget.style?.fontWeight, FontWeight.w500);
      });

      testWidgets('renders user name with correct styling', (tester) async {
        when(() => mockUser.name).thenReturn('John Doe');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        // Verify user name text
        final nameText = find.text('John');
        expect(nameText, findsOneWidget);

        final textWidget = tester.widget<Text>(nameText);
        expect(textWidget.style?.color, Colors.white);
        expect(textWidget.style?.fontWeight, FontWeight.w800);
      });
    });

    group('Date Widget', () {
      testWidgets('renders date widget with correct styling', (tester) async {
        when(() => mockUser.name).thenReturn('John Doe');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        // Verify date container
        final dateContainers = tester
            .widgetList<Container>(find.byType(Container))
            .where(
              (container) =>
                  container.padding ==
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            )
            .toList();

        expect(dateContainers.length, equals(1));

        final dateContainer = dateContainers.first;
        final decoration = dateContainer.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(BorderRadius.circular(12)));
        expect(decoration.color, Colors.white.withValues(alpha: 0.15));
      });

      testWidgets('renders date icon with correct properties', (tester) async {
        when(() => mockUser.name).thenReturn('John Doe');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        // Verify date icon
        expect(find.byIcon(Icons.today_rounded), findsOneWidget);

        final icon = tester.widget<Icon>(find.byIcon(Icons.today_rounded));
        expect(icon.color, Colors.white.withValues(alpha: 0.9));
        expect(icon.size, equals(16));
      });

      testWidgets('renders date text with correct styling', (tester) async {
        when(() => mockUser.name).thenReturn('John Doe');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        // Verify date text is present (content will vary based on current date)
        final dateTexts = tester
            .widgetList<Text>(find.byType(Text))
            .where((text) => text.data != null && text.data!.isNotEmpty)
            .toList();

        expect(
          dateTexts.length,
          greaterThanOrEqualTo(3),
        ); // Welcome, name, date

        // Find the date text (should be the one that's not "Welcome back" or user name)
        final welcomeText = getL10n(tester).welcomeBack;
        final dateText = dateTexts.firstWhere(
          (text) => text.data != welcomeText && text.data != 'John',
          orElse: () => throw Exception('Date text not found'),
        );

        expect(dateText.style?.color, Colors.white.withValues(alpha: 0.9));
        expect(dateText.style?.fontWeight, FontWeight.w600);
      });

      testWidgets(
        'renders today date using DateTimeUtils.getTodayDateFormatted',
        (tester) async {
          when(() => mockUser.name).thenReturn('John Doe');
          container = ProviderContainer.test(
            overrides: [
              currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
            ],
          );

          await pumpWelcomeSectionWidget(tester);

          // Get the expected formatted date
          final expectedDate = DateTimeUtils.getTodayDateFormatted();

          // Verify the date text matches the expected format
          expect(find.text(expectedDate), findsOneWidget);

          // Verify the date text has correct styling
          final dateText = find.text(expectedDate);
          final textWidget = tester.widget<Text>(dateText);
          expect(textWidget.style?.color, Colors.white.withValues(alpha: 0.9));
          expect(textWidget.style?.fontWeight, FontWeight.w600);
        },
      );
    });

    group('Accessibility', () {
      testWidgets('has proper semantic structure', (tester) async {
        when(() => mockUser.name).thenReturn('John Doe');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        // Verify key widgets are accessible
        expect(find.byType(Container), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsAtLeastNWidgets(1));
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Text), findsAtLeastNWidgets(3));
        expect(find.byType(Icon), findsAtLeastNWidgets(1));
        expect(find.byType(WelcomeAnimationWidget), findsOneWidget);
      });

      testWidgets('text is properly rendered', (tester) async {
        when(() => mockUser.name).thenReturn('John Doe');
        container = ProviderContainer.test(
          overrides: [
            currentUserProvider.overrideWithValue(AsyncValue.data(mockUser)),
          ],
        );

        await pumpWelcomeSectionWidget(tester);

        // Verify all expected text is present
        expect(find.text(getL10n(tester).welcomeBack), findsOneWidget);
        expect(find.text('John'), findsOneWidget);
        expect(find.byIcon(Icons.today_rounded), findsOneWidget);
      });
    });
  });
}

