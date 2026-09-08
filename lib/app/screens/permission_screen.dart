import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/health/presentation/controllers/health_permission_controller.dart';
import '../../features/settings/data/repositories/app_settings_repository_impl.dart';

class PermissionScreen extends ConsumerWidget {
  const PermissionScreen({super.key});

  Future<void> _continue(BuildContext context, WidgetRef ref) async {
    await ref.read(appSettingsRepositoryProvider).setOnboardingCompleted(true);
    if (context.mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(healthPermissionControllerProvider);
    final requesting = permission?.isLoading ?? false;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Connect Your Activity',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Allow access to your step data through Health Connect.',
              ),
              const Spacer(),
              const _PermissionBullet(text: 'Read your step count'),
              const _PermissionBullet(text: 'Track daily activity'),
              const _PermissionBullet(text: 'Used only for gameplay'),
              const _PermissionBullet(text: 'You can change this anytime'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: requesting
                      ? null
                      : () async {
                          await ref
                              .read(healthPermissionControllerProvider.notifier)
                              .requestPermission();
                          if (!context.mounted) return;
                          await _continue(context, ref);
                        },
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: requesting ? null : () => _continue(context, ref),
                  child: const Text('Not now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionBullet extends StatelessWidget {
  const _PermissionBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
