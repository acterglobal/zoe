import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zoe/features/auth/models/auth_state_model.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';

// Helper class to notify GoRouter when auth state changes
class AuthStateNotifier extends ChangeNotifier {
  final Ref _ref;

  AuthStateNotifier(this._ref) {
    _ref.listen<AuthStateModel>(authStateProvider, (previous, next) {
      notifyListeners();
    });
  }
}
