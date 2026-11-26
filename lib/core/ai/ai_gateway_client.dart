import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mozhivora/core/config/app_preferences.dart';
import 'package:mozhivora/core/config/supabase_config.dart';
import 'package:mozhivora/features/settings/data/workspace_memory_provider.dart';

class AiGatewayException implements Exception {
  const AiGatewayException(this.message, {this.isConfigError = false});
  final String message;
  final bool isConfigError;

  @override
  String toString() => message;
}

class AiGatewayClient {
  AiGatewayClient(this._ref);

  final Ref _ref;

  /// Estimates credit cost before any AI action runs.
  static int estimateCredits({
    required String prompt,
    bool highQuality = false,
  }) {
    final base = highQuality ? 2 : 1;
    final lengthExtra = prompt.length > 4000 ? 1 : 0;
    return base + lengthExtra;
  }

  Stream<String> streamCompletion({
    required String tool,
    required String prompt,
    bool highQuality = false,
    Uint8List? fileBytes,
    String? fileMimeType,
  }) async* {
    final client = SupabaseConfig.clientOrNull;
    if (client == null) {
      throw const AiGatewayException(
        'AI Gateway requires SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
        isConfigError: true,
      );
    }

    final session = client.auth.currentSession;
    if (session == null) {
      throw const AiGatewayException(
        'Please sign in to run AI actions.',
        isConfigError: true,
      );
    }

    final memory = _ref.read(workspaceMemoryProvider);
    final prefs = _ref.read(appPreferencesProvider);
    final systemContext = memory.enabled
        ? [
            if (memory.aboutMe.isNotEmpty) 'About user: ${memory.aboutMe}',
            if (memory.businessContext.isNotEmpty)
              'Business: ${memory.businessContext}',
            if (memory.preferredStyle.isNotEmpty)
              'Style: ${memory.preferredStyle}',
          ].join(' | ')
        : null;

    final creditCost =
        estimateCredits(prompt: prompt, highQuality: highQuality);
    final uri = Uri.parse('${SupabaseConfig.url}/functions/v1/ai-gateway');
    final request = http.Request('POST', uri)
      ..headers.addAll({
        'Authorization': 'Bearer ${session.accessToken}',
        'apikey': SupabaseConfig.anonKey,
        'Content-Type': 'application/json',
      })
      ..body = jsonEncode({
        'tool': tool,
        'prompt': prompt,
        'quality': highQuality ? 'depth' : 'fast',
        'locale': prefs.locale.languageCode,
        'creditCost': creditCost,
        if (systemContext != null && systemContext.isNotEmpty)
          'systemContext': systemContext,
        if (fileBytes != null && fileMimeType != null)
          'inlineData': {
            'mimeType': fileMimeType,
            'data': base64Encode(fileBytes),
          },
      });

    final httpClient = http.Client();
    try {
      final response = await httpClient.send(request);
      if (response.statusCode != 200) {
        final body = await response.stream.bytesToString();
        String message = 'AI request failed (${response.statusCode}).';
        try {
          final parsed = jsonDecode(body) as Map<String, dynamic>;
          if (parsed['error'] is String) message = parsed['error'] as String;
        } catch (_) {}
        throw AiGatewayException(message);
      }

      await for (final line in response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (!line.startsWith('data:')) continue;
        final payload = line.substring(5).trim();
        if (payload == '[DONE]') break;
        try {
          final decoded = jsonDecode(payload) as Map<String, dynamic>;
          if (decoded['error'] is String) {
            throw AiGatewayException(decoded['error'] as String);
          }
          final token = decoded['token'] as String?;
          if (token != null && token.isNotEmpty) {
            yield token;
          }
        } catch (e) {
          if (e is AiGatewayException) rethrow;
        }
      }
    } finally {
      httpClient.close();
    }
  }
}

final aiGatewayClientProvider = Provider<AiGatewayClient>((ref) {
  return AiGatewayClient(ref);
});
