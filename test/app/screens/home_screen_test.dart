import 'package:everstride/app/screens/home_screen.dart';
import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/health/domain/usecases/sync_health_data_usecase.dart';
import 'package:everstride/features/health/presentation/controllers/health_availability_controller.dart';
import 'package:everstride/features/health/presentation/controllers/health_permission_controller.dart';
import 'package:everstride/features/health/presentation/controllers/health_sync_controller.dart';
import 'package:everstride/features/health/presentation/controllers/steps_controller.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';
import 'package:everstride/features/player/presentation/controllers/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home exposes labels for its date picker and sync controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          healthConnectAvailabilityProvider.overrideWith(
            (ref) => Future.value(const Ok(true)),
          ),
          healthPermissionControllerProvider.overrideWith(
            _GrantedPermissionController.new,
          ),
          healthSyncControllerProvider.overrideWith(_IdleSyncController.new),
          stepsForSelectedDateProvider.overrideWith(
            (ref) => Future.value(const Ok(0)),
          ),
          playerControllerProvider.overrideWith(_PlayerController.new),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Pick a date'), findsOneWidget);
    expect(find.byTooltip('Sync now'), findsOneWidget);
  });
}

class _GrantedPermissionController extends HealthPermissionController {
  @override
  AsyncValue<Result<bool>>? build() => const AsyncData(Ok(true));
}

class _IdleSyncController extends HealthSyncController {
  @override
  AsyncValue<Result<SyncResult>>? build() => null;
}

class _PlayerController extends PlayerController {
  @override
  AsyncValue<Result<PlayerState>>? build() => const AsyncData(
    Ok(PlayerState(level: 1, exp: 0, energy: 0, gold: 0, pendingSteps: 0)),
  );
}
