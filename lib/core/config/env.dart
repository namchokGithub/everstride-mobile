import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Reads config values loaded from the bundled `.env` file.
/// Copy `.env.example` to `.env` and fill in real values — `.env` is gitignored.
class Env {
  const Env._();

  static bool _loaded = false;

  static Future<void> load() async {
    await dotenv.load();
    _loaded = true;
  }

  static String get supabaseUrl =>
      _loaded ? dotenv.env['SUPABASE_URL'] ?? '' : '';
  static String get supabaseAnonKey =>
      _loaded ? dotenv.env['SUPABASE_ANON_KEY'] ?? '' : '';

  static bool get hasSupabaseConfig =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;
}
