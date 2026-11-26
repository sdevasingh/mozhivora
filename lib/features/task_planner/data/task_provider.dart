import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mozhivora/core/config/app_preferences.dart';
import 'package:mozhivora/core/config/supabase_config.dart';
import 'package:mozhivora/core/sync/offline_sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TaskPriority { low, medium, high }

enum TaskStatus { todo, inProgress, done }

class MozhiTask {
  const MozhiTask({
    required this.id,
    required this.title,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    required this.updatedAt,
    this.synced = false,
  });

  final String id;
  final String title;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime updatedAt;
  final bool synced;

  MozhiTask copyWith({
    String? title,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return MozhiTask(
      id: id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'priority': priority.name,
        'status': status.name,
        'updatedAt': updatedAt.toIso8601String(),
        'synced': synced,
      };

  factory MozhiTask.fromJson(Map<String, dynamic> json) => MozhiTask(
        id: json['id'] as String,
        title: json['title'] as String,
        priority: TaskPriority.values.firstWhere(
          (p) => p.name == json['priority'],
          orElse: () => TaskPriority.medium,
        ),
        status: TaskStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => TaskStatus.todo,
        ),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now(),
        synced: json['synced'] as bool? ?? false,
      );
}

class TaskNotifier extends StateNotifier<List<MozhiTask>> {
  TaskNotifier(this._prefs) : super(_load(_prefs));

  final SharedPreferences? _prefs;
  static const _storageKey = 'offline_tasks_v1';

  static List<MozhiTask> _load(SharedPreferences? prefs) {
    final raw = prefs?.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => MozhiTask.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _persistAndSync(List<MozhiTask> next) async {
    state = next;
    await _prefs?.setString(
      _storageKey,
      jsonEncode(next.map((t) => t.toJson()).toList()),
    );

    final client = SupabaseConfig.clientOrNull;
    final userId = client?.auth.currentUser?.id;
    if (client != null && userId != null) {
      for (final t in next.where((t) => !t.synced)) {
        await client.from('tasks').upsert({
          'id': t.id,
          'user_id': userId,
          'title': t.title,
          'priority': t.priority.name,
          'status':
              t.status == TaskStatus.inProgress ? 'in_progress' : t.status.name,
        });
      }
    }
  }

  Future<void> addTask(String title,
      {TaskPriority priority = TaskPriority.medium}) async {
    final clean = title.trim();
    if (clean.isEmpty) return;
    final task = MozhiTask(
      id: OfflineIdGenerator.newUuid(),
      title: clean,
      priority: priority,
      updatedAt: DateTime.now(),
    );
    await _persistAndSync([task, ...state]);
  }

  Future<void> toggleDone(String id) async {
    final next = state.map((t) {
      if (t.id != id) return t;
      final nextStatus =
          t.status == TaskStatus.done ? TaskStatus.todo : TaskStatus.done;
      return t.copyWith(
        status: nextStatus,
        updatedAt: DateTime.now(),
        synced: false,
      );
    }).toList();
    await _persistAndSync(next);
  }

  Future<void> deleteTask(String id) async {
    await _persistAndSync(state.where((t) => t.id != id).toList());
  }
}

final taskListProvider =
    StateNotifierProvider<TaskNotifier, List<MozhiTask>>((ref) {
  return TaskNotifier(ref.watch(sharedPreferencesProvider));
});
