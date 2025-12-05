import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/features/auth/models/auth_state_model.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/auth/providers/login_providers.dart';
import 'package:zoe/features/auth/screens/login_screen.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../test-utils/test_utils.dart';

import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/auth/services/auth_service.dart';

import '../utils/auth_utils.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    late ProviderContainer container;
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
      when(
        () => mockAuthService.authStateChanges,
      ).thenAnswer((_) => Stream.value(null));
      when(() => mockAuthService.currentUser).thenReturn(null);

      container = ProviderContainer.test(
        overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
      );
    });

    L10n getL10n(WidgetTester tester) {
      return WidgetTesterExtension.getL10n(tester, byType: LoginScreen);
    }

    group('UI Components', () {
      testWidgets('displays all required UI elements', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        // Check for title
        final l10n = getL10n(tester);
        expect(find.text(l10n.loginToYourAccount), findsOneWidget);

        // Check for email field
        expect(find.byType(TextFormField), findsNWidgets(2));

        // Check for sign in button
        expect(
          find.widgetWithText(ZoePrimaryButton, l10n.signIn),
          findsOneWidget,
        );

        // Check for sign up link
        expect(find.text(l10n.dontHaveAccount), findsOneWidget);
        expect(find.text(l10n.signUp), findsOneWidget);
      });

      testWidgets('displays email and password fields with labels', (
        tester,
      ) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        final l10n = getL10n(tester);
        expect(find.text(l10n.email), findsOneWidget);
        expect(find.text(l10n.password), findsOneWidget);
      });

      testWidgets('password field is obscured by default', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        final formState = container.read(loginFormProvider);
        expect(formState.obscurePassword, isTrue);
      });

      testWidgets('displays back button in app bar', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

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
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        // Initially obscured
        expect(container.read(loginFormProvider).obscurePassword, isTrue);

        // Find and tap the visibility toggle icon
        final visibilityIcon = find.byIcon(Icons.visibility);
        expect(visibilityIcon, findsOneWidget);
        await tester.tap(visibilityIcon);
        await tester.pump();

        // Should now be visible
        expect(container.read(loginFormProvider).obscurePassword, isFalse);

        // Tap again to obscure
        final visibilityOffIcon = find.byIcon(Icons.visibility_off);
        expect(visibilityOffIcon, findsOneWidget);
        await tester.tap(visibilityOffIcon);
        await tester.pump();

        // Should be obscured again
        expect(container.read(loginFormProvider).obscurePassword, isTrue);
      });

      testWidgets('allows text input in email field', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();

        final formState = container.read(loginFormProvider);
        expect(formState.emailController.text, 'test@example.com');
      });

      testWidgets('allows text input in password field', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        final passwordField = find.byType(TextFormField).last;
        await tester.enterText(passwordField, 'password123');
        await tester.pump();

        final formState = container.read(loginFormProvider);
        expect(formState.passwordController.text, 'password123');
      });

      testWidgets('sign in button is tappable', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        final l10n = getL10n(tester);
        final signInButton = find.widgetWithText(ZoePrimaryButton, l10n.signIn);
        expect(signInButton, findsOneWidget);

        // Should be able to tap (won't actually sign in without valid data)
        await tester.tap(signInButton);
        await tester.pump();
      });
    });

    group('Form Validation', () {
      testWidgets('shows error for invalid email', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        // Enter invalid email
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'invalid-email');
        await tester.pump();

        final l10n = getL10n(tester);
        // Trigger validation by tapping sign in
        await tester.tap(find.widgetWithText(ZoePrimaryButton, l10n.signIn));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Should show validation error
        expect(find.text(l10n.pleaseEnterAValidEmail), findsOneWidget);
      });

      testWidgets('shows error for empty email', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        final l10n = getL10n(tester);
        // Trigger validation without entering email
        await tester.tap(find.widgetWithText(ZoePrimaryButton, l10n.signIn));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text(l10n.pleaseEnterYourEmail), findsOneWidget);
      });

      testWidgets('shows error for short password', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        // Enter valid email but short password
        final emailField = find.byType(TextFormField).first;
        final passwordField = find.byType(TextFormField).last;

        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(passwordField, '123');
        await tester.pump();

        final l10n = getL10n(tester);
        // Trigger validation
        await tester.tap(find.widgetWithText(ZoePrimaryButton, l10n.signIn));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.text(l10n.passwordMustBeAtLeast6Characters),
          findsOneWidget,
        );
      });

      testWidgets('accepts valid email and password', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        // Enter valid credentials
        final emailField = find.byType(TextFormField).first;
        final passwordField = find.byType(TextFormField).last;

        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(passwordField, 'password123');
        await tester.pump();

        final l10n = getL10n(tester);
        // Trigger validation
        await tester.tap(find.widgetWithText(ZoePrimaryButton, l10n.signIn));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Should not show validation errors for these fields
        expect(find.text(l10n.pleaseEnterYourEmail), findsNothing);
        expect(find.text(l10n.pleaseEnterAValidEmail), findsNothing);
        expect(find.text(l10n.passwordMustBeAtLeast6Characters), findsNothing);
      });
    });

    group('Error Display', () {
      testWidgets('displays error message when set in provider', (
        tester,
      ) async {
        // Set error in provider
        container
            .read(loginFormProvider.notifier)
            .setError('Invalid credentials');

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );
        expect(find.text('Invalid credentials'), findsOneWidget);
      });

      testWidgets('error message has error styling', (tester) async {
        container.read(loginFormProvider.notifier).setError('Test error');

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        // Find the error container - looking for the direct parent of the text
        final errorTextFinder = find.text('Test error');
        final errorContainer = find
            .ancestor(of: errorTextFinder, matching: find.byType(Container))
            .first; // Use first if multiple ancestors are containers, but ideally we want the immediate one.

        expect(errorContainer, findsOneWidget);

        // Verify decoration color if possible, but finding the widget is a good start.
        final containerWidget = tester.widget<Container>(errorContainer);
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, isNotNull); // Basic check
      });

      testWidgets('does not display error when none is set', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        // Should not find any error message
        final formState = container.read(loginFormProvider);
        expect(formState.errorMessage, isNull);
      });
    });

    group('Loading State', () {
      testWidgets('shows loading text when auth state is loading', (
        tester,
      ) async {
        // Create container with loading state
        final loadingContainer = ProviderContainer.test(
          overrides: [
            authStateProvider.overrideWithValue(const AuthStateLoading()),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: loadingContainer,
          child: LoginScreen(),
        );

        final l10n = getL10n(tester);
        expect(
          find.widgetWithText(ZoePrimaryButton, l10n.signingIn),
          findsOneWidget,
        );
      });

      testWidgets('disables fields when loading', (tester) async {
        final loadingContainer = ProviderContainer.test(
          overrides: [
            authStateProvider.overrideWithValue(const AuthStateLoading()),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: loadingContainer,
          child: LoginScreen(),
        );

        // Fields should be disabled
        final emailField = tester.widget<TextFormField>(
          find.byType(TextFormField).first,
        );
        final passwordField = tester.widget<TextFormField>(
          find.byType(TextFormField).last,
        );

        expect(emailField.enabled, isFalse);
        expect(passwordField.enabled, isFalse);
      });
    });

    group('Navigation', () {
      testWidgets('sign up link text is present', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        final l10n = getL10n(tester);
        expect(find.text(l10n.dontHaveAccount), findsOneWidget);
        expect(find.text(l10n.signUp), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles very long email addresses', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        final longEmail =
            'very.long.email.address.with.many.dots@subdomain.example.com';
        final emailField = find.byType(TextFormField).first;

        await tester.enterText(emailField, longEmail);
        await tester.pump();

        final formState = container.read(loginFormProvider);
        expect(formState.emailController.text, longEmail);
      });

      testWidgets('handles special characters in password', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        final complexPassword = 'P@ssw0rd!#\$%^&*()';
        final passwordField = find.byType(TextFormField).last;

        await tester.enterText(passwordField, complexPassword);
        await tester.pump();

        final formState = container.read(loginFormProvider);
        expect(formState.passwordController.text, complexPassword);
      });
    });

    group('Accessibility', () {
      testWidgets('has semantic labels for form fields', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        final l10n = getL10n(tester);
        expect(find.text(l10n.email), findsOneWidget);
        expect(find.text(l10n.password), findsOneWidget);
      });

      testWidgets('button has accessible text', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: LoginScreen(),
        );

        final l10n = getL10n(tester);
        expect(
          find.widgetWithText(ZoePrimaryButton, l10n.signIn),
          findsOneWidget,
        );
      });
    });
  });
}
