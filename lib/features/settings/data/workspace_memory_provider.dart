import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/core/config/app_preferences.dart';
import 'package:mozhivora/core/config/supabase_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkspaceMemoryState {
  const WorkspaceMemoryState({
    required this.enabled,
    required this.aboutMe,
    required this.businessContext,
    required this.preferredStyle,
  });

  final bool enabled;
  final String aboutMe;
  final String businessContext;
  final String preferredStyle;

  WorkspaceMemoryState copyWith({
    bool? enabled,
    String? aboutMe,
    String? businessContext,
    String? preferredStyle,
  }) {
    return WorkspaceMemoryState(
      enabled: enabled ?? this.enabled,
      aboutMe: aboutMe ?? this.aboutMe,
      businessContext: businessContext ?? this.businessContext,
      preferredStyle: preferredStyle ?? this.preferredStyle,
    );
  }
}

class WorkspaceMemoryNotifier extends StateNotifier<WorkspaceMemoryState> {
  WorkspaceMemoryNotifier(this._prefs)
      : super(
          WorkspaceMemoryState(
            enabled: _prefs?.getBool('wm_enabled') ?? false,
            aboutMe: _prefs?.getString('wm_about') ?? '',
            businessContext: _prefs?.getString('wm_business') ?? '',
            preferredStyle: _prefs?.getString('wm_style') ?? '',
          ),
        );

  final SharedPreferences? _prefs;

  Future<void> update({
    bool? enabled,
    String? aboutMe,
    String? businessContext,
    String? preferredStyle,
  }) async {
    final next = state.copyWith(
      enabled: enabled,
      aboutMe: aboutMe,
      businessContext: businessContext,
      preferredStyle: preferredStyle,
    );
    state = next;

    _prefs?.setBool('wm_enabled', next.enabled);
    _prefs?.setString('wm_about', next.aboutMe);
    _prefs?.setString('wm_business', next.businessContext);
    _prefs?.setString('wm_style', next.preferredStyle);

    final client = SupabaseConfig.clientOrNull;
    final userId = client?.auth.currentUser?.id;
    if (client != null && userId != null) {
      await client.from('workspace_memory').upsert({
        'user_id': userId,
        'enabled': next.enabled,
        'about_me': next.aboutMe,
        'business_context': next.businessContext,
        'preferred_style': next.preferredStyle,
      });
    }
  }

  Future<void> wipeAll() => update(
        enabled: false,
        aboutMe: '',
        businessContext: '',
        preferredStyle: '',
      );
}

final workspaceMemoryProvider =
    StateNotifierProvider<WorkspaceMemoryNotifier, WorkspaceMemoryState>((ref) {
  return WorkspaceMemoryNotifier(ref.watch(sharedPreferencesProvider));
});
