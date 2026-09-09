import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/result.dart';
import '../../features/settings/data/repositories/app_settings_repository_impl.dart';

String resolveSplashDestination({required bool onboardingCompleted}) {
  return onboardingCompleted ? '/home' : '/onboarding';
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolve());
  }

  Future<void> _resolve() async {
    final result = await ref
        .read(appSettingsRepositoryProvider)
        .getOnboardingCompleted();
    final onboardingCompleted = switch (result) {
      Ok(:final value) => value,
      Err() => false,
    };
    if (!mounted) return;
    context.go(
      resolveSplashDestination(onboardingCompleted: onboardingCompleted),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('lib/assets/bg.png', fit: BoxFit.cover),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('lib/assets/branding/splash-logo.png', width: 220),
                const SizedBox(height: 24),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
