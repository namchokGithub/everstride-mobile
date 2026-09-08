import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../domain/repositories/player_repository.dart';
import '../controllers/player_controller.dart';

class CharacterScreen extends ConsumerWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerControllerProvider);
    final playerState = switch (player?.value) {
      Ok(:final value) => value,
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Character')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: playerState == null
            ? const Center(child: Text('Loading...'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Lv. ${playerState.level}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value:
                        (playerState.exp /
                                PlayerState.expToNextLevel(playerState.level))
                            .clamp(0, 1)
                            .toDouble(),
                  ),
                  Text(
                    'EXP ${playerState.exp} / ${PlayerState.expToNextLevel(playerState.level)}',
                  ),
                  const SizedBox(height: 24),
                  ListTile(
                    leading: const Icon(Icons.bolt),
                    title: const Text('Energy'),
                    trailing: Text('${playerState.energy}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.monetization_on),
                    title: const Text('Gold'),
                    trailing: Text('${playerState.gold}'),
                  ),
                ],
              ),
      ),
    );
  }
}
