import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/service_providers.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/features/auth/screens/signup_screen.dart';
import 'package:zoe/features/auth/services/auth_service.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/mock_preferences.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/auth_utils.dart';

void main() {
  group('SignupScreen Widget Tests', () {
    late ProviderContainer container;
    late MockAuthService mockAuthService;
    late MockPreferencesService mockPreferencesService;

    setUp(() {
      mockAuthService = MockAuthService();
      mockPreferencesService = MockPreferencesService();

      // Setup default mock behaviors
      when(
        () => mockAuthService.authStateChanges,
      ).thenAnswer((_) => Stream.value(null));
      when(() => mockAuthService.currentUser).thenReturn(null);

      // Mock PreferencesService methods
      when(
        () => mockPreferencesService.setLoginUserId(any()),
      ).thenAnswer((_) async => true);
      when(
        () => mockPreferencesService.clearLoginUserId(),
      ).thenAnswer((_) async => true);
      when(
        () => mockPreferencesService.getLoginUserId(),
      ).thenAnswer((_) async => null);

      container = ProviderContainer.test(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
          preferencesServiceProvider.overrideWithValue(mockPreferencesService),
        ],
      );
    });

    L10n getL10n(WidgetTester tester) {
      return WidgetTesterExtension.getL10n(tester, byType: SignupScreen);
    }

    /// Helper to pump the widget with multiple frames to handle animations
    Future<void> pumpSignupScreen(WidgetTester tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const SignupScreen(),
      );
      // Pump a few frames to let AnimatedBackgroundWidget settle
      await tester.pump(const Duration(milliseconds: 100));
    }

    group('UI Components', () {
      testWidgets('displays all required UI elements', (tester) async {
        await pumpSignupScreen(tester);

        final l10n = getL10n(tester);

        // Check for title
        expect(find.text(l10n.createAccount), findsOneWidget);

        // Check for all form fields (name, email, password, confirm password)
        expect(find.byType(TextFormField), findsNWidgets(4));

        // Check for sign up button
        expect(find.byType(ZoePrimaryButton), findsOneWidget);

        // Check for sign in link
        expect(find.text(l10n.alreadyHaveAccount), findsOneWidget);
        expect(find.text(l10n.signIn), findsOneWidget);
      });

      testWidgets('displays all field labels', (tester) async {
        await pumpSignupScreen(tester);

        final l10n = getL10n(tester);

        expect(find.text(l10n.name), findsOneWidget);
        expect(find.text(l10n.email), findsOneWidget);
        expect(find.text(l10n.password), findsOneWidget);
        expect(find.text(l10n.confirmPassword), findsOneWidget);
      });

      testWidgets('password fields are obscured by default', (tester) async {
        await pumpSignupScreen(tester);

        // Both password fields should have visibility icons (meaning obscured)
        expect(find.byIcon(Icons.visibility), findsNWidgets(2));
      });

      testWidgets('displays back button in app bar', (tester) async {
        await pumpSignupScreen(tester);

        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      });
    });

    group('User Interactions', () {
      testWidgets('toggles password visibility when icon is tapped', (
        tester,
      ) async {
        await pumpSignupScreen(tester);

        // Initially both fields obscured - visibility icons should show
        expect(find.byIcon(Icons.visibility), findsNWidgets(2));

        // Tap the first visibility toggle icon (password field)
        final visibilityIcons = find.byIcon(Icons.visibility);
        await tester.ensureVisible(visibilityIcons.first);
        await tester.tap(visibilityIcons.first, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));

        // Should now show visibility_off for password, visibility for confirm
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });

      testWidgets('toggles confirm password visibility independently', (
        tester,
      ) async {
        await pumpSignupScreen(tester);

        // Initially both obscured
        expect(find.byIcon(Icons.visibility), findsNWidgets(2));

        // Tap confirm password visibility toggle (last one)
        final visibilityIcons = find.byIcon(Icons.visibility);
        await tester.ensureVisible(visibilityIcons.last);
        await tester.tap(visibilityIcons.last, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));

        // Only confirm password should be visible
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });

      testWidgets('allows text input in all fields', (tester) async {
        await pumpSignupScreen(tester);

        final fields = find.byType(TextFormField);

        await tester.ensureVisible(fields.at(0));
        await tester.enterText(fields.at(0), 'John Doe');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(1));
        await tester.enterText(fields.at(1), 'test@example.com');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(2));
        await tester.enterText(fields.at(2), 'password123');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(3));
        await tester.enterText(fields.at(3), 'password123');
        await tester.pump(const Duration(milliseconds: 100));

        // Verify via controllers
        final nameField = tester.widget<TextFormField>(fields.at(0));
        final emailField = tester.widget<TextFormField>(fields.at(1));
        final passwordField = tester.widget<TextFormField>(fields.at(2));
        final confirmField = tester.widget<TextFormField>(fields.at(3));

        expect(nameField.controller?.text, 'John Doe');
        expect(emailField.controller?.text, 'test@example.com');
        expect(passwordField.controller?.text, 'password123');
        expect(confirmField.controller?.text, 'password123');
      });

      testWidgets('sign up button is tappable', (tester) async {
        await pumpSignupScreen(tester);

        final signUpButton = find.byType(ZoePrimaryButton);
        expect(signUpButton, findsOneWidget);

        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));
      });
    });

    group('Form Validation', () {
      testWidgets('shows error for empty name', (tester) async {
        await pumpSignupScreen(tester);

        final l10n = getL10n(tester);

        // Trigger validation without entering name
        final signUpButton = find.byType(ZoePrimaryButton);
        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text(l10n.pleaseEnterAValidName), findsOneWidget);
      });

      testWidgets('shows error for invalid email', (tester) async {
        await pumpSignupScreen(tester);

        final l10n = getL10n(tester);

        final fields = find.byType(TextFormField);
        await tester.ensureVisible(fields.at(0));
        await tester.enterText(fields.at(0), 'John Doe');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(1));
        await tester.enterText(fields.at(1), 'invalid-email');
        await tester.pump(const Duration(milliseconds: 100));

        final signUpButton = find.byType(ZoePrimaryButton);
        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text(l10n.pleaseEnterAValidEmail), findsOneWidget);
      });

      testWidgets('shows error for short password', (tester) async {
        await pumpSignupScreen(tester);

        final l10n = getL10n(tester);

        final fields = find.byType(TextFormField);
        await tester.ensureVisible(fields.at(0));
        await tester.enterText(fields.at(0), 'John Doe');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(1));
        await tester.enterText(fields.at(1), 'test@example.com');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(2));
        await tester.enterText(fields.at(2), '123');
        await tester.pump(const Duration(milliseconds: 100));

        final signUpButton = find.byType(ZoePrimaryButton);
        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.text(l10n.passwordMustBeAtLeast6Characters),
          findsOneWidget,
        );
      });

      testWidgets('shows error when passwords do not match', (tester) async {
        await pumpSignupScreen(tester);

        final l10n = getL10n(tester);

        final fields = find.byType(TextFormField);
        await tester.ensureVisible(fields.at(0));
        await tester.enterText(fields.at(0), 'John Doe');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(1));
        await tester.enterText(fields.at(1), 'test@example.com');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(2));
        await tester.enterText(fields.at(2), 'password123');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(3));
        await tester.enterText(fields.at(3), 'password456');
        await tester.pump(const Duration(milliseconds: 100));

        final signUpButton = find.byType(ZoePrimaryButton);
        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text(l10n.passwordsDoNotMatch), findsOneWidget);
      });

      testWidgets('accepts valid form data', (tester) async {
        await pumpSignupScreen(tester);

        final l10n = getL10n(tester);

        final fields = find.byType(TextFormField);
        await tester.ensureVisible(fields.at(0));
        await tester.enterText(fields.at(0), 'John Doe');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(1));
        await tester.enterText(fields.at(1), 'test@example.com');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(2));
        await tester.enterText(fields.at(2), 'password123');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(3));
        await tester.enterText(fields.at(3), 'password123');
        await tester.pump(const Duration(milliseconds: 100));

        final signUpButton = find.byType(ZoePrimaryButton);
        await tester.ensureVisible(signUpButton);
        await tester.tap(signUpButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 300));

        // Should not show validation errors
        expect(find.text(l10n.pleaseEnterAValidName), findsNothing);
        expect(find.text(l10n.pleaseEnterAValidEmail), findsNothing);
        expect(find.text(l10n.passwordMustBeAtLeast6Characters), findsNothing);
        expect(find.text(l10n.passwordsDoNotMatch), findsNothing);
      });
    });

    group('Navigation', () {
      testWidgets('sign in link text is present', (tester) async {
        await pumpSignupScreen(tester);

        final l10n = getL10n(tester);
        expect(find.text(l10n.alreadyHaveAccount), findsOneWidget);
        expect(find.text(l10n.signIn), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles names with special characters', (tester) async {
        await pumpSignupScreen(tester);

        final nameField = find.byType(TextFormField).first;
        await tester.ensureVisible(nameField);
        await tester.enterText(nameField, "José María O'Brien");
        await tester.pump(const Duration(milliseconds: 100));

        final textField = tester.widget<TextFormField>(nameField);
        expect(textField.controller?.text, "José María O'Brien");
      });

      testWidgets('handles very long names', (tester) async {
        await pumpSignupScreen(tester);

        const longName = 'Christopher Alexander Montgomery Wellington III';
        final nameField = find.byType(TextFormField).first;

        await tester.ensureVisible(nameField);
        await tester.enterText(nameField, longName);
        await tester.pump(const Duration(milliseconds: 100));

        final textField = tester.widget<TextFormField>(nameField);
        expect(textField.controller?.text, longName);
      });

      testWidgets('handles complex passwords', (tester) async {
        await pumpSignupScreen(tester);

        final complexPassword = r'P@ssw0rd!#$%^&*()';
        final fields = find.byType(TextFormField);

        await tester.ensureVisible(fields.at(2));
        await tester.enterText(fields.at(2), complexPassword);
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(3));
        await tester.enterText(fields.at(3), complexPassword);
        await tester.pump(const Duration(milliseconds: 100));

        final passwordField = tester.widget<TextFormField>(fields.at(2));
        final confirmField = tester.widget<TextFormField>(fields.at(3));
        expect(passwordField.controller?.text, complexPassword);
        expect(confirmField.controller?.text, complexPassword);
      });
    });

    group('Accessibility', () {
      testWidgets('has semantic labels for all form fields', (tester) async {
        await pumpSignupScreen(tester);

        final l10n = getL10n(tester);

        expect(find.text(l10n.name), findsOneWidget);
        expect(find.text(l10n.email), findsOneWidget);
        expect(find.text(l10n.password), findsOneWidget);
        expect(find.text(l10n.confirmPassword), findsOneWidget);
      });

      testWidgets('button is present', (tester) async {
        await pumpSignupScreen(tester);

        expect(find.byType(ZoePrimaryButton), findsOneWidget);
      });

      testWidgets('visibility toggle icons are accessible', (tester) async {
        await pumpSignupScreen(tester);

        // Should have visibility icons for both password fields
        expect(find.byIcon(Icons.visibility), findsNWidgets(2));
      });
    });

    group('Field Order', () {
      testWidgets('fields are in correct order', (tester) async {
        await pumpSignupScreen(tester);

        final fields = find.byType(TextFormField);
        expect(fields, findsNWidgets(4));

        // Verify order by entering text and checking controllers
        await tester.ensureVisible(fields.at(0));
        await tester.enterText(fields.at(0), 'name');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(1));
        await tester.enterText(fields.at(1), 'email');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(2));
        await tester.enterText(fields.at(2), 'pass');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(fields.at(3));
        await tester.enterText(fields.at(3), 'confirm');
        await tester.pump(const Duration(milliseconds: 100));

        final nameField = tester.widget<TextFormField>(fields.at(0));
        final emailField = tester.widget<TextFormField>(fields.at(1));
        final passwordField = tester.widget<TextFormField>(fields.at(2));
        final confirmField = tester.widget<TextFormField>(fields.at(3));

        expect(nameField.controller?.text, 'name');
        expect(emailField.controller?.text, 'email');
        expect(passwordField.controller?.text, 'pass');
        expect(confirmField.controller?.text, 'confirm');
      });
    });
  });
}
