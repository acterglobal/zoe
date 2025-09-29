import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/features/profile/widgets/profile_user_bio_widget.dart';
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

  Future<void> pumpProfileUserBioWidget(WidgetTester tester) async {
    await tester.pumpMaterialWidget(
      child: ProfileUserBioWidget(controller: controller),
    );
    await tester.pumpAndSettle();
  }

  group('Layout', () {
    testWidgets('displays bio label with icon', (tester) async {
      await pumpProfileUserBioWidget(tester);

      expect(find.byIcon(Icons.description_outlined), findsOneWidget);
      expect(find.text(L10n.of(tester.element(find.byType(ProfileUserBioWidget))).userBio), findsOneWidget);
    });

    testWidgets('displays AnimatedTextField', (tester) async {
      await pumpProfileUserBioWidget(tester);

      expect(find.byType(AnimatedTextField), findsOneWidget);
    });
    
    testWidgets('configures text field correctly', (tester) async {
      await pumpProfileUserBioWidget(tester);

      final textField = tester.widget<AnimatedTextField>(
        find.byType(AnimatedTextField),
      );

      expect(textField.maxLines, equals(3));
      expect(textField.autofocus, isFalse);
      expect(textField.keyboardType, equals(TextInputType.multiline));
      expect(textField.hintText, equals(L10n.of(tester.element(find.byType(ProfileUserBioWidget))).writeSomethingAboutYourself));
    });
  });

  group('Controller', () {
    testWidgets('updates text field when controller changes', (tester) async {
      await pumpProfileUserBioWidget(tester);

      // Update controller text
      controller.text = 'My bio description';
      await tester.pumpAndSettle();

      // Verify text field shows updated text
      expect(find.text('My bio description'), findsOneWidget);
    });

    testWidgets('updates controller when text field changes', (tester) async {
      await pumpProfileUserBioWidget(tester);

      // Enter text in field
      await tester.enterText(find.byType(AnimatedTextField), 'My bio description');
      await tester.pumpAndSettle();

      // Verify controller has updated text
      expect(controller.text, equals('My bio description'));
    });

    testWidgets('handles multiline input', (tester) async {
      await pumpProfileUserBioWidget(tester);

      // Enter multiline text
      const multilineText = 'First line\nSecond line\nThird line';
      await tester.enterText(find.byType(AnimatedTextField), multilineText);
      await tester.pumpAndSettle();

      // Verify controller has multiline text
      expect(controller.text, equals(multilineText));
    });
  });
}
