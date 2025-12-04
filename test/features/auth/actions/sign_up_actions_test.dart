import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/auth/actions/sign_up_actions.dart';
import 'package:zoe/features/auth/providers/sign_up_providers.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/auth/services/auth_service.dart';
import '../../../test-utils/test_utils.dart';
import '../providers/auth_providers_test.dart';
import '../utils/auth_utils.dart';

void main() {
  group('Signup Actions', () {
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

    Future<void> pumpSignupForm(
      WidgetTester tester, {
      required ProviderContainer container,
      required GlobalKey<FormState> formKey,
      required Function(BuildContext, WidgetRef) onPressed,
    }) async {
      await tester.pumpMaterialWidgetWithProviderScope(
        container: container,
        child: Form(
          key: formKey,
          child: Consumer(
            builder: (context, ref, _) {
              final formState = ref.watch(signupFormProvider);
              return Column(
                children: [
                  TextFormField(
                    controller: formState.nameController,
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: formState.emailController,
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: formState.passwordController,
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: formState.confirmPasswordController,
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  ElevatedButton(
                    onPressed: () => onPressed(context, ref),
                    child: const Text('Sign Up'),
                  ),
                ],
              );
            },
          ),
        ),
      );
    }

    group('handleSignUp', () {
      testWidgets('validates form before sign up', (tester) async {
        await pumpSignupForm(
          tester,
          container: container,
          formKey: formKey,
          onPressed: (context, ref) => handleSignUp(ref, context, formKey),
        );

        // Tap the button without filling form
        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        // Form validation should fail, no sign up attempt
        expect(find.text('Sign Up'), findsOneWidget);
        verifyNever(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        );
      });

      testWidgets('clears error before sign up attempt', (tester) async {
        // Mock successful sign up
        when(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        // Set an error first
        container.read(signupFormProvider.notifier).setError('Previous error');
        expect(
          container.read(signupFormProvider).errorMessage,
          'Previous error',
        );

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign Up',
          onPressed: (context, ref) {
            // Fill form with valid data
            final formState = ref.read(signupFormProvider);
            formState.nameController.text = 'John Doe';
            formState.emailController.text = 'test@example.com';
            formState.passwordController.text = 'password123';
            formState.confirmPasswordController.text = 'password123';

            handleSignUp(ref, context, formKey);
          },
          formKey: formKey,
        );

        // Error should be cleared when sign up starts
        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        // Error should be cleared
        expect(container.read(signupFormProvider).errorMessage, isNull);
      });

      testWidgets('sets error on sign up failure', (tester) async {
        // Mock failed sign up
        when(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer(
          (_) => Future.error(Exception('Email already in use')),
        );

        // Keep provider alive
        container.listen(signupFormProvider, (_, __) {});

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign Up',
          onPressed: (context, ref) {
            // Fill form with valid data
            final formState = ref.read(signupFormProvider);
            formState.nameController.text = 'John Doe';
            formState.emailController.text = 'existing@example.com';
            formState.passwordController.text = 'password123';
            formState.confirmPasswordController.text = 'password123';

            handleSignUp(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        // Error should be set (actual error depends on mock)
        final errorMessage = container.read(signupFormProvider).errorMessage;
        expect(errorMessage, isNotNull);
      });

      testWidgets('passes name to auth provider', (tester) async {
        // Mock successful sign up
        when(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign Up',
          onPressed: (context, ref) {
            final formState = ref.read(signupFormProvider);
            formState.nameController.text = 'John Doe';
            formState.emailController.text = 'test@example.com';
            formState.passwordController.text = 'password123';
            formState.confirmPasswordController.text = 'password123';

            handleSignUp(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        // Name should be passed to auth provider
        verify(
          () => mockAuthService.signUp(
            email: 'test@example.com',
            password: 'password123',
            displayName: 'John Doe',
          ),
        ).called(1);
      });
    });

    group('Form Validation', () {
      testWidgets('requires all fields', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final formState = ref.watch(signupFormProvider);
                    return Column(
                      children: [
                        TextFormField(
                          controller: formState.nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name required';
                            }
                            return null;
                          },
                        ),
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
                        TextFormField(
                          controller: formState.confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm password required';
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

        // Fill all fields
        final formState = container.read(signupFormProvider);
        formState.nameController.text = 'John Doe';
        formState.emailController.text = 'test@example.com';
        formState.passwordController.text = 'password123';
        formState.confirmPasswordController.text = 'password123';

        expect(formKey.currentState?.validate(), isTrue);
      });

      testWidgets('validates password match', (tester) async {
        await tester.pumpMaterialWidgetWithProviderScope(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final formState = ref.watch(signupFormProvider);
                    return Column(
                      children: [
                        TextFormField(controller: formState.passwordController),
                        TextFormField(
                          controller: formState.confirmPasswordController,
                          validator: (value) {
                            if (value != formState.passwordController.text) {
                              return 'Passwords do not match';
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

        final formState = container.read(signupFormProvider);

        // Mismatched passwords
        formState.passwordController.text = 'password123';
        formState.confirmPasswordController.text = 'password456';
        expect(formKey.currentState?.validate(), isFalse);

        // Matching passwords
        formState.confirmPasswordController.text = 'password123';
        expect(formKey.currentState?.validate(), isTrue);
      });
    });

    group('Error Handling', () {
      testWidgets('displays error message from exception', (tester) async {
        // Mock failed sign up
        when(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenThrow(Exception('Email already in use'));

        // Keep provider alive
        container.listen(signupFormProvider, (_, __) {});

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign Up',
          onPressed: (context, ref) {
            final formState = ref.read(signupFormProvider);
            formState.nameController.text = 'John Doe';
            formState.emailController.text = 'existing@example.com';
            formState.passwordController.text = 'password123';
            formState.confirmPasswordController.text = 'password123';

            handleSignUp(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        final errorMessage = container.read(signupFormProvider).errorMessage;
        expect(errorMessage, isNotNull);
        expect(errorMessage, isNotEmpty);
      });

      testWidgets('strips "Exception: " prefix from error', (tester) async {
        // Mock failed sign up
        when(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenThrow(Exception('Email already in use'));

        // Keep provider alive
        container.listen(signupFormProvider, (_, __) {});

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign Up',
          onPressed: (context, ref) {
            final formState = ref.read(signupFormProvider);
            formState.nameController.text = 'John Doe';
            formState.emailController.text = 'existing@example.com';
            formState.passwordController.text = 'password123';
            formState.confirmPasswordController.text = 'password123';

            handleSignUp(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        final errorMessage = container.read(signupFormProvider).errorMessage;
        if (errorMessage != null) {
          expect(errorMessage.startsWith('Exception: '), isFalse);
          expect(errorMessage, 'Email already in use');
        }
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty fields', (tester) async {
        await pumpSignupForm(
          tester,
          container: container,
          formKey: formKey,
          onPressed: (context, ref) => handleSignUp(ref, context, formKey),
        );

        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        // Should not crash and no sign up attempt
        expect(find.text('Sign Up'), findsOneWidget);
        verifyNever(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        );
      });

      testWidgets('trims whitespace from name', (tester) async {
        // Mock successful sign up
        when(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign Up',
          onPressed: (context, ref) {
            final formState = ref.read(signupFormProvider);
            formState.nameController.text = '  John Doe  ';
            formState.emailController.text = 'test@example.com';
            formState.passwordController.text = 'password123';
            formState.confirmPasswordController.text = 'password123';

            handleSignUp(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        // Should trim whitespace
        verify(
          () => mockAuthService.signUp(
            email: 'test@example.com',
            password: 'password123',
            displayName: 'John Doe',
          ),
        ).called(1);
      });

      testWidgets('handles special characters in name', (tester) async {
        // Mock successful sign up
        when(
          () => mockAuthService.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
          ),
        ).thenAnswer((_) async => mockUserCredential);

        await tester.pumpActionsWidget(
          container: container,
          buttonText: 'Sign Up',
          onPressed: (context, ref) {
            final formState = ref.read(signupFormProvider);
            formState.nameController.text = 'José María O\'Brien';
            formState.emailController.text = 'test@example.com';
            formState.passwordController.text = 'password123';
            formState.confirmPasswordController.text = 'password123';

            handleSignUp(ref, context, formKey);
          },
          formKey: formKey,
        );

        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        // Should handle special characters
        verify(
          () => mockAuthService.signUp(
            email: 'test@example.com',
            password: 'password123',
            displayName: 'José María O\'Brien',
          ),
        ).called(1);
      });
    });
  });
}
