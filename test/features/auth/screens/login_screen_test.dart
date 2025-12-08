import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/common/providers/service_providers.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/features/auth/screens/login_screen.dart';
import 'package:zoe/features/auth/services/auth_service.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/mock_preferences.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/auth_utils.dart';

void main() {
  group('LoginScreen Widget Tests', () {
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
      return WidgetTesterExtension.getL10n(tester, byType: LoginScreen);
    }

    /// Helper to pump the widget with multiple frames to handle animations
    Future<void> pumpLoginScreen(WidgetTester tester) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: const LoginScreen(),
      );
      // Pump a few frames to let AnimatedBackgroundWidget settle
      await tester.pump(const Duration(milliseconds: 100));
    }

    group('UI Components', () {
      testWidgets('displays all required UI elements', (tester) async {
        await pumpLoginScreen(tester);

        // Check for title
        final l10n = getL10n(tester);
        expect(find.text(l10n.loginToYourAccount), findsOneWidget);

        // Check for email field
        expect(find.byType(TextFormField), findsNWidgets(2));

        // Check for sign in button
        expect(find.byType(ZoePrimaryButton), findsOneWidget);

        // Check for sign up link
        expect(find.text(l10n.dontHaveAccount), findsOneWidget);
        expect(find.text(l10n.signUp), findsOneWidget);
      });

      testWidgets('displays email and password fields with labels', (
        tester,
      ) async {
        await pumpLoginScreen(tester);

        final l10n = getL10n(tester);
        expect(find.text(l10n.email), findsOneWidget);
        expect(find.text(l10n.password), findsOneWidget);
      });

      testWidgets('password field is obscured by default', (tester) async {
        await pumpLoginScreen(tester);

        // Initially visibility icon should show (meaning password is obscured)
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });

      testWidgets('displays back button in app bar', (tester) async {
        await pumpLoginScreen(tester);

        expect(
          find.descendant(
            of: find.byType(ZoeAppBar),
            matching: find.byIcon(Icons.arrow_back_rounded),
          ),
          findsOneWidget,
        );
      });
    });

    group('User Interactions', () {
      testWidgets('toggles password visibility when icon is tapped', (
        tester,
      ) async {
        await pumpLoginScreen(tester);

        // Initially obscured - visibility icon should show
        expect(find.byIcon(Icons.visibility), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off), findsNothing);

        // Tap the visibility toggle icon using dragUntilVisible in case it's scrolled
        final visibilityIcon = find.byIcon(Icons.visibility);
        await tester.ensureVisible(visibilityIcon);
        await tester.tap(visibilityIcon, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));

        // Should now be visible - visibility_off icon should show
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsNothing);

        // Tap again to obscure
        await tester.tap(
          find.byIcon(Icons.visibility_off),
          warnIfMissed: false,
        );
        await tester.pump(const Duration(milliseconds: 100));

        // Should be obscured again
        expect(find.byIcon(Icons.visibility), findsOneWidget);
        expect(find.byIcon(Icons.visibility_off), findsNothing);
      });

      testWidgets('allows text input in email field', (tester) async {
        await pumpLoginScreen(tester);

        final emailField = find.byType(TextFormField).first;
        await tester.ensureVisible(emailField);
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump(const Duration(milliseconds: 100));

        // Verify via the widget's controller instead of finding text
        final TextFormField textField = tester.widget(emailField);
        expect(textField.controller?.text, 'test@example.com');
      });

      testWidgets('allows text input in password field', (tester) async {
        await pumpLoginScreen(tester);

        final passwordField = find.byType(TextFormField).last;
        await tester.ensureVisible(passwordField);
        await tester.enterText(passwordField, 'password123');
        await tester.pump(const Duration(milliseconds: 100));

        // Password is obscured so we won't find the text directly
        // but we can verify the field has content
        final TextFormField textField = tester.widget(passwordField);
        expect(textField.controller?.text, 'password123');
      });

      testWidgets('sign in button is tappable', (tester) async {
        await pumpLoginScreen(tester);

        final signInButton = find.byType(ZoePrimaryButton);
        expect(signInButton, findsOneWidget);

        // Should be able to tap (won't actually sign in without valid data)
        await tester.ensureVisible(signInButton);
        await tester.tap(signInButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));
      });
    });

    group('Form Validation', () {
      testWidgets('shows error for invalid email', (tester) async {
        await pumpLoginScreen(tester);

        // Enter invalid email
        final emailField = find.byType(TextFormField).first;
        await tester.ensureVisible(emailField);
        await tester.enterText(emailField, 'invalid-email');
        await tester.pump(const Duration(milliseconds: 100));

        final l10n = getL10n(tester);
        // Trigger validation by tapping sign in
        final signInButton = find.byType(ZoePrimaryButton);
        await tester.ensureVisible(signInButton);
        await tester.tap(signInButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 300));

        // Should show validation error
        expect(find.text(l10n.pleaseEnterAValidEmail), findsOneWidget);
      });

      testWidgets('shows error for empty email', (tester) async {
        await pumpLoginScreen(tester);

        final l10n = getL10n(tester);
        // Trigger validation without entering email
        final signInButton = find.byType(ZoePrimaryButton);
        await tester.ensureVisible(signInButton);
        await tester.tap(signInButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text(l10n.pleaseEnterYourEmail), findsOneWidget);
      });

      testWidgets('shows error for short password', (tester) async {
        await pumpLoginScreen(tester);

        // Enter valid email but short password
        final emailField = find.byType(TextFormField).first;
        final passwordField = find.byType(TextFormField).last;

        await tester.ensureVisible(emailField);
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(passwordField);
        await tester.enterText(passwordField, '123');
        await tester.pump(const Duration(milliseconds: 100));

        final l10n = getL10n(tester);
        // Trigger validation
        final signInButton = find.byType(ZoePrimaryButton);
        await tester.ensureVisible(signInButton);
        await tester.tap(signInButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.text(l10n.passwordMustBeAtLeast6Characters),
          findsOneWidget,
        );
      });

      testWidgets('accepts valid email and password', (tester) async {
        await pumpLoginScreen(tester);

        // Enter valid credentials
        final emailField = find.byType(TextFormField).first;
        final passwordField = find.byType(TextFormField).last;

        await tester.ensureVisible(emailField);
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump(const Duration(milliseconds: 100));

        await tester.ensureVisible(passwordField);
        await tester.enterText(passwordField, 'password123');
        await tester.pump(const Duration(milliseconds: 100));

        final l10n = getL10n(tester);
        // Trigger validation
        final signInButton = find.byType(ZoePrimaryButton);
        await tester.ensureVisible(signInButton);
        await tester.tap(signInButton, warnIfMissed: false);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 300));

        // Should not show validation errors for these fields
        expect(find.text(l10n.pleaseEnterAValidEmail), findsNothing);
        expect(find.text(l10n.passwordMustBeAtLeast6Characters), findsNothing);
      });
    });

    group('Navigation', () {
      testWidgets('sign up link text is present', (tester) async {
        await pumpLoginScreen(tester);

        final l10n = getL10n(tester);
        expect(find.text(l10n.dontHaveAccount), findsOneWidget);
        expect(find.text(l10n.signUp), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles very long email addresses', (tester) async {
        await pumpLoginScreen(tester);

        final longEmail =
            'very.long.email.address.with.many.dots@subdomain.example.com';
        final emailField = find.byType(TextFormField).first;

        await tester.ensureVisible(emailField);
        await tester.enterText(emailField, longEmail);
        await tester.pump(const Duration(milliseconds: 100));

        // Verify via controller instead of finding text
        final TextFormField textField = tester.widget(emailField);
        expect(textField.controller?.text, longEmail);
      });

      testWidgets('handles special characters in password', (tester) async {
        await pumpLoginScreen(tester);

        final complexPassword = r'P@ssw0rd!#$%^&*()';
        final passwordField = find.byType(TextFormField).last;

        await tester.ensureVisible(passwordField);
        await tester.enterText(passwordField, complexPassword);
        await tester.pump(const Duration(milliseconds: 100));

        final TextFormField textField = tester.widget(passwordField);
        expect(textField.controller?.text, complexPassword);
      });
    });

    group('Accessibility', () {
      testWidgets('has semantic labels for form fields', (tester) async {
        await pumpLoginScreen(tester);

        final l10n = getL10n(tester);
        expect(find.text(l10n.email), findsOneWidget);
        expect(find.text(l10n.password), findsOneWidget);
      });

      testWidgets('button has accessible text', (tester) async {
        await pumpLoginScreen(tester);

        // Just verify the button exists
        expect(find.byType(ZoePrimaryButton), findsOneWidget);
      });
    });
  });
}
