import 'package:everstride/features/adventure/domain/adventure_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Greenwood Trail matches the documented difficulty matrix exactly', () {
    expect(greenwoodTrail.id, 'greenwood_trail');
    expect(greenwoodTrail.defaultDifficulty.id, 'easy');

    final easy = greenwoodTrail.difficultyById('easy');
    expect(easy.energyCost, 10);
    expect(easy.expReward, 25);
    expect(easy.goldReward, 10);

    final normal = greenwoodTrail.difficultyById('normal');
    expect(normal.energyCost, 20);
    expect(normal.expReward, 55);
    expect(normal.goldReward, 22);

    final hard = greenwoodTrail.difficultyById('hard');
    expect(hard.energyCost, 30);
    expect(hard.expReward, 90);
    expect(hard.goldReward, 36);
  });
}
