// Signup form state provider
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/sign_up_form_state_model.dart';

part 'sign_up_providers.g.dart';

@riverpod
class SignupForm extends _$SignupForm {
  @override
  SignupFormStateModel build() {
    // Create controllers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final nameController = TextEditingController();

    // Dispose controllers when provider is destroyed
    ref.onDispose(() {
      emailController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
      nameController.dispose();
    });

    return SignupFormStateModel(
      emailController: emailController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      nameController: nameController,
    );
  }

  /// Toggle password visibility
  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// Toggle confirm password visibility
  void toggleObscureConfirmPassword() {
    state = state.copyWith(
      obscureConfirmPassword: !state.obscureConfirmPassword,
    );
  }

  /// Set error message
  void setError(String message) {
    state = state.copyWith(errorMessage: message);
  }

  /// Clear error message
  void clearError() {
    state = state.clearError();
  }

  /// Clear all form fields
  void clear() {
    state.emailController.clear();
    state.passwordController.clear();
    state.confirmPasswordController.clear();
    state = state.clearError();
  }
}
