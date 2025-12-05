import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoe/features/auth/providers/login_providers.dart';

void main() {
  group('Login Providers', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test(); 
    });

    group('LoginForm Provider', () {
      test('initializes with empty controllers', () {
        final formState = container.read(loginFormProvider);

        expect(formState.emailController.text, isEmpty);
        expect(formState.passwordController.text, isEmpty);
      });

      test('initializes with password obscured', () {
        final formState = container.read(loginFormProvider);

        expect(formState.obscurePassword, isTrue);
      });

      test('initializes with no error message', () {
        final formState = container.read(loginFormProvider);

        expect(formState.errorMessage, isNull);
      });

      test('toggles obscure password', () {
        final notifier = container.read(loginFormProvider.notifier);

        // Initial state
        expect(container.read(loginFormProvider).obscurePassword, isTrue);

        // Toggle to visible
        notifier.toggleObscurePassword();
        expect(container.read(loginFormProvider).obscurePassword, isFalse);

        // Toggle back to obscured
        notifier.toggleObscurePassword();  
        expect(container.read(loginFormProvider).obscurePassword, isTrue);
      });

      test('sets error message', () {
        final notifier = container.read(loginFormProvider.notifier);

        notifier.setError('Invalid credentials');

        expect(
          container.read(loginFormProvider).errorMessage,
          'Invalid credentials',
        );
      });

      test('clears error message', () {
        final notifier = container.read(loginFormProvider.notifier);

        // Set error
        notifier.setError('Invalid credentials');
        expect(
          container.read(loginFormProvider).errorMessage,
          'Invalid credentials',
        );

        // Clear error
        notifier.clearError();
        expect(container.read(loginFormProvider).errorMessage, isNull);
      });

      test('controllers persist text changes', () {
        final formState = container.read(loginFormProvider);

        formState.emailController.text = 'test@example.com';
        formState.passwordController.text = 'password123';

        expect(formState.emailController.text, 'test@example.com');
        expect(formState.passwordController.text, 'password123');
      }); 
    });

    group('State Management', () { 
      test('error message updates trigger state changes', () {
        final notifier = container.read(loginFormProvider.notifier);

        var callCount = 0;
        container.listen(loginFormProvider, (previous, next) {
          callCount++;
        });

        notifier.setError('Error 1');
        notifier.setError('Error 2');
        notifier.clearError();

        expect(callCount, 3);
      });

      test('obscure password toggle triggers state changes', () {
        final notifier = container.read(loginFormProvider.notifier);

        var callCount = 0;
        container.listen(loginFormProvider, (previous, next) {
          callCount++;
        });

        notifier.toggleObscurePassword();
        notifier.toggleObscurePassword();

        expect(callCount, 2);
      });
    });

    group('Edge Cases', () {
      test('handles multiple error messages', () {
        final notifier = container.read(loginFormProvider.notifier);

        notifier.setError('Error 1');
        expect(container.read(loginFormProvider).errorMessage, 'Error 1');

        notifier.setError('Error 2');
        expect(container.read(loginFormProvider).errorMessage, 'Error 2');
      });

      test('handles empty error message', () {
        final notifier = container.read(loginFormProvider.notifier);

        notifier.setError('');
        expect(container.read(loginFormProvider).errorMessage, '');
      });

      test('handles special characters in error message', () {
        final notifier = container.read(loginFormProvider.notifier);

        notifier.setError('Error: <special> & "characters"');
        expect(
          container.read(loginFormProvider).errorMessage,
          'Error: <special> & "characters"',
        );
      });

      test('handles long email addresses', () {
        final formState = container.read(loginFormProvider);

        final longEmail =
            'very.long.email.address.with.many.dots@subdomain.example.com';
        formState.emailController.text = longEmail;

        expect(formState.emailController.text, longEmail);
      });

      test('handles special characters in password', () {
        final formState = container.read(loginFormProvider);

        final complexPassword = 'P@ssw0rd!#\$%^&*()_+-=[]{}|;:,.<>?';
        formState.passwordController.text = complexPassword;

        expect(formState.passwordController.text, complexPassword);
      });
    });
  });
}
