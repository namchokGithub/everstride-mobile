import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isSignUp = false;
  bool _submitting = false;
  String? _message;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _message = 'Enter an email and password.');
      return;
    }
    setState(() {
      _submitting = true;
      _message = null;
    });
    final auth = ref.read(authControllerProvider.notifier);
    if (_isSignUp) {
      final result = await auth.signUp(email: email, password: password);
      if (!mounted) return;
      setState(() => _submitting = false);
      switch (result) {
        case Ok(value: AuthSignedIn()):
          context.pop();
        case Ok(value: AuthEmailConfirmationRequired()):
          setState(
            () => _message = 'Check your email to confirm your account.',
          );
        case Err(:final failure):
          setState(() => _message = failure.message);
      }
    } else {
      final result = await auth.signIn(email: email, password: password);
      if (!mounted) return;
      setState(() => _submitting = false);
      switch (result) {
        case Ok():
          context.pop();
        case Err(:final failure):
          setState(() => _message = failure.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_isSignUp ? 'Sign Up' : 'Sign In')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Text(
              _message!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isSignUp ? 'Sign Up' : 'Sign In'),
          ),
          TextButton(
            onPressed: _submitting
                ? null
                : () => setState(() => _isSignUp = !_isSignUp),
            child: Text(
              _isSignUp
                  ? 'Already have an account? Sign In'
                  : "Don't have an account? Sign Up",
            ),
          ),
        ],
      ),
    ),
  );
}
