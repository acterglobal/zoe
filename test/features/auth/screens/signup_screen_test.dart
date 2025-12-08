import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/auth/models/auth_user_model.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/auth/providers/sign_up_providers.dart';
import 'package:zoe/features/auth/screens/signup_screen.dart';
import 'package:zoe/features/auth/services/auth_service.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/auth_utils.dart';

void main() {
  group('SignupScreen Widget Tests', () {
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
      return WidgetTesterExtension.getL10n(tester, byType: SignupScreen);
    }

    group('UI Components', () {
      testWidgets('displays all required UI elements', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);

        // Check for title
        expect(find.text(l10n.createAccount), findsOneWidget);

        // Check for all form fields (name, email, password, confirm password)
        expect(find.byType(TextFormField), findsNWidgets(4));

        // Check for sign up button
        expect(
          find.widgetWithText(ZoePrimaryButton, l10n.signUp),
          findsOneWidget,
        );

        // Check for sign in link
        expect(find.text(l10n.alreadyHaveAccount), findsOneWidget);
        expect(find.text(l10n.signIn), findsOneWidget);
      });

      testWidgets('displays all field labels', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);

        expect(find.text(l10n.name), findsOneWidget);
        expect(find.text(l10n.email), findsOneWidget);
        expect(find.text(l10n.password), findsOneWidget);
        expect(find.text(l10n.confirmPassword), findsOneWidget);
      });

      testWidgets('password fields are obscured by default', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final formState = container.read(signupFormProvider);
        expect(formState.obscurePassword, isTrue);
        expect(formState.obscureConfirmPassword, isTrue);
      });

      testWidgets('displays back button in app bar', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      });
    });

    group('User Interactions', () {
      testWidgets('toggles password visibility when icon is tapped', (
        tester,
      ) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        // Initially obscured
        expect(container.read(signupFormProvider).obscurePassword, isTrue);

        // Find and tap the first visibility toggle icon (password field)
        final visibilityIcons = find.byIcon(Icons.visibility);
        expect(visibilityIcons, findsNWidgets(2));
        await tester.tap(visibilityIcons.first);
        await tester.pump();

        // Should now be visible
        expect(container.read(signupFormProvider).obscurePassword, isFalse);
      });

      testWidgets('toggles confirm password visibility independently', (
        tester,
      ) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        // Initially both obscured
        expect(container.read(signupFormProvider).obscurePassword, isTrue);
        expect(
          container.read(signupFormProvider).obscureConfirmPassword,
          isTrue,
        );

        // Tap confirm password visibility toggle
        final visibilityIcons = find.byIcon(Icons.visibility);
        await tester.tap(visibilityIcons.last);
        await tester.pump();

        // Only confirm password should be visible
        expect(container.read(signupFormProvider).obscurePassword, isTrue);
        expect(
          container.read(signupFormProvider).obscureConfirmPassword,
          isFalse,
        );
      });

      testWidgets('allows text input in all fields', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final fields = find.byType(TextFormField);

        await tester.enterText(fields.at(0), 'John Doe');
        await tester.enterText(fields.at(1), 'test@example.com');
        await tester.enterText(fields.at(2), 'password123');
        await tester.enterText(fields.at(3), 'password123');
        await tester.pump();

        final formState = container.read(signupFormProvider);
        expect(formState.nameController.text, 'John Doe');
        expect(formState.emailController.text, 'test@example.com');
        expect(formState.passwordController.text, 'password123');
        expect(formState.confirmPasswordController.text, 'password123');
      });

      testWidgets('sign up button is tappable', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);
        final signUpButton = find.widgetWithText(ZoePrimaryButton, l10n.signUp);
        expect(signUpButton, findsOneWidget);

        await tester.tap(signUpButton);
        await tester.pump();
      });
    });

    group('Form Validation', () {
      testWidgets('shows error for empty name', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);

        // Trigger validation without entering name
        await tester.tap(find.widgetWithText(ZoePrimaryButton, l10n.signUp));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text(l10n.pleaseEnterAValidName), findsOneWidget);
      });

      testWidgets('shows error for invalid email', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);

        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), 'John Doe');
        await tester.enterText(fields.at(1), 'invalid-email');
        await tester.pump();

        await tester.tap(find.widgetWithText(ZoePrimaryButton, l10n.signUp));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text(l10n.pleaseEnterAValidEmail), findsOneWidget);
      });

      testWidgets('shows error for short password', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);

        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), 'John Doe');
        await tester.enterText(fields.at(1), 'test@example.com');
        await tester.enterText(fields.at(2), '123');
        await tester.pump();

        await tester.tap(find.widgetWithText(ZoePrimaryButton, l10n.signUp));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          find.text(l10n.passwordMustBeAtLeast6Characters),
          findsOneWidget,
        );
      });

      testWidgets('shows error when passwords do not match', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);

        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), 'John Doe');
        await tester.enterText(fields.at(1), 'test@example.com');
        await tester.enterText(fields.at(2), 'password123');
        await tester.enterText(fields.at(3), 'password456');
        await tester.pump();

        await tester.tap(find.widgetWithText(ZoePrimaryButton, l10n.signUp));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text(l10n.passwordsDoNotMatch), findsOneWidget);
      });

      testWidgets('accepts valid form data', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);

        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), 'John Doe');
        await tester.enterText(fields.at(1), 'test@example.com');
        await tester.enterText(fields.at(2), 'password123');
        await tester.enterText(fields.at(3), 'password123');
        await tester.pump();

        await tester.tap(find.widgetWithText(ZoePrimaryButton, l10n.signUp));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Should not show validation errors
        expect(find.text(l10n.pleaseEnterAValidName), findsNothing);
        expect(find.text(l10n.pleaseEnterAValidEmail), findsNothing);
        expect(find.text(l10n.passwordMustBeAtLeast6Characters), findsNothing);
        expect(find.text(l10n.passwordsDoNotMatch), findsNothing);
      });
    });

    group('Error Display', () {
      testWidgets('displays error message when set in provider', (
        tester,
      ) async {
        container
            .read(signupFormProvider.notifier)
            .setError('Email already in use');

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        expect(find.text('Email already in use'), findsOneWidget);
      });

      testWidgets('error message has error styling', (tester) async {
        container.read(signupFormProvider.notifier).setError('Test error');

        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final errorContainerFinder = find.ancestor(
          of: find.text('Test error'),
          matching: find.byWidgetPredicate(
            (widget) => widget is Container && widget.decoration != null,
          ),
        );

        expect(errorContainerFinder, findsOneWidget);

        final containerWidget = tester.widget<Container>(errorContainerFinder);
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.color, isNotNull);
        expect(decoration.borderRadius, isNotNull);
      });

      testWidgets('does not display error when none is set', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final formState = container.read(signupFormProvider);
        expect(formState.errorMessage, isNull);
      });
    });

    group('Loading State', () {
      testWidgets('shows loading text when auth state is loading', (
        tester,
      ) async {
        final loadingContainer = ProviderContainer(
          overrides: [
            authStateProvider.overrideWithValue(const AuthStateLoading()),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: loadingContainer,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);
        expect(find.text(l10n.creatingAccount), findsOneWidget);

        loadingContainer.dispose();
      });

      testWidgets('disables fields when loading', (tester) async {
        final loadingContainer = ProviderContainer(
          overrides: [
            authStateProvider.overrideWithValue(const AuthStateLoading()),
          ],
        );

        await tester.pumpMaterialWidgetWithProviderScope(
          container: loadingContainer,
          child: SignupScreen(),
        );

        final fields = find.byType(TextFormField);
        for (int i = 0; i < 4; i++) {
          final field = tester.widget<TextFormField>(fields.at(i));
          expect(field.enabled, isFalse);
        }

        loadingContainer.dispose();
      });
    });

    group('Navigation', () {
      testWidgets('sign in link text is present', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);
        expect(find.text(l10n.alreadyHaveAccount), findsOneWidget);
        expect(find.text(l10n.signIn), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles names with special characters', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final nameField = find.byType(TextFormField).first;
        await tester.enterText(nameField, 'José María O\'Brien');
        await tester.pump();

        final formState = container.read(signupFormProvider);
        expect(formState.nameController.text, 'José María O\'Brien');
      });

      testWidgets('handles very long names', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final longName = 'Christopher Alexander Montgomery Wellington III';
        final nameField = find.byType(TextFormField).first;

        await tester.enterText(nameField, longName);
        await tester.pump();

        final formState = container.read(signupFormProvider);
        expect(formState.nameController.text, longName);
      });

      testWidgets('handles complex passwords', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final complexPassword = 'P@ssw0rd!#\$%^&*()';
        final fields = find.byType(TextFormField);

        await tester.enterText(fields.at(2), complexPassword);
        await tester.enterText(fields.at(3), complexPassword);
        await tester.pump();

        final formState = container.read(signupFormProvider);
        expect(formState.passwordController.text, complexPassword);
        expect(formState.confirmPasswordController.text, complexPassword);
      });

      testWidgets('validates password match in real-time', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);

        final fields = find.byType(TextFormField);

        // Enter password
        await tester.enterText(fields.at(2), 'password123');
        await tester.pump();

        // Enter different confirm password
        await tester.enterText(fields.at(3), 'password456');
        await tester.pump();

        // Trigger validation
        await tester.tap(find.widgetWithText(ZoePrimaryButton, l10n.signUp));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text(l10n.passwordsDoNotMatch), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('has semantic labels for all form fields', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);

        expect(find.text(l10n.name), findsOneWidget);
        expect(find.text(l10n.email), findsOneWidget);
        expect(find.text(l10n.password), findsOneWidget);
        expect(find.text(l10n.confirmPassword), findsOneWidget);
      });

      testWidgets('button has accessible text', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final l10n = getL10n(tester);
        expect(
          find.widgetWithText(ZoePrimaryButton, l10n.signUp),
          findsOneWidget,
        );
      });

      testWidgets('visibility toggle icons are accessible', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        // Should have visibility icons for both password fields
        expect(find.byIcon(Icons.visibility), findsNWidgets(2));
      });
    });

    group('Field Order', () {
      testWidgets('fields are in correct order', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          container: container,
          child: SignupScreen(),
        );

        final fields = find.byType(TextFormField);
        expect(fields, findsNWidgets(4));

        // Verify order by entering text and checking controllers
        await tester.enterText(fields.at(0), 'name');
        await tester.enterText(fields.at(1), 'email');
        await tester.enterText(fields.at(2), 'pass');
        await tester.enterText(fields.at(3), 'confirm');
        await tester.pump();

        final formState = container.read(signupFormProvider);
        expect(formState.nameController.text, 'name');
        expect(formState.emailController.text, 'email');
        expect(formState.passwordController.text, 'pass');
        expect(formState.confirmPasswordController.text, 'confirm');
      });
    });
  });
}
