import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/adventure/presentation/screens/adventure_screen.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';
import 'package:everstride/features/player/presentation/controllers/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _player = PlayerState(
  level: 1,
  exp: 0,
  energy: 20,
  gold: 0,
  pendingSteps: 0,
);

class _SuccessfulPlayerController extends PlayerController {
  var spendCallCount = 0;

  @override
  AsyncValue<Result<PlayerState>>? build() => const AsyncData(Ok(_player));

  @override
  Future<Result<PlayerState>> spendOnAdventure({
    required int energyCost,
    required int expReward,
    required int goldReward,
  }) async {
    spendCallCount++;
    return const Ok(_player);
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

void main() {
  testWidgets(
    'difficulty selection is visual-only and Start Adventure keeps the temporary action',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          playerControllerProvider.overrideWith(
            _SuccessfulPlayerController.new,
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: AdventureScreen()),
        ),
      );

      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Easy'))
            .selected,
        isTrue,
      );
      await tester.tap(find.text('Normal'));
      await tester.pump();
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Normal'))
            .selected,
        isTrue,
      );

      final startAdventure = find.text('Start Adventure · 10 Energy');
      await tester.ensureVisible(startAdventure);
      await tester.tap(startAdventure);
      await tester.pump();

      final controller = container.read(
        playerControllerProvider.notifier,
      ) as _SuccessfulPlayerController;
      expect(controller.spendCallCount, 1);
      expect(
        find.text('Adventure complete! +25 EXP, +10 Gold'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Start Adventure shows the existing insufficient-Energy feedback',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          playerControllerProvider.overrideWith(_FailingPlayerController.new),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: AdventureScreen()),
        ),
      );

      final startAdventure = find.text('Start Adventure · 10 Energy');
      await tester.ensureVisible(startAdventure);
      await tester.tap(startAdventure);
      await tester.pump();

      expect(find.text('Not enough energy'), findsOneWidget);
    },
  );
}
