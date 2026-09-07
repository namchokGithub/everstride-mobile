/// Abstracts player state persistence/sync so UI never calls Supabase or the
/// local DB directly. Methods land with the Player entity (Phase 3).
abstract class PlayerRepository {}
