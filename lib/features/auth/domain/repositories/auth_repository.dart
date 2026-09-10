import '../../../../core/errors/result.dart';

class AuthUser {
  const AuthUser({required this.id, required this.email});
  final String id;
  final String email;
}

sealed class AuthSignUpOutcome {
  const AuthSignUpOutcome();
}

class AuthSignedIn extends AuthSignUpOutcome {
  const AuthSignedIn(this.user);
  final AuthUser user;
}

class AuthEmailConfirmationRequired extends AuthSignUpOutcome {
  const AuthEmailConfirmationRequired();
}

abstract class AuthRepository {
  bool get isAvailable;
  AuthUser? get currentUser;
  Stream<AuthUser?> authStateChanges();
  Future<Result<AuthSignUpOutcome>> signUp({
    required String email,
    required String password,
  });
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  });
  Future<Result<bool>> signOut();
}
