import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/health/domain/usecases/sync_health_data_usecase.dart';
import 'package:everstride/features/health/presentation/controllers/health_availability_controller.dart';
import 'package:everstride/features/health/presentation/controllers/health_permission_controller.dart';
import 'package:everstride/features/health/presentation/controllers/health_sync_controller.dart';
import 'package:everstride/features/settings/presentation/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePermissionController extends HealthPermissionController {
  @override
  AsyncValue<Result<bool>>? build() => const AsyncData(Ok(true));
}

class _FakeHealthSyncController extends HealthSyncController {
  var syncCallCount = 0;

  @override
  AsyncValue<Result<SyncResult>>? build() => null;

  @override
  Future<void> sync() async {
    syncCallCount++;
  }
}

void main() {
  testWidgets('tapping Data & Sync starts a health sync', (tester) async {
    final container = ProviderContainer(
      overrides: [
        healthConnectAvailabilityProvider.overrideWith(
          (ref) => Future.value(const Ok(true)),
        ),
        healthPermissionControllerProvider.overrideWith(
          _FakePermissionController.new,
        ),
        healthSyncControllerProvider.overrideWith(
          _FakeHealthSyncController.new,
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: MenuScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Data & Sync'));

    final controller = container.read(
      healthSyncControllerProvider.notifier,
    ) as _FakeHealthSyncController;
    expect(controller.syncCallCount, 1);
  });
}
