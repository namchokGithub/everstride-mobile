import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends Notifier<AuthUser?> {
  @override
  AuthUser? build() {
    final repository = ref.watch(authRepositoryProvider);
    final subscription = repository.authStateChanges().listen(
      (user) => state = user,
    );
    ref.onDispose(subscription.cancel);
    return repository.currentUser;
  }

  bool get isAvailable => ref.read(authRepositoryProvider).isAvailable;

  Future<Result<AuthSignUpOutcome>> signUp({
    required String email,
    required String password,
  }) =>
      ref.read(authRepositoryProvider).signUp(email: email, password: password);

  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) =>
      ref.read(authRepositoryProvider).signIn(email: email, password: password);

  Future<Result<bool>> signOut() => ref.read(authRepositoryProvider).signOut();
}

final authControllerProvider = NotifierProvider<AuthController, AuthUser?>(
  AuthController.new,
);
