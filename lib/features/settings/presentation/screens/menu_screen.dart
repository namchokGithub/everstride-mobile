import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Player'),
            subtitle: Text('View Profile'),
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
}
