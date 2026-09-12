import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/result.dart';
import '../../features/health/data/repositories/health_repository_impl.dart';
import '../../features/health/presentation/controllers/health_availability_controller.dart';
import '../../features/health/presentation/controllers/health_permission_controller.dart';
import '../../features/health/presentation/controllers/health_sync_controller.dart';
import '../../features/health/presentation/controllers/steps_controller.dart';
import '../../features/player/domain/repositories/player_repository.dart';
import '../../features/player/presentation/controllers/player_controller.dart';

const _dailyStepGoal = 10000;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availability = ref.watch(healthConnectAvailabilityProvider);
    final isAvailable = switch (availability) {
      AsyncData(value: Ok(value: true)) => true,
      _ => false,
    };

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'lib/assets/branding/logo-horizontal.png',
          height: 32,
        ),
        actions: [
          IconButton(
            tooltip: 'Pick a date',
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: () async {
              final selectedDate = ref.read(selectedDateProvider);
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                ref.read(selectedDateProvider.notifier).set(picked);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isAvailable && !availability.isLoading)
              const _HealthConnectUnavailableBanner(),
            if (isAvailable) const _PermissionGate(child: _Dashboard()),
          ],
        ),
      ),
    );
  }
}

class _HealthConnectUnavailableBanner extends ConsumerWidget {
  const _HealthConnectUnavailableBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text(
          "Health Connect isn't available on this device. Steps can't be read until it's installed and up to date.",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () =>
              ref.read(healthRepositoryProvider).promptInstallOrUpdate(),
          child: const Text('Install / Update Health Connect'),
        ),
      ],
    );
  }
}

class _PermissionGate extends ConsumerWidget {
  const _PermissionGate({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(healthPermissionControllerProvider);
    final denied = switch (permission) {
      AsyncData(value: Ok(value: false)) => true,
      _ => false,
    };
    if (!denied) return child;

    return Column(
      children: [
        const Text(
          "Steps can't be read without this permission. Tap below to try again.",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => ref
              .read(healthPermissionControllerProvider.notifier)
              .requestPermission(),
          child: const Text('Request Health Permission'),
        ),
      ],
    );
  }
}

class _Dashboard extends ConsumerWidget {
  const _Dashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerControllerProvider);
    final playerState = switch (player?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    final steps = ref.watch(stepsForSelectedDateProvider);
    final sync = ref.watch(healthSyncControllerProvider);
    final stepsValue = switch (steps.value) {
      Ok(:final value) => value,
      _ => 0,
    };
    final syncText = switch (sync) {
      null => null,
      AsyncData(:final value) => switch (value) {
        Ok(:final value) =>
          value.totalNewRewardableSteps > 0
              ? '+${value.totalNewRewardableSteps} rewardable steps synced'
              : 'No new rewardable steps',
        Err(:final failure) => 'Sync error (${failure.message})',
      },
      AsyncError() => 'Sync error',
      _ => 'Syncing...',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            const CircleAvatar(radius: 28, child: Icon(Icons.person)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playerState == null ? 'Lv. -' : 'Lv. ${playerState.level}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: playerState == null
                        ? 0
                        : (playerState.exp /
                                  PlayerState.expToNextLevel(playerState.level))
                              .clamp(0, 1)
                              .toDouble(),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: (stepsValue / _dailyStepGoal).clamp(0, 1).toDouble(),
                strokeWidth: 10,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$stepsValue',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Text('/ $_dailyStepGoal steps'),
              ],
            ),
          ],
        ),
        Center(
          child: IconButton(
            tooltip: 'Sync now',
            icon: (steps.isLoading || (sync?.isLoading ?? false))
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            onPressed: (steps.isLoading || (sync?.isLoading ?? false))
                ? null
                : () {
                    ref.invalidate(stepsForSelectedDateProvider);
                    ref.read(healthSyncControllerProvider.notifier).sync();
                  },
          ),
        ),
        if (syncText != null)
          Center(
            child: Text(syncText, style: Theme.of(context).textTheme.bodySmall),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatChip(
              icon: Icons.bolt,
              label: 'Energy',
              value: '${playerState?.energy ?? '-'}',
            ),
            _StatChip(
              icon: Icons.monetization_on,
              label: 'Gold',
              value: '${playerState?.gold ?? '-'}',
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => context.go('/adventure'),
          child: const Text('Go to Adventure'),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Icon(icon), const SizedBox(height: 4), Text('$label: $value')],
    );
  }
}
