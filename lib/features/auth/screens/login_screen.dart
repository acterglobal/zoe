import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/utils/validation_utils.dart';
import 'package:zoe/common/widgets/animated_background_widget.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/auth/actions/login_actions.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/auth/providers/login_providers.dart';
import 'package:zoe/features/auth/models/auth_state_model.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../common/widgets/toolkit/zoe_app_bar_widget.dart';
import '../models/login_form_state_model.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final formState = ref.watch(loginFormProvider);
    final isLoading = authState is AuthStateLoading;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ZoeAppBar(
          title: L10n.of(context).signIn,
          showBackButton: true,
          onBackPressed: () {
            context.push(AppRoutes.welcome.route);
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
                    _buildEmailField(context, ref, isLoading, formState),
                    const SizedBox(height: 16),
                    _buildPasswordField(ref, context, isLoading, formState),
                    const SizedBox(height: 8),
                    if (formState.errorMessage != null) ...[
                      const SizedBox(height: 8),
                      _buildErrorMessage(context, formState.errorMessage!),
                    ],
                    const SizedBox(height: 24),
                    _buildSignInButton(context, ref, isLoading),
                    const SizedBox(height: 16),
                    _buildSignUpLink(context),
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
      L10n.of(context).loginToYourAccount,
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildEmailField(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
    LoginFormStateModel formState,
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
    WidgetRef ref,
    BuildContext context,
    bool isLoading,
    LoginFormStateModel formState,
  ) {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: formState.passwordController,
      labelText: l10n.password,
      hintText: l10n.passwordDescription,
      obscureText: formState.obscurePassword,
      textInputAction: TextInputAction.done,
      validator: (value) => ValidationUtils.validatePassword(context, value),
      enabled: !isLoading,
      suffixIcon: IconButton(
        icon: Icon(
          formState.obscurePassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          ref.read(loginFormProvider.notifier).toggleObscurePassword();
        },
      ),
      onSubmitted: () => handleSignIn(ref, context, _formKey),
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

  Widget _buildSignInButton(
    BuildContext context,
    WidgetRef ref,
    bool isLoading,
  ) {
    final l10n = L10n.of(context);
    return SizedBox(
      width: double.infinity,
      child: ZoePrimaryButton(
        text: isLoading ? l10n.signingIn : l10n.signIn,
        isLoading: isLoading,
        onPressed: () => handleSignIn(ref, context, _formKey),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.dontHaveAccount, style: theme.textTheme.bodyMedium),
        TextButton(
          onPressed: () => context.push(AppRoutes.signup.route),
          child: Text(
            l10n.signUp,
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
