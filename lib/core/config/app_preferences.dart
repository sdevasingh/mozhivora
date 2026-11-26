import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { student, professional, creator, business }

enum WorkspaceMode { student, pro }

class AppPreferencesState {
  const AppPreferencesState({
    required this.locale,
    required this.themeMode,
    required this.reducedMotion,
    required this.role,
    required this.workspaceMode,
    required this.topTools,
    required this.onboardingCompleted,
    required this.upgradeCardDismissed,
    required this.creditsRemaining,
    required this.creditsTotal,
    required this.generationCount,
  });

  final Locale locale;
  final ThemeMode themeMode;
  final bool reducedMotion;
  final UserRole role;
  final WorkspaceMode workspaceMode;
  final List<String> topTools;
  final bool onboardingCompleted;
  final bool upgradeCardDismissed;
  final int creditsRemaining;
  final int creditsTotal;
  final int generationCount;

  AppPreferencesState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? reducedMotion,
    UserRole? role,
    WorkspaceMode? workspaceMode,
    List<String>? topTools,
    bool? onboardingCompleted,
    bool? upgradeCardDismissed,
    int? creditsRemaining,
    int? creditsTotal,
    int? generationCount,
  }) {
    return AppPreferencesState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      role: role ?? this.role,
      workspaceMode: workspaceMode ?? this.workspaceMode,
      topTools: topTools ?? this.topTools,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      upgradeCardDismissed: upgradeCardDismissed ?? this.upgradeCardDismissed,
      creditsRemaining: creditsRemaining ?? this.creditsRemaining,
      creditsTotal: creditsTotal ?? this.creditsTotal,
      generationCount: generationCount ?? this.generationCount,
    );
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

class AppPreferencesNotifier extends StateNotifier<AppPreferencesState> {
  AppPreferencesNotifier(this._prefs)
      : super(
          AppPreferencesState(
            locale: Locale(_prefs?.getString('locale') ?? 'en'),
            themeMode: (_prefs?.getBool('darkMode') ?? true)
                ? ThemeMode.dark
                : ThemeMode.light,
            reducedMotion: _prefs?.getBool('reducedMotion') ?? false,
            role: UserRole.values.firstWhere(
              (r) => r.name == (_prefs?.getString('role') ?? 'student'),
              orElse: () => UserRole.student,
            ),
            workspaceMode: WorkspaceMode.values.firstWhere(
              (m) =>
                  m.name == (_prefs?.getString('workspaceMode') ?? 'student'),
              orElse: () => WorkspaceMode.student,
            ),
            topTools: _prefs?.getStringList('topTools') ??
                const ['ask', 'writer', 'notes'],
            onboardingCompleted:
                _prefs?.getBool('onboardingCompleted') ?? false,
            upgradeCardDismissed: false,
            creditsRemaining: 15,
            creditsTotal: 15,
            generationCount: 0,
          ),
        );

  final SharedPreferences? _prefs;

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
    _prefs?.setString('locale', locale.languageCode);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _prefs?.setBool('darkMode', mode == ThemeMode.dark);
  }

  void setReducedMotion(bool value) {
    state = state.copyWith(reducedMotion: value);
    _prefs?.setBool('reducedMotion', value);
  }

  void setRole(UserRole role) {
    final defaultMode =
        role == UserRole.student ? WorkspaceMode.student : WorkspaceMode.pro;
    state = state.copyWith(role: role, workspaceMode: defaultMode);
    _prefs?.setString('role', role.name);
    _prefs?.setString('workspaceMode', defaultMode.name);
  }

  void setWorkspaceMode(WorkspaceMode mode) {
    state = state.copyWith(workspaceMode: mode);
    _prefs?.setString('workspaceMode', mode.name);
  }

  void setTopTools(List<String> tools) {
    state = state.copyWith(topTools: tools);
    _prefs?.setStringList('topTools', tools);
  }

  void completeOnboarding() {
    state = state.copyWith(onboardingCompleted: true);
    _prefs?.setBool('onboardingCompleted', true);
  }

  void resetOnboarding() {
    state = state.copyWith(onboardingCompleted: false);
    _prefs?.setBool('onboardingCompleted', false);
  }

  void dismissUpgradeCard() {
    state = state.copyWith(upgradeCardDismissed: true);
  }
}

final appPreferencesProvider =
    StateNotifierProvider<AppPreferencesNotifier, AppPreferencesState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppPreferencesNotifier(prefs);
});
