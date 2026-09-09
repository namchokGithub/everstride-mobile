import 'entities/adventure.dart';

/// The one playable Adventure for the Phase 4 MVP. Values match the
/// difficulty matrix in everstride-docs/game-design/adventure-system.md.
const greenwoodTrail = Adventure(
  id: 'greenwood_trail',
  name: 'Greenwood Trail',
  description: 'A peaceful path through the forest.',
  defaultDifficultyId: 'easy',
  difficultyOptions: [
    AdventureDifficulty(
      id: 'easy',
      label: 'Easy',
      energyCost: 10,
      expReward: 25,
      goldReward: 10,
    ),
    AdventureDifficulty(
      id: 'normal',
      label: 'Normal',
      energyCost: 20,
      expReward: 55,
      goldReward: 22,
    ),
    AdventureDifficulty(
      id: 'hard',
      label: 'Hard',
      energyCost: 30,
      expReward: 90,
      goldReward: 36,
    ),
  ],
);
