import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/l10n/app_localizations.dart';

class TemplateItem {
  const TemplateItem({
    required this.title,
    required this.category,
    required this.role,
    required this.prompt,
  });

  final String title;
  final String category;
  final String role;
  final String prompt;
}

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  String _selectedRole = 'All';

  static const _templates = [
    TemplateItem(
      title: 'Chapter Revision Notes',
      category: 'Study',
      role: 'Student',
      prompt: 'Create structured revision notes and 5 practice questions for: ',
    ),
    TemplateItem(
      title: 'Exam Countdown Plan',
      category: 'Study',
      role: 'Student',
      prompt: 'Build a 14-day revision schedule for my upcoming exam on: ',
    ),
    TemplateItem(
      title: 'Weekly Executive Update',
      category: 'Reports',
      role: 'Professional',
      prompt:
          'Write a concise weekly status update covering wins, blockers, and next steps for: ',
    ),
    TemplateItem(
      title: 'Client Proposal Outline',
      category: 'Business',
      role: 'Business',
      prompt:
          'Draft a clear project proposal with scope, timeline, and pricing table for: ',
    ),
    TemplateItem(
      title: 'YouTube / Reel Script',
      category: 'Creator',
      role: 'Creator',
      prompt:
          'Write a 60-second engaging video script with hook, body, and CTA about: ',
    ),
    TemplateItem(
      title: 'Multilingual Customer Reply',
      category: 'Outreach',
      role: 'Business',
      prompt:
          'Write a polite customer support reply in Hindi and English regarding: ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final filtered = _selectedRole == 'All'
        ? _templates
        : _templates.where((t) => t.role == _selectedRole).toList();

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Text(
          l10n.navTemplates,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: MozhiTokens.space12),
        Wrap(
          spacing: MozhiTokens.space8,
          children: ['All', 'Student', 'Professional', 'Creator', 'Business']
              .map(
                (role) => ChoiceChip(
                  label: Text(role),
                  selected: _selectedRole == role,
                  onSelected: (_) => setState(() => _selectedRole = role),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: MozhiTokens.space16),
        ...filtered.map(
          (t) => Padding(
            padding: const EdgeInsets.only(bottom: MozhiTokens.space12),
            child: Card(
              child: ListTile(
                title: Text(t.title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${t.category} · ${t.role}'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => context.go('/writer', extra: t.prompt),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
