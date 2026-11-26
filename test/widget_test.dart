import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mozhivora/app/app.dart';
import 'package:mozhivora/core/ai/ai_gateway_client.dart';
import 'package:mozhivora/core/config/app_preferences.dart';
import 'package:mozhivora/core/sync/offline_sync_service.dart';
import 'package:mozhivora/features/notes_study/presentation/notes_study_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Onboarding completes and opens personalized dashboard',
      (tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MozhivoraApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('How will you use MOZHIVORA?'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Choose your primary language'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Pick your top 3 tools'), findsOneWidget);
    await tester.tap(find.text('Open Workspace'));
    await tester.pumpAndSettle();

    expect(find.text('Quick actions'), findsOneWidget);
    expect(find.text('15 credits left'), findsOneWidget);
  });

  testWidgets('Switching to Urdu enables RTL Directionality', (tester) async {
    SharedPreferences.setMockInitialValues({'onboardingCompleted': true});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MozhivoraApp(),
      ),
    );
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(MozhivoraApp)),
    );
    container
        .read(appPreferencesProvider.notifier)
        .setLocale(const Locale('ur'));
    await tester.pumpAndSettle();

    final dir = Directionality.of(tester.element(find.text('فوری اقدامات')));
    expect(dir, TextDirection.rtl);
  });

  testWidgets('Switching to Hindi renders Devanagari localized UI',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboardingCompleted': true});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MozhivoraApp(),
      ),
    );
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(MozhivoraApp)),
    );
    container
        .read(appPreferencesProvider.notifier)
        .setLocale(const Locale('hi'));
    await tester.pumpAndSettle();

    expect(find.text('त्वरित कार्य'), findsOneWidget);
  });

  testWidgets('Settings navigates to Auth screen with Phone OTP & Magic link',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboardingCompleted': true});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MozhivoraApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Workspace Memory'), findsAtLeastNWidgets(1));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in to MOZHIVORA'), findsOneWidget);
    expect(find.text('Phone OTP'), findsOneWidget);
    expect(find.text('Magic link'), findsOneWidget);
  });

  test('AiGatewayClient estimates credit cost transparently', () {
    expect(AiGatewayClient.estimateCredits(prompt: 'Hello'), 1);
    expect(
        AiGatewayClient.estimateCredits(prompt: 'Hello', highQuality: true), 2);
    expect(
        AiGatewayClient.estimateCredits(prompt: 'a' * 4500, highQuality: true),
        3);
  });

  testWidgets('Ask Mozhivora displays transparent credit estimate pill',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboardingCompleted': true});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MozhivoraApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ask').first);
    await tester.pumpAndSettle();

    expect(find.text('Est. 1 credit'), findsOneWidget);
  });

  test('OfflineIdGenerator generates unique deterministic UUID v4 strings', () {
    final ids = List.generate(50, (_) => OfflineIdGenerator.newUuid()).toSet();
    expect(ids.length, 50);
    expect(ids.first.length, 36);
  });

  testWidgets('Task Planner supports offline task creation & completion',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboardingCompleted': true});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MozhivoraApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text("Today's tasks"),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text("Today's tasks"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Today's tasks"));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Revise Biology Ch 4');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Revise Biology Ch 4'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(find.byType(Checkbox).first).value, isTrue);
  });

  testWidgets('Tamil locale renders native script UI', (tester) async {
    SharedPreferences.setMockInitialValues({'onboardingCompleted': true});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MozhivoraApp(),
      ),
    );
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(MozhivoraApp)),
    );
    container
        .read(appPreferencesProvider.notifier)
        .setLocale(const Locale('ta'));
    await tester.pumpAndSettle();

    expect(find.text('விரைவு செயல்கள்'), findsOneWidget);
  });

  test('Sm2Flashcard schedules increasing intervals on Good/Easy review', () {
    final card = Sm2Flashcard(front: 'Q', back: 'A');
    expect(card.intervalDays, 1);
    card.review(4);
    expect(card.intervalDays, 3);
    card.review(5);
    expect(card.intervalDays, greaterThan(3));
  });
}
