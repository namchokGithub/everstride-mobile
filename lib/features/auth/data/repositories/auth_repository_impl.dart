import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../../../../core/config/env.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._client);
  final SupabaseClient _client;

  AuthUser? _mapUser(User? user) =>
      user == null ? null : AuthUser(id: user.id, email: user.email ?? '');

  @override
  bool get isAvailable => true;

  @override
  AuthUser? get currentUser => _mapUser(_client.auth.currentUser);

  @override
  Stream<AuthUser?> authStateChanges() => _client.auth.onAuthStateChange.map(
    (event) => _mapUser(event.session?.user),
  );

  @override
  Future<Result<AuthSignUpOutcome>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final user = _mapUser(response.user);
      if (user == null) {
        return const Err(Failure('Sign up did not return a user'));
      }
      return response.session == null
          ? const Ok(AuthEmailConfirmationRequired())
          : Ok(AuthSignedIn(user));
    } on AuthException catch (e) {
      return Err(Failure(e.message, cause: e));
    } catch (e) {
      AppLogger.error('auth.state', 'Sign up failed', e);
      return Err(Failure('Sign up failed', cause: e));
    }
  }

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = _mapUser(response.user);
      return user == null
          ? const Err(Failure('Sign in did not return a user'))
          : Ok(user);
    } on AuthException catch (e) {
      return Err(Failure(e.message, cause: e));
    } catch (e) {
      AppLogger.error('auth.state', 'Sign in failed', e);
      return Err(Failure('Sign in failed', cause: e));
    }
  }

  @override
  Future<Result<bool>> signOut() async {
    try {
      await _client.auth.signOut();
      return const Ok(true);
    } catch (e) {
      AppLogger.error('auth.state', 'Sign out failed', e);
      return Err(Failure('Sign out failed', cause: e));
    }
  }
}

class UnavailableAuthRepository implements AuthRepository {
  static const _failure = Failure('Cloud Backup is unavailable');

  @override
  bool get isAvailable => false;
  @override
  AuthUser? get currentUser => null;
  @override
  Stream<AuthUser?> authStateChanges() => const Stream.empty();
  @override
  Future<Result<AuthSignUpOutcome>> signUp({
    required String email,
    required String password,
  }) async => const Err(_failure);
  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async => const Err(_failure);
  @override
  Future<Result<bool>> signOut() async => const Err(_failure);
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (!Env.hasSupabaseConfig) return UnavailableAuthRepository();
  return AuthRepositoryImpl(Supabase.instance.client);
});
