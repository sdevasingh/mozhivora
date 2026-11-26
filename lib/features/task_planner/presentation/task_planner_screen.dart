import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/app/theme/tokens.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/features/task_planner/data/task_provider.dart';
import 'package:mozhivora/l10n/app_localizations.dart';
import 'package:mozhivora/shared/widgets/ai_output_card.dart';
import 'package:mozhivora/shared/widgets/credit_estimate_dialog.dart';

class TaskPlannerScreen extends ConsumerStatefulWidget {
  const TaskPlannerScreen({super.key});

  @override
  ConsumerState<TaskPlannerScreen> createState() => _TaskPlannerScreenState();
}

class _TaskPlannerScreenState extends ConsumerState<TaskPlannerScreen> {
  final _taskCtrl = TextEditingController();
  String _view = 'List';
  String _planOutput = '';
  bool _isStreaming = false;
  String? _error;
  bool _isConfigError = false;

  @override
  void dispose() {
    _taskCtrl.dispose();
    super.dispose();
  }

  Future<void> _planMyDay(List<MozhiTask> tasks) async {
    if (tasks.isEmpty || _isStreaming) return;
    final open = tasks
        .where((t) => t.status != TaskStatus.done)
        .map((t) => t.title)
        .join(', ');
    final prompt = 'Prioritize and time-block these tasks for today:\n$open';
    final est = AiGatewayClient.estimateCredits(prompt: prompt);
    if (!await confirmCreditCostIfNeeded(context, estimatedCredits: est) ||
        !mounted) {
      return;
    }

    setState(() {
      _planOutput = '';
      _isStreaming = true;
      _error = null;
      _isConfigError = false;
    });
    try {
      await for (final tok
          in ref.read(aiGatewayClientProvider).streamCompletion(
                tool: 'ask',
                prompt: prompt,
              )) {
        if (!mounted) return;
        setState(() => _planOutput += tok);
      }
    } on AiGatewayException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isConfigError = e.isConfigError;
      });
    } finally {
      if (mounted) setState(() => _isStreaming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tasks = ref.watch(taskListProvider);
    final notifier = ref.read(taskListProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(MozhiTokens.space24),
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: MozhiTokens.space12,
          children: [
            Text(
              l10n.navTasks,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'List', label: Text('List')),
                ButtonSegment(value: 'Board', label: Text('Board')),
              ],
              selected: {_view},
              onSelectionChanged: (s) => setState(() => _view = s.first),
            ),
          ],
        ),
        const SizedBox(height: MozhiTokens.space16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _taskCtrl,
                decoration: InputDecoration(labelText: l10n.tasksAddHint),
                onSubmitted: (v) {
                  notifier.addTask(v);
                  _taskCtrl.clear();
                },
              ),
            ),
            const SizedBox(width: MozhiTokens.space8),
            FilledButton(
              style:
                  FilledButton.styleFrom(backgroundColor: MozhiTokens.saffron),
              onPressed: () {
                notifier.addTask(_taskCtrl.text);
                _taskCtrl.clear();
              },
              child: Text(l10n.tasksAddButton),
            ),
          ],
        ),
        const SizedBox(height: MozhiTokens.space12),
        if (tasks.isNotEmpty)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              onPressed: _isStreaming ? null : () => _planMyDay(tasks),
              icon: const Icon(Icons.auto_awesome_outlined),
              label: Text(l10n.tasksPlanMyDay),
            ),
          ),
        const SizedBox(height: MozhiTokens.space16),
        if (tasks.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(MozhiTokens.space24),
              child: Text(l10n.noTasksToday),
            ),
          )
        else
          ...tasks.map(
            (t) => Card(
              margin: const EdgeInsets.only(bottom: MozhiTokens.space8),
              child: CheckboxListTile(
                value: t.status == TaskStatus.done,
                onChanged: (_) => notifier.toggleDone(t.id),
                title: Text(
                  t.title,
                  style: TextStyle(
                    decoration: t.status == TaskStatus.done
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: Text('${t.priority.name} · offline-ready'),
                secondary: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => notifier.deleteTask(t.id),
                ),
              ),
            ),
          ),
        const SizedBox(height: MozhiTokens.space16),
        AiOutputCard(
          output: _planOutput,
          isStreaming: _isStreaming,
          errorMessage: _error,
          isConfigError: _isConfigError,
        ),
      ],
    );
  }
}
