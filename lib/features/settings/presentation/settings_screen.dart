import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/config/app_preferences.dart';
import 'package:mozhivora/features/auth/data/supabase_auth_repository.dart';
import 'package:mozhivora/features/settings/data/workspace_memory_provider.dart';
import 'package:mozhivora/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final prefs = ref.watch(appPreferencesProvider);
    final notifier = ref.read(appPreferencesProvider.notifier);
    final auth = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final memory = ref.watch(workspaceMemoryProvider);
    final memoryNotifier = ref.read(workspaceMemoryProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Text(l10n.navSettings, style: theme.textTheme.headlineMedium),
        const SizedBox(height: MozhiTokens.space24),

        // Account Section
        Text(l10n.authAccountSection, style: theme.textTheme.titleMedium),
        const SizedBox(height: MozhiTokens.space8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(MozhiTokens.space16),
            child: auth.isSignedIn
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auth.account?.email ?? auth.account?.phone ?? '',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: MozhiTokens.space12),
                      Wrap(
                        spacing: MozhiTokens.space8,
                        children: [
                          OutlinedButton(
                            onPressed: () => authNotifier.signOut(),
                            child: Text(l10n.authSignOut),
                          ),
                          TextButton(
                            onPressed: () =>
                                authNotifier.signOut(allDevices: true),
                            child: Text(l10n.authSignOutAll),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(l10n.authSignedOutStatus)),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: MozhiTokens.saffron,
                        ),
                        onPressed: () => context.go('/auth'),
                        child: Text(l10n.authSignIn),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: MozhiTokens.space24),

        // Workspace Memory
        Text(l10n.workspaceMemoryTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: MozhiTokens.space8),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: Text(l10n.workspaceMemoryTitle),
                subtitle: Text(l10n.workspaceMemoryDesc),
                value: memory.enabled,
                onChanged: (v) => memoryNotifier.update(enabled: v),
              ),
              const Divider(),
              ListTile(
                leading:
                    Icon(Icons.delete_outline, color: theme.colorScheme.error),
                title: Text(l10n.workspaceMemoryWipe),
                onTap: () async {
                  await memoryNotifier.wipeAll();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.workspaceMemoryWiped)),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: MozhiTokens.space24),

        // Language & Script (11 Tier 1 languages including RTL Urdu)
        Text(l10n.settingsLanguage, style: theme.textTheme.titleMedium),
        const SizedBox(height: MozhiTokens.space8),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: MozhiTokens.space16,
              vertical: MozhiTokens.space8,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: prefs.locale.languageCode,
                items: const [
                  DropdownMenuItem(
                      value: 'en', child: Text('English (Latin · LTR)')),
                  DropdownMenuItem(
                      value: 'hi',
                      child: Text('हिन्दी — Hindi (Devanagari · LTR)')),
                  DropdownMenuItem(
                      value: 'ur', child: Text('اردو — Urdu (Nastaliq · RTL)')),
                  DropdownMenuItem(value: 'ta', child: Text('தமிழ் — Tamil')),
                  DropdownMenuItem(value: 'te', child: Text('తెలుగు — Telugu')),
                  DropdownMenuItem(value: 'bn', child: Text('বাংলা — Bengali')),
                  DropdownMenuItem(value: 'mr', child: Text('मराठी — Marathi')),
                  DropdownMenuItem(value: 'kn', child: Text('ಕನ್ನಡ — Kannada')),
                  DropdownMenuItem(
                      value: 'ml', child: Text('മലയാളം — Malayalam')),
                  DropdownMenuItem(
                      value: 'gu', child: Text('ગુજરાતી — Gujarati')),
                  DropdownMenuItem(
                      value: 'pa', child: Text('ਪੰਜਾਬੀ — Punjabi')),
                ],
                onChanged: (v) {
                  if (v != null) notifier.setLocale(Locale(v));
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: MozhiTokens.space24),

        // Appearance
        Text(l10n.settingsAppearance, style: theme.textTheme.titleMedium),
        const SizedBox(height: MozhiTokens.space8),
        Card(
          child: Column(
            children: [
              RadioListTile<ThemeMode>(
                title: Text(l10n.settingsThemeLight),
                value: ThemeMode.light,
                groupValue: prefs.themeMode,
                onChanged: (v) => notifier.setThemeMode(v!),
              ),
              const Divider(),
              RadioListTile<ThemeMode>(
                title: Text(l10n.settingsThemeDark),
                value: ThemeMode.dark,
                groupValue: prefs.themeMode,
                onChanged: (v) => notifier.setThemeMode(v!),
              ),
              const Divider(),
              SwitchListTile(
                title: Text(l10n.settingsReducedMotion),
                subtitle: Text(l10n.settingsReducedMotionDesc),
                value: prefs.reducedMotion,
                onChanged: notifier.setReducedMotion,
              ),
            ],
          ),
        ),
        const SizedBox(height: MozhiTokens.space24),

        // Re-run Onboarding
        Card(
          child: ListTile(
            leading: const Icon(Icons.restart_alt),
            title: Text(l10n.settingsRerunOnboarding),
            onTap: () {
              notifier.resetOnboarding();
              context.go('/onboarding');
            },
          ),
        ),
        const SizedBox(height: MozhiTokens.space24),

        // Privacy
        Card(
          child: Padding(
            padding: const EdgeInsets.all(MozhiTokens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settingsPrivacyTitle,
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: MozhiTokens.space4),
                Text(l10n.settingsPrivacyBody,
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
