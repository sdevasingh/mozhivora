import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/core/config/app_preferences.dart';
import 'package:mozhivora/core/config/supabase_config.dart';
import 'package:mozhivora/core/sync/offline_sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandVoiceKit {
  const BrandVoiceKit({
    required this.id,
    required this.name,
    required this.toneSummary,
    required this.samples,
  });

  final String id;
  final String name;
  final String toneSummary;
  final List<String> samples;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'toneSummary': toneSummary,
        'samples': samples,
      };

  factory BrandVoiceKit.fromJson(Map<String, dynamic> json) => BrandVoiceKit(
        id: json['id'] as String,
        name: json['name'] as String,
        toneSummary: json['toneSummary'] as String,
        samples: (json['samples'] as List<dynamic>).cast<String>(),
      );
}

class BrandVoiceNotifier extends StateNotifier<List<BrandVoiceKit>> {
  BrandVoiceNotifier(this._prefs) : super(_load(_prefs));

  final SharedPreferences? _prefs;
  static const _key = 'brand_voice_kits_v1';

  static List<BrandVoiceKit> _load(SharedPreferences? prefs) {
    final raw = prefs?.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => BrandVoiceKit.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addKit({
    required String name,
    required String toneSummary,
    required List<String> samples,
  }) async {
    final kit = BrandVoiceKit(
      id: OfflineIdGenerator.newUuid(),
      name: name.trim(),
      toneSummary: toneSummary.trim(),
      samples: samples.where((s) => s.trim().isNotEmpty).toList(),
    );
    final next = [kit, ...state];
    state = next;
    await _prefs?.setString(
      _key,
      jsonEncode(next.map((k) => k.toJson()).toList()),
    );

    final client = SupabaseConfig.clientOrNull;
    final userId = client?.auth.currentUser?.id;
    if (client != null && userId != null) {
      await client.from('brand_voices').upsert({
        'id': kit.id,
        'user_id': userId,
        'name': kit.name,
        'tone_summary': kit.toneSummary,
        'samples': kit.samples,
      });
    }
  }

  Future<void> deleteKit(String id) async {
    final next = state.where((k) => k.id != id).toList();
    state = next;
    await _prefs?.setString(
      _key,
      jsonEncode(next.map((k) => k.toJson()).toList()),
    );
  }
}

final brandVoiceProvider =
    StateNotifierProvider<BrandVoiceNotifier, List<BrandVoiceKit>>((ref) {
  return BrandVoiceNotifier(ref.watch(sharedPreferencesProvider));
});
