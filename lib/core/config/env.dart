import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Reads config values loaded from the bundled `.env` file.
/// Copy `.env.example` to `.env` and fill in real values — `.env` is gitignored.
class Env {
  const Env._();

  static Future<void> load() => dotenv.load();

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}
