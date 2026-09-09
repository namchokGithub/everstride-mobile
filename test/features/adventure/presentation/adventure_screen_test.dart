import 'dart:async';

import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/adventure/presentation/models/adventure_result.dart';
import 'package:everstride/features/adventure/presentation/screens/adventure_result_screen.dart';
import 'package:everstride/features/adventure/presentation/screens/adventure_screen.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';
import 'package:everstride/features/player/presentation/controllers/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const _player = PlayerState(
  level: 1,
  exp: 0,
  energy: 20,
  gold: 0,
  pendingSteps: 0,
);

class _SuccessfulPlayerController extends PlayerController {
  var lastEnergyCost = 0;
  var lastExpReward = 0;
  var lastGoldReward = 0;

  @override
  AsyncValue<Result<PlayerState>>? build() => const AsyncData(Ok(_player));

  @override
  Future<Result<PlayerState>> spendOnAdventure({
    required int energyCost,
    required int expReward,
    required int goldReward,
  }) async {
    lastEnergyCost = energyCost;
    lastExpReward = expReward;
    lastGoldReward = goldReward;
    return Ok(
      _player.copyWith(
        energy: _player.energy - energyCost,
        exp: expReward,
        gold: goldReward,
      ),
    );
  }
}

class _FailingPlayerController extends PlayerController {
  @override
  AsyncValue<Result<PlayerState>>? build() => const AsyncData(Ok(_player));

  @override
  Future<Result<PlayerState>> spendOnAdventure({
    required int energyCost,
    required int expReward,
    required int goldReward,
  }) async {
    return const Err(Failure('Not enough energy'));
  }
}

class _DelayedPlayerController extends PlayerController {
  var spendCallCount = 0;
  final _result = Completer<Result<PlayerState>>();

  @override
  AsyncValue<Result<PlayerState>>? build() => const AsyncData(Ok(_player));

  @override
  Future<Result<PlayerState>> spendOnAdventure({
    required int energyCost,
    required int expReward,
    required int goldReward,
  }) {
    spendCallCount++;
    return _result.future;
  }

  void complete() => _result.complete(const Ok(_player));
}

Widget _harness(ProviderContainer container) {
  final router = GoRouter(
    initialLocation: '/adventure',
    routes: [
      GoRoute(
        path: '/adventure',
        builder: (context, state) => const AdventureScreen(),
      ),
      GoRoute(
        path: '/adventure-result',
        builder: (context, state) =>
            AdventureResultScreen(result: state.extra as AdventureResult),
      ),
    ],
  );
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  testWidgets(
    'selecting a harder difficulty updates displayed cost and rewards',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          playerControllerProvider.overrideWith(
            _SuccessfulPlayerController.new,
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));

      expect(find.text('Start Adventure · 10 Energy'), findsOneWidget);
      await tester.tap(find.text('Normal'));
      await tester.pump();
      expect(find.text('Start Adventure · 20 Energy'), findsOneWidget);
      expect(find.text('+55 EXP'), findsOneWidget);
      expect(find.text('+22 Gold'), findsOneWidget);
    },
  );

  testWidgets(
    'starting a valid Adventure pushes the result screen with the real values',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          playerControllerProvider.overrideWith(
            _SuccessfulPlayerController.new,
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('Normal'));
      await tester.pump();

      final startButton = find.text('Start Adventure · 20 Energy');
      await tester.ensureVisible(startButton);
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      final controller = container.read(
        playerControllerProvider.notifier,
      ) as _SuccessfulPlayerController;
      expect(controller.lastEnergyCost, 20);
      expect(controller.lastExpReward, 55);
      expect(controller.lastGoldReward, 22);
      expect(find.byType(AdventureResultScreen), findsOneWidget);
      expect(find.text('Adventure Complete!'), findsOneWidget);
    },
  );

  testWidgets(
    'insufficient Energy shows an explanatory dialog and does not navigate',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          playerControllerProvider.overrideWith(_FailingPlayerController.new),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));

      final startButton = find.text('Start Adventure · 10 Energy');
      await tester.ensureVisible(startButton);
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      expect(find.text('Not enough Energy'), findsOneWidget);
      expect(find.textContaining('costs 10 Energy'), findsOneWidget);
      expect(find.byType(AdventureResultScreen), findsNothing);
    },
  );

  testWidgets('rapid Start Adventure taps resolve at most once', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        playerControllerProvider.overrideWith(_DelayedPlayerController.new),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(_harness(container));

    final startButton = find.text('Start Adventure · 10 Energy');
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.tap(startButton);

    final controller = container.read(
      playerControllerProvider.notifier,
    ) as _DelayedPlayerController;
    expect(controller.spendCallCount, 1);

    controller.complete();
    await tester.pumpAndSettle();
  });
}
