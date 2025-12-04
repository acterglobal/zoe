// Mock classes
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:mocktail/mocktail.dart';
import 'package:zoe/features/auth/providers/auth_providers.dart';
import 'package:zoe/features/auth/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements firebase_auth.User {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class MockAuthState extends Mock implements AuthState {}

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}
