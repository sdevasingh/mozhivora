import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/config/app_preferences.dart';
import 'package:mozhivora/l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  late UserRole _selectedRole;
  late Locale _selectedLocale;
  late List<String> _selectedTools;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(appPreferencesProvider);
    _selectedRole = prefs.role;
    _selectedLocale = prefs.locale;
    _selectedTools = List<String>.from(prefs.topTools);
  }

  void _finish() {
    final notifier = ref.read(appPreferencesProvider.notifier);
    notifier.setRole(_selectedRole);
    notifier.setLocale(_selectedLocale);
    notifier.setTopTools(_selectedTools);
    notifier.completeOnboarding();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.all(MozhiTokens.space24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.appTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: _finish,
                        child: Text(l10n.actionSkip),
                      ),
                    ],
                  ),
                  const SizedBox(height: MozhiTokens.space8),
                  LinearProgressIndicator(
                    value: (_step + 1) / 3,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: MozhiTokens.space8),
                  Text(
                    l10n.onboardingStepOf(_step + 1, 3),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: MozhiTokens.space24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: switch (_step) {
                        0 => _buildRoleStep(l10n, theme),
                        1 => _buildLanguageStep(l10n, theme),
                        _ => _buildToolsStep(l10n, theme),
                      },
                    ),
                  ),
                  const SizedBox(height: MozhiTokens.space16),
                  Row(
                    children: [
                      if (_step > 0)
                        OutlinedButton(
                          onPressed: () => setState(() => _step--),
                          child: Text(l10n.actionBack),
                        ),
                      const Spacer(),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: _step == 2
                              ? MozhiTokens.saffron
                              : theme.colorScheme.primary,
                        ),
                        onPressed: () {
                          if (_step < 2) {
                            setState(() => _step++);
                          } else {
                            _finish();
                          }
                        },
                        child: Text(
                          _step == 2 ? l10n.actionFinish : l10n.actionNext,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleStep(AppLocalizations l10n, ThemeData theme) {
    final roles = [
      (
        UserRole.student,
        l10n.roleStudent,
        l10n.roleStudentDesc,
        Icons.school_outlined
      ),
      (
        UserRole.professional,
        l10n.roleProfessional,
        l10n.roleProfessionalDesc,
        Icons.work_outline
      ),
      (
        UserRole.creator,
        l10n.roleCreator,
        l10n.roleCreatorDesc,
        Icons.auto_fix_high_outlined
      ),
      (
        UserRole.business,
        l10n.roleBusiness,
        l10n.roleBusinessDesc,
        Icons.storefront_outlined
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.onboardingRoleTitle, style: theme.textTheme.headlineMedium),
        const SizedBox(height: MozhiTokens.space8),
        Text(l10n.onboardingRoleSubtitle, style: theme.textTheme.bodyMedium),
        const SizedBox(height: MozhiTokens.space24),
        ...roles.map((r) {
          final selected = _selectedRole == r.$1;
          return Padding(
            padding: const EdgeInsets.only(bottom: MozhiTokens.space12),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MozhiTokens.radiusCard),
                side: BorderSide(
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: selected ? 2 : 1,
                ),
              ),
              child: ListTile(
                leading: Icon(r.$4, color: theme.colorScheme.primary),
                title: Text(r.$2,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(r.$3),
                trailing: selected
                    ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                    : null,
                onTap: () => setState(() => _selectedRole = r.$1),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLanguageStep(AppLocalizations l10n, ThemeData theme) {
    final languages = [
      (const Locale('en'), 'English', 'Latin · LTR'),
      (const Locale('hi'), 'हिन्दी (Hindi)', 'Devanagari · LTR'),
      (const Locale('ur'), 'اردو (Urdu)', 'Nastaliq · RTL'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.onboardingLangTitle, style: theme.textTheme.headlineMedium),
        const SizedBox(height: MozhiTokens.space8),
        Text(l10n.onboardingLangSubtitle, style: theme.textTheme.bodyMedium),
        const SizedBox(height: MozhiTokens.space24),
        ...languages.map((lang) {
          final selected = _selectedLocale.languageCode == lang.$1.languageCode;
          return Padding(
            padding: const EdgeInsets.only(bottom: MozhiTokens.space12),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MozhiTokens.radiusCard),
                side: BorderSide(
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: selected ? 2 : 1,
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.translate_outlined),
                title: Text(lang.$2,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(lang.$3),
                trailing: selected
                    ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                    : null,
                onTap: () {
                  setState(() => _selectedLocale = lang.$1);
                  ref.read(appPreferencesProvider.notifier).setLocale(lang.$1);
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildToolsStep(AppLocalizations l10n, ThemeData theme) {
    final tools = [
      ('ask', l10n.navAsk, Icons.auto_awesome_outlined),
      ('writer', l10n.navWriter, Icons.edit_note_outlined),
      ('documents', l10n.navDocs, Icons.description_outlined),
      ('notes', l10n.navNotes, Icons.school_outlined),
      ('translator', l10n.navTranslator, Icons.translate_outlined),
      ('email', l10n.navEmail, Icons.mail_outline),
      ('voice', l10n.navVoice, Icons.mic_none_outlined),
      ('tasks', l10n.navTasks, Icons.check_circle_outline),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.onboardingToolsTitle, style: theme.textTheme.headlineMedium),
        const SizedBox(height: MozhiTokens.space8),
        Text(
          l10n.onboardingToolsSubtitle(_selectedTools.length),
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: MozhiTokens.space24),
        Wrap(
          spacing: MozhiTokens.space12,
          runSpacing: MozhiTokens.space12,
          children: tools.map((tool) {
            final isSelected = _selectedTools.contains(tool.$1);
            return FilterChip(
              avatar: Icon(tool.$3, size: 18),
              label: Text(tool.$2),
              selected: isSelected,
              onSelected: (checked) {
                setState(() {
                  if (checked) {
                    if (_selectedTools.length < 3) {
                      _selectedTools.add(tool.$1);
                    }
                  } else {
                    _selectedTools.remove(tool.$1);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
