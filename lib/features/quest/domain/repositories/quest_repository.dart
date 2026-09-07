/// Abstracts daily quest data/progress so UI never calls Supabase or the
/// local DB directly. Methods land with the daily quest structure (Phase 5).
abstract class QuestRepository {}
