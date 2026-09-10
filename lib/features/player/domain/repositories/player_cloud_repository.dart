import '../../../../core/errors/result.dart';
import '../entities/cloud_game_snapshot.dart';

abstract class PlayerCloudRepository {
  Future<Result<CloudGameSnapshot?>> fetch(String userId);
  Future<Result<bool>> push(String userId, CloudGameSnapshot snapshot);
}
