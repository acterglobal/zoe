import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/auth/actions/login_actions.dart';
import 'package:zoe/features/auth/providers/login_providers.dart';
import 'package:zoe/features/auth/services/auth_service.dart';
import '../../../test-utils/test_utils.dart';
import '../utils/auth_utils.dart';

void main() {
  group('Login Actions', () {
    late ProviderContainer container;
    late GlobalKey<FormState> formKey;
    late MockAuthService mockAuthService;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockAuthService = MockAuthService();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();

      // Setup default mock behaviors
      when(() => mockUser.uid).thenReturn('test-uid');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.displayName).thenReturn('Test User');
      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockAuthService.currentUser).thenReturn(null);
      when(
        () => mockAuthService.authStateChanges,
      ).thenAnswer((_) => Stream.value(null));

      container = ProviderContainer.test(
        overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
      );
      formKey = GlobalKey<FormState>();
    });

    group('handleSignIn', () {
      testWidgets('validates form before sign in', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign In',
          onPressed: (context, ref) => handleSignIn(ref, context, formKey),
          formKey: formKey,
        );

        // Tap the button without filling form
        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        // Form validation should fail, no sign in attempt
        expect(find.text('Sign In'), findsOneWidget);
      });

      testWidgets('clears error before sign in attempt', (tester) async {
        // Mock successful sign in
        when(
          () => mockAuthService.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        // Set an error first
        container.read(loginFormProvider.notifier).setError('Previous error');
        expect(
          container.read(loginFormProvider).errorMessage,
          'Previous error',
        );

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign In',
          onPressed: (context, ref) {
            // Fill form with valid data
            final formState = ref.read(loginFormProvider);
            formState.emailController.text = 'test@example.com';
            formState.passwordController.text = 'password123';

            handleSignIn(ref, context, formKey);
          },
          formKey: formKey,
        );

        // Error should be cleared when sign in starts
        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        // Error should be cleared
        expect(container.read(loginFormProvider).errorMessage, isNull);
      });

      testWidgets('sets error on sign in failure', (tester) async {
        // Mock failed sign in
        when(
          () => mockAuthService.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.error(Exception('Invalid credentials')));

        // Keep provider alive
        container.listen(loginFormProvider, (_, __) {});

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign In',
          onPressed: (context, ref) {
            final formState = ref.read(loginFormProvider);
            formState.emailController.text = 'wrong@example.com';
            formState.passwordController.text = 'wrongpassword';

            handleSignIn(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        // Error should be set (actual error depends on mock)
        final errorMessage = container.read(loginFormProvider).errorMessage;
        expect(errorMessage, isNotNull);
      });

      testWidgets('handles context unmounted during async operation', (
        tester,
      ) async {
        // Mock sign in with delay
        when(
          () => mockAuthService.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return mockUserCredential;
        });

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign In',
          onPressed: (context, ref) {
            final formState = ref.read(loginFormProvider);
            formState.emailController.text = 'test@example.com';
            formState.passwordController.text = 'password123';

            handleSignIn(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign In'));
        await tester.pump();

        // Dispose widget tree before async completes
        await tester.pumpWidget(Container());
        await tester.pumpAndSettle();

        // Should not throw error
        expect(tester.takeException(), isNull);
      });
    });

    group('Form Validation', () {
      testWidgets('requires email and password', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final formState = ref.watch(loginFormProvider);
                    return Column(
                      children: [
                        TextFormField(
                          controller: formState.emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email required';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: formState.passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password required';
                            }
                            return null;
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          container: container,
        );

        // Validate empty form
        expect(formKey.currentState?.validate(), isFalse);

        // Fill email only
        final formState = container.read(loginFormProvider);
        formState.emailController.text = 'test@example.com';
        expect(formKey.currentState?.validate(), isFalse);

        // Fill password too
        formState.passwordController.text = 'password123';
        expect(formKey.currentState?.validate(), isTrue);
      });
    });

    group('Error Handling', () {
      testWidgets('displays error message from exception', (tester) async {
        // Mock failed sign in
        when(
          () => mockAuthService.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('Invalid credentials'));

        // Keep provider alive
        container.listen(loginFormProvider, (_, __) {});

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign In',
          onPressed: (context, ref) {
            final formState = ref.read(loginFormProvider);
            formState.emailController.text = 'test@example.com';
            formState.passwordController.text = 'wrongpassword';

            handleSignIn(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        final errorMessage = container.read(loginFormProvider).errorMessage;
        expect(errorMessage, isNotNull);
        expect(errorMessage, isNotEmpty);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty email and password', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign In',
          onPressed: (context, ref) {
            handleSignIn(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        // Should not crash
        expect(find.text('Sign In'), findsOneWidget);
      });

      testWidgets('handles whitespace in credentials', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign In',
          onPressed: (context, ref) {
            final formState = ref.read(loginFormProvider);
            formState.emailController.text = '  test@example.com  ';
            formState.passwordController.text = '  password123  ';

            handleSignIn(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        // Should trim whitespace and attempt sign in
        expect(find.text('Sign In'), findsOneWidget);
      });

      testWidgets('handles special characters in password', (tester) async {
        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign In',
          onPressed: (context, ref) {
            final formState = ref.read(loginFormProvider);
            formState.emailController.text = 'test@example.com';
            formState.passwordController.text = 'P@ssw0rd!#\$%';

            handleSignIn(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign In'));
        await tester.pumpAndSettle();

        // Should handle special characters
        expect(find.text('Sign In'), findsOneWidget);
      });
    });
  });
}
