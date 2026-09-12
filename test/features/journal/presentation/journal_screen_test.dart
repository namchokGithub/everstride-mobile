import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/journal/presentation/screens/journal_screen.dart';
import 'package:everstride/features/quest/domain/entities/quest_instance.dart';
import 'package:everstride/features/quest/domain/entities/quest_definition.dart';
import 'package:everstride/features/quest/presentation/controllers/quest_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _claimableQuest = QuestInstance(
  id: 'today-walker',
  questId: 'daily_steps_1000',
  date: DateTime(2026, 9, 12),
  objectiveType: QuestObjectiveType.dailySteps,
  target: 1000,
  progress: 1000,
  expReward: 10,
  goldReward: 5,
  status: QuestStatus.claimable,
);

final _allQuestStates = [
  _claimableQuest.copyWith(status: QuestStatus.inProgress),
  _claimableQuest,
  _claimableQuest.copyWith(status: QuestStatus.claimed),
  _claimableQuest.copyWith(status: QuestStatus.expired),
];

class _SuccessfulQuestController extends QuestController {
  @override
  AsyncValue<Result<List<QuestInstance>>>? build() =>
      AsyncData(Ok([_claimableQuest]));

  @override
  Future<Result<bool>> claim(QuestInstance instance) async => const Ok(true);
}

class _FailingQuestController extends QuestController {
  @override
  AsyncValue<Result<List<QuestInstance>>>? build() =>
      AsyncData(Ok([_claimableQuest]));

  @override
  Future<Result<bool>> claim(QuestInstance instance) async =>
      const Err(Failure('Quest could not be claimed'));
}

class _AllStatesQuestController extends QuestController {
  @override
  AsyncValue<Result<List<QuestInstance>>>? build() =>
      AsyncData(Ok(_allQuestStates));
}

void main() {
  testWidgets(
    'claimable Quest has a plain-language status and confirms claim',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          questControllerProvider.overrideWith(_SuccessfulQuestController.new),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: JournalScreen()),
        ),
      );

      expect(find.text('Ready to claim'), findsOneWidget);
      await tester.tap(find.text('Claim'));
      await tester.pump();
      expect(find.text('Claimed! +10 EXP, +5 Gold'), findsOneWidget);
    },
  );

  testWidgets('failed Quest claim keeps the failure feedback', (tester) async {
    final container = ProviderContainer(
      overrides: [
        questControllerProvider.overrideWith(_FailingQuestController.new),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: JournalScreen()),
      ),
    );

    await tester.tap(find.text('Claim'));
    await tester.pump();

    expect(find.text('Quest could not be claimed'), findsOneWidget);
  });

  testWidgets('Quest statuses use plain-language labels', (tester) async {
    final container = ProviderContainer(
      overrides: [
        questControllerProvider.overrideWith(_AllStatesQuestController.new),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: JournalScreen()),
      ),
    );

    expect(find.text('In Progress'), findsOneWidget);
    expect(find.text('Ready to claim'), findsOneWidget);
    expect(find.text('Claimed'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Expired'), 200);
    expect(find.text('Expired'), findsOneWidget);
  });
}
