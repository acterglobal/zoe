import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';

/// Handles the sign up action
Future<void> handleSignUp({
  required WidgetRef ref,
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController nameController,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController confirmPasswordController,
  required Function(String?) setErrorMessage,
}) async {
  // Validate form first
  if (formKey.currentState?.validate() == false) {
    return;
  }

  // Clear any previous errors
  setErrorMessage(null);

  try {
    await ref
        .read(authStateProvider.notifier)
        .signUp(
          email: emailController.text.trim(),
          password: passwordController.text,
          name: nameController.text.trim(),
        );
    if (!context.mounted) return;
    context.go(AppRoutes.home.route);
  } catch (e) {
    if (!context.mounted) return;
    setErrorMessage(e.toString().replaceAll('Exception: ', ''));
  }
}
