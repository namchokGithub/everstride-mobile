import 'package:everstride/features/adventure/presentation/models/adventure_result.dart';
import 'package:everstride/features/adventure/presentation/screens/adventure_result_screen.dart';
import 'package:everstride/features/player/domain/repositories/player_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _leveledUpResult = AdventureResult(
  adventureName: 'Greenwood Trail',
  difficultyLabel: 'Easy',
  energySpent: 10,
  expGained: 25,
  goldGained: 10,
  levelBefore: 1,
  playerAfter: PlayerState(
    level: 2,
    exp: 0,
    energy: 10,
    gold: 10,
    pendingSteps: 0,
  ),
);

void main() {
  testWidgets('level-up result reveals the level feedback with motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: AdventureResultScreen(result: _leveledUpResult)),
    );

    expect(find.text('Level Up! 1 → 2'), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('Level Up! 1 → 2'),
        matching: find.byType(Transform),
      ),
      findsOneWidget,
    );
  });

  testWidgets('reduced motion renders level-up feedback without a transform', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: AdventureResultScreen(result: _leveledUpResult),
        ),
      ),
    );

    expect(find.text('Level Up! 1 → 2'), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('Level Up! 1 → 2'),
        matching: find.byType(Transform),
      ),
      findsNothing,
    );
  });
}
