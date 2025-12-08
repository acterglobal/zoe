import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zoe/common/utils/validation_utils.dart';
import 'package:zoe/common/widgets/animated_background_widget.dart';
import 'package:zoe/common/widgets/animated_textfield_widget.dart';
import 'package:zoe/common/widgets/max_width_widget.dart';
import 'package:zoe/common/widgets/toolkit/zoe_primary_button.dart';
import 'package:zoe/core/routing/app_routes.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../common/widgets/toolkit/zoe_app_bar_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    // Validate form first
    if (_formKey.currentState?.validate() == false) {
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    try {
      await ref
          .read(authStateProvider.notifier)
          .signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      if (!context.mounted) return;
      context.go(AppRoutes.home.route);
    } catch (e) {
      if (!context.mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;

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
                  _buildEmailField(context, isLoading),
                  const SizedBox(height: 16),
                  _buildPasswordField(context, isLoading),
                  const SizedBox(height: 8),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 8),
                    _buildErrorMessage(context, _errorMessage!),
                  ],
                  const SizedBox(height: 24),
                  _buildSignInButton(context, isLoading),
                  const SizedBox(height: 16),
                  _buildSignUpLink(context),
                ],
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

  Widget _buildEmailField(BuildContext context, bool isLoading) {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: _emailController,
      labelText: l10n.email,
      hintText: l10n.emailDescription,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) => ValidationUtils.validateEmail(context, value),
      enabled: !isLoading,
    );
  }

  Widget _buildPasswordField(BuildContext context, bool isLoading) {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: _passwordController,
      labelText: l10n.password,
      hintText: l10n.passwordDescription,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      validator: (value) => ValidationUtils.validatePassword(context, value),
      enabled: !isLoading,
      suffixIcon: IconButton(
        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
      onSubmitted: _handleSignIn,
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
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context, bool isLoading) {
    final l10n = L10n.of(context);
    return SizedBox(
      width: double.infinity,
      child: ZoePrimaryButton(
        text: isLoading ? l10n.signingIn : l10n.signIn,
        isLoading: isLoading,
        onPressed: _handleSignIn,
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
