import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/auth/providers/sign_up_providers.dart';

/// Handles the sign up action
Future<void> handleSignUp(
  WidgetRef ref,
  BuildContext context,
  GlobalKey<FormState> formKey,
) async {
  // Validate form first
  final currentState = formKey.currentState;
  if (currentState == null || !currentState.validate()) {
    return;
  }

  final formState = ref.read(signupFormProvider);

  // Clear any previous errors
  ref.read(signupFormProvider.notifier).clearError();

  try {
    await ref
        .read(authStateProvider.notifier)
        .signUp(
          email: formState.emailController.text.trim(),
          password: formState.passwordController.text,
          name: formState.nameController.text.trim(),
        );
    
    // Navigate to home screen after successful signup
    if (context.mounted) {
      context.go(AppRoutes.home.route);
    }
  } catch (e) {
    if (!context.mounted) return;
    ref
        .read(signupFormProvider.notifier)
        .setError(e.toString().replaceAll('Exception: ', ''));
  }
}
