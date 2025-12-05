import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/auth/providers/sign_up_providers.dart';

void main() {
  group('Signup Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
    });

    group('SignupForm Provider', () {
      test('initializes with empty controllers', () {
        final formState = container.read(signupFormProvider);

        expect(formState.nameController.text, isEmpty);
        expect(formState.emailController.text, isEmpty);
        expect(formState.passwordController.text, isEmpty);
        expect(formState.confirmPasswordController.text, isEmpty);
      });

      test('initializes with passwords obscured', () {
        final formState = container.read(signupFormProvider);

        expect(formState.obscurePassword, isTrue);
        expect(formState.obscureConfirmPassword, isTrue);
      });

      test('initializes with no error message', () {
        final formState = container.read(signupFormProvider);

        expect(formState.errorMessage, isNull);
      });

      test('toggles obscure password', () {
        final notifier = container.read(signupFormProvider.notifier);

        // Initial state
        expect(container.read(signupFormProvider).obscurePassword, isTrue);

        // Toggle to visible
        notifier.toggleObscurePassword();
        expect(container.read(signupFormProvider).obscurePassword, isFalse);

        // Toggle back to obscured
        notifier.toggleObscurePassword();
        expect(container.read(signupFormProvider).obscurePassword, isTrue);
      });

      test('toggles obscure confirm password', () {
        final notifier = container.read(signupFormProvider.notifier);

        // Initial state
        expect(
          container.read(signupFormProvider).obscureConfirmPassword,
          isTrue,
        );

        // Toggle to visible
        notifier.toggleObscureConfirmPassword();
        expect(
          container.read(signupFormProvider).obscureConfirmPassword,
          isFalse,
        );

        // Toggle back to obscured
        notifier.toggleObscureConfirmPassword();
        expect(
          container.read(signupFormProvider).obscureConfirmPassword,
          isTrue,
        );
      });

      test('toggles password and confirm password independently', () {
        final notifier = container.read(signupFormProvider.notifier);

        notifier.toggleObscurePassword();
        expect(container.read(signupFormProvider).obscurePassword, isFalse);
        expect(
          container.read(signupFormProvider).obscureConfirmPassword,
          isTrue,
        );

        notifier.toggleObscureConfirmPassword();
        expect(container.read(signupFormProvider).obscurePassword, isFalse);
        expect(
          container.read(signupFormProvider).obscureConfirmPassword,
          isFalse,
        );
      });

      test('sets error message', () {
        final notifier = container.read(signupFormProvider.notifier);

        notifier.setError('Email already in use');

        expect(
          container.read(signupFormProvider).errorMessage,
          'Email already in use',
        );
      });

      test('clears error message', () {
        final notifier = container.read(signupFormProvider.notifier);

        // Set error
        notifier.setError('Email already in use');
        expect(
          container.read(signupFormProvider).errorMessage,
          'Email already in use',
        );

        // Clear error
        notifier.clearError();
        expect(container.read(signupFormProvider).errorMessage, isNull);
      });

      test('controllers persist text changes', () {
        final formState = container.read(signupFormProvider);

        formState.nameController.text = 'John Doe';
        formState.emailController.text = 'test@example.com';
        formState.passwordController.text = 'password123';
        formState.confirmPasswordController.text = 'password123';

        expect(formState.nameController.text, 'John Doe');
        expect(formState.emailController.text, 'test@example.com');
        expect(formState.passwordController.text, 'password123');
        expect(formState.confirmPasswordController.text, 'password123');
      }); 
    });

    group('State Management', () { 

      test('error message updates trigger state changes', () {
        final notifier = container.read(signupFormProvider.notifier);

        var callCount = 0;
        container.listen(signupFormProvider, (previous, next) {
          callCount++;
        });

        notifier.setError('Error 1');
        notifier.setError('Error 2');
        notifier.clearError();

        expect(callCount, 3);
      });

      test('obscure password toggles trigger state changes', () {
        final notifier = container.read(signupFormProvider.notifier);

        var callCount = 0;
        container.listen(signupFormProvider, (previous, next) {
          callCount++;
        });

        notifier.toggleObscurePassword();
        notifier.toggleObscureConfirmPassword();
        notifier.toggleObscurePassword();

        expect(callCount, 3);
      });
    });

    group('Edge Cases', () {
      test('handles multiple error messages', () {
        final notifier = container.read(signupFormProvider.notifier);

        notifier.setError('Error 1');
        expect(container.read(signupFormProvider).errorMessage, 'Error 1');

        notifier.setError('Error 2');
        expect(container.read(signupFormProvider).errorMessage, 'Error 2');
      });

      test('handles empty error message', () {
        final notifier = container.read(signupFormProvider.notifier);

        notifier.setError('');
        expect(container.read(signupFormProvider).errorMessage, '');
      });

      test('handles special characters in name', () {
        final formState = container.read(signupFormProvider);

        formState.nameController.text = 'José María O\'Brien';
        expect(formState.nameController.text, 'José María O\'Brien');
      });

      test('handles long names', () {
        final formState = container.read(signupFormProvider);

        final longName = 'Christopher Alexander Montgomery Wellington III';
        formState.nameController.text = longName;

        expect(formState.nameController.text, longName);
      });
 
      test('handles mismatched passwords', () {
        final formState = container.read(signupFormProvider);

        formState.passwordController.text = 'password123';
        formState.confirmPasswordController.text = 'password456';

        expect(formState.passwordController.text, 'password123');
        expect(formState.confirmPasswordController.text, 'password456');
        expect(
          formState.passwordController.text,
          isNot(formState.confirmPasswordController.text),
        );
      });
    });
  });
}
