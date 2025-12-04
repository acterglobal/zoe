import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/utils/validation_utils.dart';
import 'package:zoe/common/widgets/animated_background_widget.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/auth/actions/sign_up_actions.dart';
import 'package:zoe/features/auth/models/sign_up_form_state_model.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/auth/providers/sign_up_providers.dart';
import 'package:zoe/features/auth/models/auth_state_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';

import '../../../common/widgets/toolkit/zoe_app_bar_widget.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final formState = ref.watch(signupFormProvider);
    final isLoading = authState is AuthStateLoading;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ZoeAppBar(
          title: L10n.of(context).signUp,
          showBackButton: true,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: AnimatedBackgroundWidget(
        child: SafeArea(
          child: Center(
            child: MaxWidthWidget(
              isScrollable: true,
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTitle(context),
                    const SizedBox(height: 32),
                    _buildNameField(context, ref, isLoading, formState),
                    const SizedBox(height: 16),
                    _buildEmailField(context, ref, isLoading, formState),
                    const SizedBox(height: 16),
                    _buildPasswordField(context, ref, isLoading, formState),
                    const SizedBox(height: 16),
                    _buildConfirmPasswordField(
                      context,
                      ref,
                      isLoading,
                      formState,
                    ),
                    const SizedBox(height: 8),
                    if (formState.errorMessage != null) ...[
                      const SizedBox(height: 8),
                      _buildErrorMessage(context, formState.errorMessage!),
                    ],
                    const SizedBox(height: 24),
                    _buildSignUpButton(context, ref, isLoading),
                    const SizedBox(height: 16),
                    _buildSignInLink(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      L10n.of(context).createAccount,
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildNameField(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
    SignupFormStateModel formState,
  ) {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: formState.nameController,
      labelText: l10n.name,
      hintText: l10n.nameDescription,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (value) => ValidationUtils.validateName(context, value),
      enabled: !isLoading,
    );
  }

  Widget _buildEmailField(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
    SignupFormStateModel formState,
  ) {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: formState.emailController,
      labelText: l10n.email,
      hintText: l10n.emailDescription,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) => ValidationUtils.validateEmail(context, value),
      enabled: !isLoading,
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
    SignupFormStateModel formState,
  ) {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: formState.passwordController,
      labelText: l10n.password,
      hintText: l10n.passwordDescription,
      obscureText: formState.obscurePassword,
      textInputAction: TextInputAction.next,
      validator: (value) => ValidationUtils.validatePassword(context, value),
      enabled: !isLoading,
      suffixIcon: IconButton(
        icon: Icon(
          formState.obscurePassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          ref.read(signupFormProvider.notifier).toggleObscurePassword();
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
    SignupFormStateModel formState,
  ) {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: formState.confirmPasswordController,
      labelText: l10n.confirmPassword,
      hintText: l10n.confirmPasswordDescription,
      obscureText: formState.obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      validator: (value) => ValidationUtils.validateConfirmPassword(
        context,
        value,
        formState.passwordController.text,
      ),
      enabled: !isLoading,
      suffixIcon: IconButton(
        icon: Icon(
          formState.obscureConfirmPassword
              ? Icons.visibility
              : Icons.visibility_off,
        ),
        onPressed: () {
          ref.read(signupFormProvider.notifier).toggleObscureConfirmPassword();
        },
      ),
      onSubmitted: () => handleSignUp(ref, context, _formKey),
    );
  }

  Widget _buildErrorMessage(BuildContext context, String errorMessage) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        errorMessage,
        style: TextStyle(color: theme.colorScheme.onErrorContainer),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSignUpButton(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
  ) {
    final l10n = L10n.of(context);
    return SizedBox(
      width: double.infinity,
      child: ZoePrimaryButton(
        text: isLoading ? l10n.creatingAccount : l10n.signUp,
        onPressed: isLoading
            ? () {}
            : () => handleSignUp(ref, context, _formKey),
      ),
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.alreadyHaveAccount, style: theme.textTheme.bodyMedium),
        TextButton(
          onPressed: () => context.push(AppRoutes.login.route),
          child: Text(
            l10n.signIn,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
