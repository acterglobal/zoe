import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/common/widgets/dialogs/info_dialog_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/common/widgets/toolkit/zoe_secondary_button.dart';
import '../../../test-utils/test_utils.dart';
import 'package:mocktail/mocktail.dart';
import '../../../test-utils/mock_gorouter.dart';

void main() {
  const title = 'Test Title';
  const description = 'Test Description';
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockGoRouter = MockGoRouter();
    when(() => mockGoRouter.pop()).thenAnswer((_) {});
    when(() => mockGoRouter.canPop()).thenReturn(true);
  });

  Future<void> pumpInfoDialog(
    WidgetTester tester, {
    double iconSize = 130,
    IconData? icon,
    String title = title,
    String description = description,
    bool isShowTextField = false,
    bool isPasswordField = false,
    bool isFieldRequired = false,
    String? labelText,
    String? hintText,
    String? primaryButtonText,
    required Function(String) onPrimary,
    String? secondaryButtonText,
    VoidCallback? onSecondary,
  }) async {
    await tester.pumpMaterialWidget(
      router: mockGoRouter,
      child: InfoDialogWidget(
        iconSize: iconSize,
        icon: icon,
        title: title,
        description: description,
        isShowTextField: isShowTextField,
        isPasswordField: isPasswordField,
        isFieldRequired: isFieldRequired,
        labelText: labelText,
        hintText: hintText,
        primaryButtonText: primaryButtonText,
        onPrimary: onPrimary,
        secondaryButtonText: secondaryButtonText,
        onSecondary: onSecondary,
      ),
    );
  }

  group('InfoDialogWidget', () {
    testWidgets('renders title, description and icon correctly', (
      tester,
    ) async {
      const icon = Icons.info;

      await pumpInfoDialog(tester, icon: icon, onPrimary: (_) {});

      expect(find.text(title), findsOneWidget);
      expect(find.text(description), findsOneWidget);
      expect(find.byIcon(icon), findsOneWidget);
    });

    testWidgets('shows text field when isShowTextField is true', (
      tester,
    ) async {
      const labelText = 'Label';

      await pumpInfoDialog(
        tester,
        isShowTextField: true,
        labelText: labelText,
        onPrimary: (_) {},
      );

      expect(find.byType(AnimatedTextField), findsOneWidget);
      expect(find.text(labelText), findsOneWidget);
    });

    testWidgets('hides text field when isShowTextField is false', (
      tester,
    ) async {
      await pumpInfoDialog(tester, isShowTextField: false, onPrimary: (_) {});

      expect(find.byType(AnimatedTextField), findsNothing);
    });

    testWidgets('calls onPrimary with text value', (tester) async {
      String? result;
      const value = 'test value';

      await pumpInfoDialog(
        tester,
        isShowTextField: true,
        onPrimary: (value) => result = value,
      );

      await tester.enterText(find.byType(AnimatedTextField), value);
      await tester.tap(find.byType(ZoePrimaryButton));
      await tester.pump();

      expect(result, equals(value));
    });

    testWidgets('validates required field', (tester) async {
      bool called = false;
      await pumpInfoDialog(
        tester,
        isShowTextField: true,
        isFieldRequired: true,
        onPrimary: (_) => called = true,
      );

      // Tap button without entering text
      await tester.tap(find.byType(ZoePrimaryButton));
      await tester.pump();

      expect(called, isFalse);

      final l10n = WidgetTesterExtension.getL10n(
        tester,
        byType: InfoDialogWidget,
      );
      expect(find.text(l10n.pleaseEnterAPassword), findsOneWidget);
    });

    testWidgets('calls onSecondary when tapped', (tester) async {
      bool called = false;
      const secondaryButtonText = 'Cancel';

      await pumpInfoDialog(
        tester,
        secondaryButtonText: secondaryButtonText,
        onSecondary: () => called = true,
        onPrimary: (_) {},
      );

      expect(find.text(secondaryButtonText), findsOneWidget);
      expect(find.byType(ZoeSecondaryButton), findsOneWidget);
      await tester.tap(find.byType(ZoeSecondaryButton));
      expect(called, isTrue);
    });

    testWidgets('shows visible text when isPasswordField is false', (
      tester,
    ) async {
      await pumpInfoDialog(
        tester,
        isShowTextField: true,
        isPasswordField: false,
        onPrimary: (_) {},
      );

      final textFieldFinder = find.byType(AnimatedTextField);
      var textField = tester.widget<AnimatedTextField>(textFieldFinder);
      expect(textField.obscureText, isFalse);

      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('toggles password visibility', (tester) async {
      await pumpInfoDialog(
        tester,
        isShowTextField: true,
        isPasswordField: true,
        onPrimary: (_) {},
      );

      final textFieldFinder = find.byType(AnimatedTextField);
      var textField = tester.widget<AnimatedTextField>(textFieldFinder);
      expect(textField.obscureText, isTrue);

      // Tap toggle button
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      textField = tester.widget<AnimatedTextField>(textFieldFinder);
      expect(textField.obscureText, isFalse);

      // Tap toggle button again
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      textField = tester.widget<AnimatedTextField>(textFieldFinder);
      expect(textField.obscureText, isTrue);
    });

    testWidgets('uses custom button text', (tester) async {
      const primaryText = 'Custom Primary';
      const secondaryText = 'Custom Secondary';

      await pumpInfoDialog(
        tester,
        primaryButtonText: primaryText,
        secondaryButtonText: secondaryText,
        onSecondary: () {},
        onPrimary: (_) {},
      );

      expect(find.text(primaryText), findsOneWidget);
      expect(find.text(secondaryText), findsOneWidget);
    });

    testWidgets('uses default button text', (tester) async {
      await pumpInfoDialog(tester, onSecondary: () {}, onPrimary: (_) {});

      final l10n = WidgetTesterExtension.getL10n(
        tester,
        byType: InfoDialogWidget,
      );

      expect(find.text(l10n.confirm), findsOneWidget);
      expect(find.text(l10n.cancel), findsOneWidget);
    });
  });
}
