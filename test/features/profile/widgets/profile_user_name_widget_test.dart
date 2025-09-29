import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/features/profile/widgets/profile_user_name_widget.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../helpers/test_utils.dart';

void main() {
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  tearDown(() {
    controller.dispose();
  });

  Future<void> pumpProfileUserNameWidget(WidgetTester tester) async {
    await tester.pumpMaterialWidget(
      child: ProfileUserNameWidget(controller: controller),
    );
    await tester.pumpAndSettle();
  }

  group('Layout', () {
    testWidgets('displays user name label with icon', (tester) async {
      await pumpProfileUserNameWidget(tester);

      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
      expect(find.text(L10n.of(tester.element(find.byType(ProfileUserNameWidget))).userName), findsOneWidget);
    });

    testWidgets('displays AnimatedTextField', (tester) async {
      await pumpProfileUserNameWidget(tester);

      expect(find.byType(AnimatedTextField), findsOneWidget);
    });
  });

  group('Validation', () {
    testWidgets('shows error when name is empty', (tester) async {
      await pumpProfileUserNameWidget(tester);

      // Enter empty text
      await tester.enterText(find.byType(AnimatedTextField), '');
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text(L10n.of(tester.element(find.byType(ProfileUserNameWidget))).nameCannotBeEmpty), findsOneWidget);
    });

    testWidgets('shows error when name contains only spaces', (tester) async {
      await pumpProfileUserNameWidget(tester);

      // Enter spaces
      await tester.enterText(find.byType(AnimatedTextField), '   ');
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text(L10n.of(tester.element(find.byType(ProfileUserNameWidget))).nameCannotBeEmpty), findsOneWidget);
    });

    testWidgets('shows no error with valid name', (tester) async {
      await pumpProfileUserNameWidget(tester);

      // Enter valid name
      await tester.enterText(find.byType(AnimatedTextField), 'John Doe');
      await tester.pumpAndSettle();

      // Verify no error message is shown
      expect(find.text(L10n.of(tester.element(find.byType(ProfileUserNameWidget))).nameCannotBeEmpty), findsNothing);
    });

    testWidgets('validates on submission', (tester) async {
      await pumpProfileUserNameWidget(tester);

      // Enter empty text and submit
      await tester.enterText(find.byType(AnimatedTextField), '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text(L10n.of(tester.element(find.byType(ProfileUserNameWidget))).nameCannotBeEmpty), findsOneWidget);
    });
  });

  group('Controller', () {
    testWidgets('updates text field when controller changes', (tester) async {
      await pumpProfileUserNameWidget(tester);

      // Update controller text
      controller.text = 'Jane Doe';
      await tester.pumpAndSettle();

      // Verify text field shows updated text
      expect(find.text('Jane Doe'), findsOneWidget);
    });

    testWidgets('updates controller when text field changes', (tester) async {
      await pumpProfileUserNameWidget(tester);

      // Enter text in field
      await tester.enterText(find.byType(AnimatedTextField), 'Jane Doe');
      await tester.pumpAndSettle();

      // Verify controller has updated text
      expect(controller.text, equals('Jane Doe'));
    });
  });
}
