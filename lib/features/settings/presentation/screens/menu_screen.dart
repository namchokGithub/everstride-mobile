import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/result.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/controllers/player_cloud_sync_controller.dart';
import '../../../health/presentation/controllers/health_availability_controller.dart';
import '../../../health/presentation/controllers/health_permission_controller.dart';
import '../../../health/presentation/controllers/health_sync_controller.dart';
import '../../../health/presentation/widgets/debug_steps_seeder.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availability = ref.watch(healthConnectAvailabilityProvider);
    final availabilityText = switch (availability) {
      AsyncData(value: Ok(value: true)) => 'Connected',
      AsyncData(value: Ok(value: false)) => 'Not available',
      AsyncData(value: Err()) => 'Error',
      AsyncError() => 'Error',
      _ => 'Checking...',
    };
    final permission = ref.watch(healthPermissionControllerProvider);
    final permissionText = switch (permission) {
      null => 'Checking...',
      AsyncData(value: Ok(value: true)) => 'Granted',
      AsyncData(value: Ok(value: false)) => 'Denied',
      AsyncData(value: Err()) => 'Error',
      AsyncError() => 'Error',
      _ => 'Requesting...',
    };
    final sync = ref.watch(healthSyncControllerProvider);
    final syncing = sync?.isLoading ?? false;
    final auth = ref.watch(authControllerProvider);
    final authAvailable = ref.watch(authRepositoryProvider).isAvailable;
    final backup = ref.watch(playerCloudSyncControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              authAvailable
                  ? (auth?.email ?? 'Guest')
                  : 'Cloud Backup unavailable',
            ),
            subtitle: Text(
              authAvailable
                  ? _backupText(backup)
                  : 'Add Supabase config to enable sign-in',
            ),
            enabled: authAvailable,
            onTap: !authAvailable || auth != null
                ? null
                : () => context.push('/auth'),
            trailing: auth == null
                ? null
                : TextButton(
                    onPressed: () =>
                        ref.read(authControllerProvider.notifier).signOut(),
                    child: const Text('Sign Out'),
                  ),
          ),
          if (authAvailable &&
              auth != null &&
              backup.state == CloudBackupState.confirmationRequired)
            ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: const Text('Cloud backup found'),
              subtitle: const Text(
                'Choose whether to restore it or replace it with this device.',
              ),
              trailing: FilledButton(
                onPressed: () => _chooseCloudBackup(context, ref),
                child: const Text('Review'),
              ),
            )
          else if (authAvailable &&
              auth != null &&
              backup.state == CloudBackupState.failed)
            ListTile(
              leading: const Icon(Icons.cloud_off),
              title: const Text('Backup failed'),
              subtitle: Text(backup.message ?? 'Try again when online.'),
              trailing: TextButton(
                onPressed: () => ref
                    .read(playerCloudSyncControllerProvider.notifier)
                    .retry(),
                child: const Text('Retry'),
              ),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Data & Sync'),
            subtitle: Text(
              'Health Connect: $availabilityText · Permission: $permissionText',
            ),
            trailing: syncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right),
            enabled: !syncing,
            onTap: () => ref.read(healthSyncControllerProvider.notifier).sync(),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            subtitle: Text('Everstride — MVP build'),
          ),
          if (kDebugMode) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Debug Tools',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DebugStepsSeeder(),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  static String _backupText(CloudBackupStatus status) => switch (status.state) {
    CloudBackupState.idle => 'Signed in · Backup ready',
    CloudBackupState.syncing => 'Cloud Backup syncing…',
    CloudBackupState.backedUp => 'Cloud Backup up to date',
    CloudBackupState.failed => 'Cloud Backup needs attention',
    CloudBackupState.confirmationRequired => 'Backup confirmation required',
    CloudBackupState.unavailable => 'Cloud Backup unavailable',
  };

  static Future<void> _chooseCloudBackup(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final choice = await showDialog<_CloudBackupChoice>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose cloud backup'),
        content: const Text(
          'Restore cloud backup replaces progress on this device. Replace cloud '
          'backup permanently overwrites the signed-in account backup with this '
          'device. Restore is the safer choice.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, _CloudBackupChoice.restore),
            child: const Text('Restore cloud backup'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, _CloudBackupChoice.replace),
            child: const Text('Replace cloud backup'),
          ),
        ],
      ),
    );
    switch (choice) {
      case _CloudBackupChoice.restore:
        await ref
            .read(playerCloudSyncControllerProvider.notifier)
            .restoreCloudBackup();
        return;
      case _CloudBackupChoice.replace:
        await ref
            .read(playerCloudSyncControllerProvider.notifier)
            .confirmOverwrite();
        return;
      case null:
        return;
    }
  }
}

enum _CloudBackupChoice { restore, replace }
