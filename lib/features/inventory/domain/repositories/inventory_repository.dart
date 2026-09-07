/// Abstracts inventory/item data so UI never calls Supabase or the local DB
/// directly. Methods land once an inventory feature is scheduled (post-MVP).
abstract class InventoryRepository {}
