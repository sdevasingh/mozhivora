// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appTitle => 'MOZHIVORA';

  @override
  String get tagline => 'એક વર્કસ્પેસ. દરેક કામ. AI સાથે વધુ સ્માર્ટ.';

  @override
  String get navHome => 'હોમ';

  @override
  String get navAsk => 'પૂછો';

  @override
  String get navWriter => 'રાઇટર';

  @override
  String get navDocs => 'PDF અને દસ્તાવેજો';

  @override
  String get navDocumentChat => 'દસ્તાવેજ ચેટ';

  @override
  String get navEmail => 'ઇમેઇલ';

  @override
  String get navNotes => 'નોટ્સ અને અભ્યાસ';

  @override
  String get navTranslator => 'અનુવાદક';

  @override
  String get navVoice => 'વૉઇસ અને મીટિંગ્સ';

  @override
  String get navTasks => 'ટાસ્ક પ્લાનર';

  @override
  String get navTemplates => 'ટેમ્પલેટ્સ';

  @override
  String get navWorkspace => 'વર્કસ્પેસ';

  @override
  String get navSettings => 'સેટિંગ્સ';

  @override
  String get navPricing => 'કિંમત';

  @override
  String get navTools => 'Tools';

  @override
  String get navProfile => 'Profile';

  @override
  String get commandBarHint => 'Ask anything, open a tool, or search files...';

  @override
  String get commandBarShortcut => 'Ctrl+K';

  @override
  String get commandBarEmpty =>
      'Type a tool name or question to jump right in.';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onboardingRoleTitle => 'How will you use MOZHIVORA?';

  @override
  String get onboardingRoleSubtitle =>
      'We\'ll tailor your home screen and templates.';

  @override
  String get roleStudent => 'Student';

  @override
  String get roleStudentDesc =>
      'Summaries, flashcards, quizzes, and exam planning';

  @override
  String get roleProfessional => 'Professional';

  @override
  String get roleProfessionalDesc =>
      'Reports, emails, meeting notes, and document chat';

  @override
  String get roleCreator => 'Creator';

  @override
  String get roleCreatorDesc =>
      'Consistent brand voice, scripts, and social posts';

  @override
  String get roleBusiness => 'Business owner';

  @override
  String get roleBusinessDesc =>
      'Proposals, customer replies, and multilingual outreach';

  @override
  String get onboardingLangTitle => 'Choose your primary language';

  @override
  String get onboardingLangSubtitle =>
      'You can switch languages or use Hinglish anytime.';

  @override
  String get onboardingToolsTitle => 'Pick your top 3 tools';

  @override
  String onboardingToolsSubtitle(int count) {
    return 'Selected: $count of 3';
  }

  @override
  String get actionNext => 'Continue';

  @override
  String get actionBack => 'Back';

  @override
  String get actionFinish => 'Open Workspace';

  @override
  String get actionSkip => 'Skip';

  @override
  String get greetingMorning => 'સુપ્રભાત';

  @override
  String get greetingAfternoon => 'શુભ બપોર';

  @override
  String get greetingEvening => 'શુભ સાંજ';

  @override
  String get modeStudent => 'Student Mode';

  @override
  String get modePro => 'Pro Mode';

  @override
  String get switchMode => 'Switch mode';

  @override
  String creditsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count credits left',
      one: '1 credit left',
      zero: '0 credits left',
    );
    return '$_temp0';
  }

  @override
  String creditsResetOn(String date) {
    return 'Resets on $date';
  }

  @override
  String get quickActions => 'ઝડપી ક્રિયાઓ';

  @override
  String get continueWork => 'Continue where you left off';

  @override
  String get todaysTasks => 'આજના કાર્યો';

  @override
  String get noTasksToday =>
      'No tasks due today. Plan your day or extract tasks from notes.';

  @override
  String get suggestedTemplates => 'Suggested for you';

  @override
  String get timeSavedTitle => 'Weekly time saved';

  @override
  String timeSavedLocked(int remaining) {
    return 'Complete $remaining more AI generations to unlock real time-saved stats.';
  }

  @override
  String get upgradeCardTitle => 'Unlock Document Chat, Voice & Brand Voice';

  @override
  String get upgradeCardSubtitle =>
      'Student from ₹99/mo · Pro from ₹199/mo. Cancel anytime.';

  @override
  String get upgradeAction => 'View plans';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get privacyPromise => 'Your files are never used to train AI models.';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeLight => 'Paper (Light)';

  @override
  String get settingsThemeDark => 'Charcoal (Warm Dark)';

  @override
  String get settingsLanguage => 'Language & Script';

  @override
  String get settingsReducedMotion => 'Reduce motion';

  @override
  String get settingsReducedMotionDesc =>
      'Minimize animations across the workspace';

  @override
  String get settingsWorkspaceMode => 'Workspace mode';

  @override
  String get settingsRerunOnboarding => 'Run onboarding again';

  @override
  String get settingsPrivacyTitle => 'Privacy & Data';

  @override
  String get settingsPrivacyBody =>
      'GDPR & India DPDP Act 2023 compliant. Export or delete your data anytime.';

  @override
  String get toolPhaseReady =>
      'Phase 1 shell ready. Full AI capabilities unlock in upcoming phases.';

  @override
  String get trySamplePrompt => 'Try a sample prompt';

  @override
  String get emptyWorkspaceTitle => 'Your workspace is ready';

  @override
  String get emptyWorkspaceDesc =>
      'Start with Ask Mozhivora, write a draft, or pick a template.';

  @override
  String get authTitle => 'Sign in to MOZHIVORA';

  @override
  String authGuestCarryOver(int remaining) {
    return 'Guest mode: $remaining demo generations carry over when you sign up.';
  }

  @override
  String get authUnconfiguredNotice =>
      'Supabase is not configured in this build. Pass SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define to enable live sign-in.';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authSignUp => 'Sign up';

  @override
  String get authPhoneOtp => 'Phone OTP';

  @override
  String get authMagicLink => 'Magic link';

  @override
  String get authFullName => 'Full name';

  @override
  String get authEmail => 'Email address';

  @override
  String get authPassword => 'Password';

  @override
  String get authPhoneHint => 'Phone number (with country code)';

  @override
  String get authOtpCode => '6-digit OTP';

  @override
  String get authSendMagicLink => 'Send magic link';

  @override
  String get authSendOtp => 'Send OTP';

  @override
  String get authVerifyOtp => 'Verify OTP';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authContinueGoogle => 'Continue with Google';

  @override
  String get authAccountSection => 'Account';

  @override
  String get authSignedOutStatus => 'Using MOZHIVORA as a guest';

  @override
  String get authSignOut => 'Sign out';

  @override
  String get authSignOutAll => 'Sign out of all devices';

  @override
  String get workspaceMemoryTitle => 'Workspace Memory';

  @override
  String get workspaceMemoryDesc =>
      'Opt-in context about your role and writing style injected into AI generations.';

  @override
  String get workspaceMemoryWipe => 'Wipe memory';

  @override
  String get workspaceMemoryWiped => 'Workspace memory cleared.';

  @override
  String creditEstimateLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Est. $count credits',
      one: 'Est. 1 credit',
    );
    return '$_temp0';
  }

  @override
  String get creditConfirmTitle => 'Confirm credit use';

  @override
  String creditConfirmBody(int count) {
    return 'This action will use an estimated $count credits. Continue?';
  }

  @override
  String get creditConfirmContinue => 'Run action';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionSend => 'Send';

  @override
  String get actionGenerate => 'Generate';

  @override
  String get actionTranslate => 'Translate';

  @override
  String get actionCopy => 'Copy';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get aiStreamingLabel => 'Streaming response...';

  @override
  String get aiResultLabel => 'Result';

  @override
  String get aiDepthMode => 'Deep reasoning';

  @override
  String get askBranchChat => 'Branch chat';

  @override
  String get askSubtitle =>
      'Ask anything in English, Hindi, Urdu, or Hinglish.';

  @override
  String get writerTopicLabel => 'What would you like to write about?';

  @override
  String get emailAbSubjects => 'A/B subjects';

  @override
  String get emailContextLabel =>
      'Describe the email or paste the thread to reply to';

  @override
  String get notesSourceLabel => 'Paste chapter text, lecture notes, or topic';

  @override
  String get translatorSourceLabel =>
      'Enter text to translate (auto-detects Hinglish & mixed scripts)';

  @override
  String get docsPickFile => 'Pick PDF, DOCX, TXT, PPTX, or image';

  @override
  String get docsPasteHint => 'Or paste document / OCR text here';

  @override
  String get docChatPassagesLabel =>
      'Document passages (separate pages with ---)';

  @override
  String get docChatQuestionLabel =>
      'Ask a grounded question about your document';

  @override
  String get tasksAddHint => 'Add a task (works offline)';

  @override
  String get tasksAddButton => 'Add';

  @override
  String get tasksPlanMyDay => 'Plan my day with AI';

  @override
  String get voiceSpeakerLabels => 'Speaker labels';

  @override
  String get voiceTranscriptHint => 'Paste meeting transcript or notes';

  @override
  String get voiceToTasks => 'Turn action items into tasks';

  @override
  String get workspaceExportBtn => 'Export JSON';

  @override
  String get workspaceExported => 'Workspace export copied to clipboard.';

  @override
  String get workspaceSearchHint => 'Search workspace items...';

  @override
  String get workspaceTrashToggle => '30-day Trash';

  @override
  String get workspaceShareLink => 'Copy read-only share link';

  @override
  String pricingSelectPlan(String plan) {
    return 'Choose $plan';
  }

  @override
  String get referralTitle => 'Invite friends, earn 50 credits each';

  @override
  String get referralSubtitle =>
      'Share your code so both of you get 50 bonus credits.';
}
