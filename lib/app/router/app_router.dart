import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mozhivora/core/config/app_preferences.dart';
import 'package:mozhivora/features/ai_writer/presentation/writer_screen.dart';
import 'package:mozhivora/features/ask/presentation/ask_screen.dart';
import 'package:mozhivora/features/auth/presentation/auth_screen.dart';
import 'package:mozhivora/features/dashboard/presentation/dashboard_screen.dart';
import 'package:mozhivora/features/document_chat/presentation/document_chat_screen.dart';
import 'package:mozhivora/features/documents/presentation/documents_screen.dart';
import 'package:mozhivora/features/email/presentation/email_screen.dart';
import 'package:mozhivora/features/notes_study/presentation/notes_study_screen.dart';
import 'package:mozhivora/features/onboarding/presentation/onboarding_screen.dart';
import 'package:mozhivora/features/settings/presentation/settings_screen.dart';
import 'package:mozhivora/features/subscription/presentation/pricing_screen.dart';
import 'package:mozhivora/features/task_planner/presentation/task_planner_screen.dart';
import 'package:mozhivora/features/templates/presentation/templates_screen.dart';
import 'package:mozhivora/features/translator/presentation/translator_screen.dart';
import 'package:mozhivora/features/voice/presentation/voice_screen.dart';
import 'package:mozhivora/features/workspace/presentation/workspace_screen.dart';
import 'package:mozhivora/shared/widgets/responsive_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingDone = ref.watch(
    appPreferencesProvider.select((s) => s.onboardingCompleted),
  );

  return GoRouter(
    initialLocation: onboardingDone ? '/' : '/onboarding',
    redirect: (context, state) {
      final isOnboarding = state.matchedLocation == '/onboarding';
      if (!onboardingDone && !isOnboarding) {
        return '/onboarding';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => ResponsiveShell(
          currentRoute: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/ask',
            builder: (context, state) => AskScreen(
              initialPrompt: state.extra as String?,
            ),
          ),
          GoRoute(
            path: '/writer',
            builder: (context, state) => WriterScreen(
              initialTopic: state.extra as String?,
            ),
          ),
          GoRoute(
            path: '/documents',
            builder: (context, state) => const DocumentsScreen(),
          ),
          GoRoute(
            path: '/document-chat',
            builder: (context, state) => const DocumentChatScreen(),
          ),
          GoRoute(
            path: '/email',
            builder: (context, state) => const EmailScreen(),
          ),
          GoRoute(
            path: '/notes',
            builder: (context, state) => const NotesStudyScreen(),
          ),
          GoRoute(
            path: '/translator',
            builder: (context, state) => const TranslatorScreen(),
          ),
          GoRoute(
            path: '/voice',
            builder: (context, state) => const VoiceScreen(),
          ),
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TaskPlannerScreen(),
          ),
          GoRoute(
            path: '/templates',
            builder: (context, state) => const TemplatesScreen(),
          ),
          GoRoute(
            path: '/workspace',
            builder: (context, state) => const WorkspaceScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/pricing',
            builder: (context, state) => const PricingScreen(),
          ),
          GoRoute(
            path: '/auth',
            builder: (context, state) => const AuthScreen(),
          ),
        ],
      ),
    ],
  );
});
