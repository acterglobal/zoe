import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/auth/providers/login_providers.dart';

/// Handles the sign in action
Future<void> handleSignIn(
  WidgetRef ref,
  BuildContext context,
  GlobalKey<FormState> formKey,
) async {
  // Validate form first
  if (!formKey.currentState!.validate()) {
    return;
  }

  final formState = ref.read(loginFormProvider);

  // Clear any previous errors
  ref.read(loginFormProvider.notifier).clearError();

  try {
    await ref
        .read(authStateProvider.notifier)
        .signIn(
          email: formState.emailController.text.trim(),
          password: formState.passwordController.text,
        );
    
    // Navigate to home screen after successful login
    if (context.mounted) {
      context.go(AppRoutes.home.route);
    }
  } catch (e) {
    if (!context.mounted) return;
    ref
        .read(loginFormProvider.notifier)
        .setError(e.toString().replaceAll('Exception: ', ''));
  }
}
