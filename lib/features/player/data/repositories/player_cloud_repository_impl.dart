import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/env.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/cloud_game_snapshot.dart';
import '../../domain/repositories/player_cloud_repository.dart';

class PlayerCloudRepositoryImpl implements PlayerCloudRepository {
  PlayerCloudRepositoryImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<Result<CloudGameSnapshot?>> fetch(String userId) async {
    try {
      final row = await _client
          .from('player_saves')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      return Ok(row == null ? null : CloudGameSnapshot.fromCloudRow(row));
    } catch (e) {
      AppLogger.error('player.cloud', 'Failed to fetch cloud backup', e);
      return Err(Failure('Failed to fetch cloud backup', cause: e));
    }
  }

  @override
  Future<Result<bool>> push(String userId, CloudGameSnapshot snapshot) async {
    try {
      await _client.from('player_saves').upsert({
        ...snapshot.toCloudRow(userId),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      return const Ok(true);
    } catch (e) {
      AppLogger.error('player.cloud', 'Failed to push cloud backup', e);
      return Err(Failure('Failed to push cloud backup', cause: e));
    }
  }
}

final playerCloudRepositoryProvider = Provider<PlayerCloudRepository?>((ref) {
  if (!Env.hasSupabaseConfig) return null;
  return PlayerCloudRepositoryImpl(Supabase.instance.client);
});
