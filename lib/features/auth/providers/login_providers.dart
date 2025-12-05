import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/login_form_state_model.dart';

part 'login_providers.g.dart';

/// Login form state provider
@Riverpod(keepAlive: true)
class LoginForm extends _$LoginForm {
  @override
  LoginFormStateModel build() {
    // Create controllers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // Dispose controllers when provider is disposed
    ref.onDispose(() {
      emailController.dispose();
      passwordController.dispose();
    });

    return LoginFormStateModel(
      emailController: emailController,
      passwordController: passwordController,
    );
  }

  /// Toggle password visibility
  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// Set error message
  void setError(String error) {
    state = state.copyWith(errorMessage: error);
  }

  /// Clear error message
  void clearError() {
    state = state.clearError();
  }

  /// Clear all form fields
  void clear() {
    state.emailController.clear();
    state.passwordController.clear();
    state = state.clearError();
  }
}
