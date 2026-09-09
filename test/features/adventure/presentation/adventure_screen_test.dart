import 'dart:async';

import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/adventure/presentation/models/adventure_result.dart';
import 'package:everstride/features/adventure/presentation/screens/adventure_result_screen.dart';
import 'package:everstride/features/adventure/presentation/screens/adventure_screen.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';
import 'package:everstride/features/player/presentation/controllers/player_controller.dart';
import 'package:everstride/features/quest/domain/entities/quest_instance.dart';
import 'package:everstride/features/quest/presentation/controllers/quest_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const _player = PlayerState(
  level: 1,
  exp: 0,
  energy: 20,
  gold: 50,
  pendingSteps: 0,
);

class _SuccessfulPlayerController extends PlayerController {
  var lastEnergyCost = 0;
  var lastExpReward = 0;
  var lastGoldReward = 0;
  var lastAdditionalGoldCost = 0;
  PlayerState? lastPlayerAfter;

  @override
  AsyncValue<Result<PlayerState>>? build() => const AsyncData(Ok(_player));

  @override
  Future<Result<PlayerState>> spendOnAdventure({
    required int energyCost,
    required int expReward,
    required int goldReward,
    int additionalGoldCost = 0,
  }) async {
    lastEnergyCost = energyCost;
    lastExpReward = expReward;
    lastGoldReward = goldReward;
    lastAdditionalGoldCost = additionalGoldCost;
    final playerAfter = _player.copyWith(
      energy: _player.energy - energyCost,
      exp: expReward,
      gold: _player.gold - additionalGoldCost + goldReward,
    );
    lastPlayerAfter = playerAfter;
    return Ok(playerAfter);
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
    int additionalGoldCost = 0,
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
    int additionalGoldCost = 0,
  }) {
    spendCallCount++;
    return _result.future;
  }

  void complete() => _result.complete(const Ok(_player));
}

class _LowGoldPlayerController extends PlayerController {
  @override
  AsyncValue<Result<PlayerState>>? build() =>
      AsyncData(Ok(_player.copyWith(gold: 10)));

  @override
  Future<Result<PlayerState>> spendOnAdventure({
    required int energyCost,
    required int expReward,
    required int goldReward,
    int additionalGoldCost = 0,
  }) async => Ok(_player.copyWith(gold: 10));
}

class _NoOpQuestController extends QuestController {
  @override
  AsyncValue<Result<List<QuestInstance>>>? build() => const AsyncData(Ok([]));

  @override
  Future<void> recordAdventureCompletion() async {}
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
          questControllerProvider.overrideWith(_NoOpQuestController.new),
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
          questControllerProvider.overrideWith(_NoOpQuestController.new),
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
      expect(controller.lastAdditionalGoldCost, 0);
      expect(find.byType(AdventureResultScreen), findsOneWidget);
      expect(find.text('Adventure Complete!'), findsOneWidget);
      expect(find.text('Trail Supplies'), findsNothing);
    },
  );

  testWidgets(
    'insufficient Energy shows an explanatory dialog and does not navigate',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          playerControllerProvider.overrideWith(_FailingPlayerController.new),
          questControllerProvider.overrideWith(_NoOpQuestController.new),
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
        questControllerProvider.overrideWith(_NoOpQuestController.new),
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

  testWidgets(
    'Trail Supplies boosts rewards, deducts Gold, and appears in result',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          playerControllerProvider.overrideWith(
            _SuccessfulPlayerController.new,
          ),
          questControllerProvider.overrideWith(_NoOpQuestController.new),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(_harness(container));
      final supplies = find.text(
        'Use Trail Supplies (-30 Gold): +50% EXP & Gold this run',
      );
      await tester.ensureVisible(supplies);
      await tester.tap(supplies);
      await tester.pump();
      expect(find.text('+37 EXP'), findsOneWidget);
      expect(find.text('+15 Gold'), findsOneWidget);
      final start = find.text('Start Adventure · 10 Energy');
      await tester.ensureVisible(start);
      await tester.tap(start);
      await tester.pumpAndSettle();
      final controller = container.read(
        playerControllerProvider.notifier,
      ) as _SuccessfulPlayerController;
      expect(controller.lastAdditionalGoldCost, 30);
      expect(controller.lastPlayerAfter?.gold, 35);
      expect(find.text('Trail Supplies'), findsOneWidget);
      expect(find.text('-30'), findsOneWidget);
    },
  );

  testWidgets('Trail Supplies resets after a successful run', (tester) async {
    final container = ProviderContainer(
      overrides: [
        playerControllerProvider.overrideWith(_SuccessfulPlayerController.new),
        questControllerProvider.overrideWith(_NoOpQuestController.new),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(_harness(container));
    final supplies = find.text(
      'Use Trail Supplies (-30 Gold): +50% EXP & Gold this run',
    );
    await tester.ensureVisible(supplies);
    await tester.tap(supplies);
    final start = find.text('Start Adventure · 10 Energy');
    await tester.ensureVisible(start);
    await tester.tap(start);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
      isFalse,
    );
    expect(find.text('+25 EXP'), findsOneWidget);
  });

  testWidgets('Trail Supplies is disabled when Gold is insufficient', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        playerControllerProvider.overrideWith(_LowGoldPlayerController.new),
        questControllerProvider.overrideWith(_NoOpQuestController.new),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(_harness(container));
    final tile = tester.widget<CheckboxListTile>(find.byType(CheckboxListTile));
    expect(tile.onChanged, isNull);
    expect(find.text('Need 30 Gold — you have 10'), findsOneWidget);
  });
}
