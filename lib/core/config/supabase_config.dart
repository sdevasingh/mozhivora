import 'package:supabase_flutter/supabase_flutter.dart';

/// Reads Supabase public client configuration from compile-time `--dart-define`.
/// Never hardcode keys in client code.
abstract final class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;

  static Future<void> initializeIfConfigured() async {
    if (!isConfigured) return;
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  static SupabaseClient? get clientOrNull =>
      isConfigured ? Supabase.instance.client : null;
}
