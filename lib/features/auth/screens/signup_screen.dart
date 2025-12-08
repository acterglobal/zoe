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
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/l10n/generated/l10n.dart';
import '../../../common/widgets/toolkit/zoe_app_bar_widget.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    await handleSignUp(
      ref: ref,
      context: context,
      formKey: _formKey,
      nameController: _nameController,
      emailController: _emailController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      setErrorMessage: (error) {
        if (mounted) {
          setState(() {
            _errorMessage = error;
          });
        }
      },
    );
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
          title: L10n.of(context).signUp,
          showBackButton: true,
          onBackPressed: () {
            Navigator.pop(context);
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
                  _buildNameField(context, isLoading),
                  const SizedBox(height: 16),
                  _buildEmailField(context, isLoading),
                  const SizedBox(height: 16),
                  _buildPasswordField(context, isLoading),
                  const SizedBox(height: 16),
                  _buildConfirmPasswordField(context, isLoading),
                  const SizedBox(height: 8),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 8),
                    _buildErrorMessage(context, _errorMessage!),
                  ],
                  const SizedBox(height: 24),
                  _buildSignUpButton(context, isLoading),
                  const SizedBox(height: 16),
                  _buildSignInLink(context),
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
      L10n.of(context).createAccount,
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildNameField(BuildContext context, bool isLoading) {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: _nameController,
      labelText: l10n.name,
      hintText: l10n.nameDescription,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (value) => ValidationUtils.validateName(context, value),
      enabled: !isLoading,
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
      textInputAction: TextInputAction.next,
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
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context, bool isLoading) {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: _confirmPasswordController,
      labelText: l10n.confirmPassword,
      hintText: l10n.confirmPasswordDescription,
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      validator: (value) => ValidationUtils.validateConfirmPassword(
        context,
        value,
        _passwordController.text,
      ),
      enabled: !isLoading,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          setState(() {
            _obscureConfirmPassword = !_obscureConfirmPassword;
          });
        },
      ),
      onSubmitted: _handleSignUp,
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

  Widget _buildSignUpButton(BuildContext context, bool isLoading) {
    final l10n = L10n.of(context);
    return SizedBox(
      width: double.infinity,
      child: ZoePrimaryButton(
        text: isLoading ? l10n.creatingAccount : l10n.signUp,
        isLoading: isLoading,
        onPressed: _handleSignUp,
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
