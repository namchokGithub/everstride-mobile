import '../../../../core/errors/result.dart';
import '../entities/cloud_game_snapshot.dart';

abstract class LocalGameSnapshotRepository {
  Future<Result<CloudGameSnapshot>> read();
  Future<Result<bool>> replace(CloudGameSnapshot snapshot);
}
