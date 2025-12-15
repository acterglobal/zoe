import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:zoe/common/widgets/toolkit/zoe_app_bar_widget.dart';

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
  bool _isLoading = false;
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
    // Validate form first
    if (_formKey.currentState?.validate() == false) return;

    // Clear any previous errors and set loading state
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .signUp(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      if (!mounted) return;
      context.go(AppRoutes.home.route);
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Sign up error';
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: AnimatedBackgroundWidget(
        child: SafeArea(
          child: MaxWidthWidget(
            isScrollable: true,
            padding: const EdgeInsets.all(24),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTitle(),
          const SizedBox(height: 32),
          _buildNameField(),
          const SizedBox(height: 16),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildConfirmPasswordField(),
          const SizedBox(height: 8),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            _buildErrorMessage(),
          ],
          const SizedBox(height: 24),
          _buildSignUpButton(),
          const SizedBox(height: 16),
          _buildSignInLink(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      L10n.of(context).createAccount,
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildNameField() {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: _nameController,
      labelText: l10n.name,
      hintText: l10n.nameDescription,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (value) => ValidationUtils.validateName(context, value),
      enabled: !_isLoading,
    );
  }

  Widget _buildEmailField() {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: _emailController,
      labelText: l10n.email,
      hintText: l10n.emailDescription,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) => ValidationUtils.validateEmail(context, value),
      enabled: !_isLoading,
    );
  }

  Widget _buildPasswordField() {
    final l10n = L10n.of(context);

    return AnimatedTextField(
      controller: _passwordController,
      labelText: l10n.password,
      hintText: l10n.passwordDescription,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      validator: (value) => ValidationUtils.validatePassword(context, value),
      enabled: !_isLoading,
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

  Widget _buildConfirmPasswordField() {
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
      enabled: !_isLoading,
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

  Widget _buildErrorMessage() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _errorMessage!,
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSignUpButton() {
    final l10n = L10n.of(context);
    return SizedBox(
      width: double.infinity,
      child: ZoePrimaryButton(
        text: _isLoading ? l10n.creatingAccount : l10n.signUp,
        isLoading: _isLoading,
        onPressed: _handleSignUp,
      ),
    );
  }

  Widget _buildSignInLink() {
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
