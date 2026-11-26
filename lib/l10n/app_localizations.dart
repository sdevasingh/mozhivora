import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
    Locale('ur')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MOZHIVORA'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'One workspace. Every task. Smarter with AI.'**
  String get tagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get navAsk;

  /// No description provided for @navWriter.
  ///
  /// In en, this message translates to:
  /// **'Writer'**
  String get navWriter;

  /// No description provided for @navDocs.
  ///
  /// In en, this message translates to:
  /// **'PDF & Docs'**
  String get navDocs;

  /// No description provided for @navDocumentChat.
  ///
  /// In en, this message translates to:
  /// **'Document Chat'**
  String get navDocumentChat;

  /// No description provided for @navEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get navEmail;

  /// No description provided for @navNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes & Study'**
  String get navNotes;

  /// No description provided for @navTranslator.
  ///
  /// In en, this message translates to:
  /// **'Translator'**
  String get navTranslator;

  /// No description provided for @navVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice & Meetings'**
  String get navVoice;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Task Planner'**
  String get navTasks;

  /// No description provided for @navTemplates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get navTemplates;

  /// No description provided for @navWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get navWorkspace;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get navPricing;

  /// No description provided for @navTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get navTools;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @commandBarHint.
  ///
  /// In en, this message translates to:
  /// **'Ask anything, open a tool, or search files...'**
  String get commandBarHint;

  /// No description provided for @commandBarShortcut.
  ///
  /// In en, this message translates to:
  /// **'Ctrl+K'**
  String get commandBarShortcut;

  /// No description provided for @commandBarEmpty.
  ///
  /// In en, this message translates to:
  /// **'Type a tool name or question to jump right in.'**
  String get commandBarEmpty;

  /// No description provided for @onboardingStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepOf(int current, int total);

  /// No description provided for @onboardingRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'How will you use MOZHIVORA?'**
  String get onboardingRoleTitle;

  /// No description provided for @onboardingRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tailor your home screen and templates.'**
  String get onboardingRoleSubtitle;

  /// No description provided for @roleStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get roleStudent;

  /// No description provided for @roleStudentDesc.
  ///
  /// In en, this message translates to:
  /// **'Summaries, flashcards, quizzes, and exam planning'**
  String get roleStudentDesc;

  /// No description provided for @roleProfessional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get roleProfessional;

  /// No description provided for @roleProfessionalDesc.
  ///
  /// In en, this message translates to:
  /// **'Reports, emails, meeting notes, and document chat'**
  String get roleProfessionalDesc;

  /// No description provided for @roleCreator.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get roleCreator;

  /// No description provided for @roleCreatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Consistent brand voice, scripts, and social posts'**
  String get roleCreatorDesc;

  /// No description provided for @roleBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business owner'**
  String get roleBusiness;

  /// No description provided for @roleBusinessDesc.
  ///
  /// In en, this message translates to:
  /// **'Proposals, customer replies, and multilingual outreach'**
  String get roleBusinessDesc;

  /// No description provided for @onboardingLangTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your primary language'**
  String get onboardingLangTitle;

  /// No description provided for @onboardingLangSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can switch languages or use Hinglish anytime.'**
  String get onboardingLangSubtitle;

  /// No description provided for @onboardingToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your top 3 tools'**
  String get onboardingToolsTitle;

  /// No description provided for @onboardingToolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Selected: {count} of 3'**
  String onboardingToolsSubtitle(int count);

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionNext;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionFinish.
  ///
  /// In en, this message translates to:
  /// **'Open Workspace'**
  String get actionFinish;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @modeStudent.
  ///
  /// In en, this message translates to:
  /// **'Student Mode'**
  String get modeStudent;

  /// No description provided for @modePro.
  ///
  /// In en, this message translates to:
  /// **'Pro Mode'**
  String get modePro;

  /// No description provided for @switchMode.
  ///
  /// In en, this message translates to:
  /// **'Switch mode'**
  String get switchMode;

  /// No description provided for @creditsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 credits left} =1{1 credit left} other{{count} credits left}}'**
  String creditsRemaining(int count);

  /// No description provided for @creditsResetOn.
  ///
  /// In en, this message translates to:
  /// **'Resets on {date}'**
  String creditsResetOn(String date);

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @continueWork.
  ///
  /// In en, this message translates to:
  /// **'Continue where you left off'**
  String get continueWork;

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tasks'**
  String get todaysTasks;

  /// No description provided for @noTasksToday.
  ///
  /// In en, this message translates to:
  /// **'No tasks due today. Plan your day or extract tasks from notes.'**
  String get noTasksToday;

  /// No description provided for @suggestedTemplates.
  ///
  /// In en, this message translates to:
  /// **'Suggested for you'**
  String get suggestedTemplates;

  /// No description provided for @timeSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly time saved'**
  String get timeSavedTitle;

  /// No description provided for @timeSavedLocked.
  ///
  /// In en, this message translates to:
  /// **'Complete {remaining} more AI generations to unlock real time-saved stats.'**
  String timeSavedLocked(int remaining);

  /// No description provided for @upgradeCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Document Chat, Voice & Brand Voice'**
  String get upgradeCardTitle;

  /// No description provided for @upgradeCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Student from ₹99/mo · Pro from ₹199/mo. Cancel anytime.'**
  String get upgradeCardSubtitle;

  /// No description provided for @upgradeAction.
  ///
  /// In en, this message translates to:
  /// **'View plans'**
  String get upgradeAction;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @privacyPromise.
  ///
  /// In en, this message translates to:
  /// **'Your files are never used to train AI models.'**
  String get privacyPromise;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Paper (Light)'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Charcoal (Warm Dark)'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language & Script'**
  String get settingsLanguage;

  /// No description provided for @settingsReducedMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get settingsReducedMotion;

  /// No description provided for @settingsReducedMotionDesc.
  ///
  /// In en, this message translates to:
  /// **'Minimize animations across the workspace'**
  String get settingsReducedMotionDesc;

  /// No description provided for @settingsWorkspaceMode.
  ///
  /// In en, this message translates to:
  /// **'Workspace mode'**
  String get settingsWorkspaceMode;

  /// No description provided for @settingsRerunOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Run onboarding again'**
  String get settingsRerunOnboarding;

  /// No description provided for @settingsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Data'**
  String get settingsPrivacyTitle;

  /// No description provided for @settingsPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'GDPR & India DPDP Act 2023 compliant. Export or delete your data anytime.'**
  String get settingsPrivacyBody;

  /// No description provided for @toolPhaseReady.
  ///
  /// In en, this message translates to:
  /// **'Phase 1 shell ready. Full AI capabilities unlock in upcoming phases.'**
  String get toolPhaseReady;

  /// No description provided for @trySamplePrompt.
  ///
  /// In en, this message translates to:
  /// **'Try a sample prompt'**
  String get trySamplePrompt;

  /// No description provided for @emptyWorkspaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Your workspace is ready'**
  String get emptyWorkspaceTitle;

  /// No description provided for @emptyWorkspaceDesc.
  ///
  /// In en, this message translates to:
  /// **'Start with Ask Mozhivora, write a draft, or pick a template.'**
  String get emptyWorkspaceDesc;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to MOZHIVORA'**
  String get authTitle;

  /// No description provided for @authGuestCarryOver.
  ///
  /// In en, this message translates to:
  /// **'Guest mode: {remaining} demo generations carry over when you sign up.'**
  String authGuestCarryOver(int remaining);

  /// No description provided for @authUnconfiguredNotice.
  ///
  /// In en, this message translates to:
  /// **'Supabase is not configured in this build. Pass SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define to enable live sign-in.'**
  String get authUnconfiguredNotice;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUp;

  /// No description provided for @authPhoneOtp.
  ///
  /// In en, this message translates to:
  /// **'Phone OTP'**
  String get authPhoneOtp;

  /// No description provided for @authMagicLink.
  ///
  /// In en, this message translates to:
  /// **'Magic link'**
  String get authMagicLink;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authFullName;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number (with country code)'**
  String get authPhoneHint;

  /// No description provided for @authOtpCode.
  ///
  /// In en, this message translates to:
  /// **'6-digit OTP'**
  String get authOtpCode;

  /// No description provided for @authSendMagicLink.
  ///
  /// In en, this message translates to:
  /// **'Send magic link'**
  String get authSendMagicLink;

  /// No description provided for @authSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get authSendOtp;

  /// No description provided for @authVerifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get authVerifyOtp;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authContinueGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueGoogle;

  /// No description provided for @authAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get authAccountSection;

  /// No description provided for @authSignedOutStatus.
  ///
  /// In en, this message translates to:
  /// **'Using MOZHIVORA as a guest'**
  String get authSignedOutStatus;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get authSignOut;

  /// No description provided for @authSignOutAll.
  ///
  /// In en, this message translates to:
  /// **'Sign out of all devices'**
  String get authSignOutAll;

  /// No description provided for @workspaceMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspace Memory'**
  String get workspaceMemoryTitle;

  /// No description provided for @workspaceMemoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Opt-in context about your role and writing style injected into AI generations.'**
  String get workspaceMemoryDesc;

  /// No description provided for @workspaceMemoryWipe.
  ///
  /// In en, this message translates to:
  /// **'Wipe memory'**
  String get workspaceMemoryWipe;

  /// No description provided for @workspaceMemoryWiped.
  ///
  /// In en, this message translates to:
  /// **'Workspace memory cleared.'**
  String get workspaceMemoryWiped;

  /// No description provided for @creditEstimateLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Est. 1 credit} other{Est. {count} credits}}'**
  String creditEstimateLabel(int count);

  /// No description provided for @creditConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm credit use'**
  String get creditConfirmTitle;

  /// No description provided for @creditConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This action will use an estimated {count} credits. Continue?'**
  String creditConfirmBody(int count);

  /// No description provided for @creditConfirmContinue.
  ///
  /// In en, this message translates to:
  /// **'Run action'**
  String get creditConfirmContinue;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get actionSend;

  /// No description provided for @actionGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get actionGenerate;

  /// No description provided for @actionTranslate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get actionTranslate;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @aiStreamingLabel.
  ///
  /// In en, this message translates to:
  /// **'Streaming response...'**
  String get aiStreamingLabel;

  /// No description provided for @aiResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get aiResultLabel;

  /// No description provided for @aiDepthMode.
  ///
  /// In en, this message translates to:
  /// **'Deep reasoning'**
  String get aiDepthMode;

  /// No description provided for @askBranchChat.
  ///
  /// In en, this message translates to:
  /// **'Branch chat'**
  String get askBranchChat;

  /// No description provided for @askSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask anything in English, Hindi, Urdu, or Hinglish.'**
  String get askSubtitle;

  /// No description provided for @writerTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'What would you like to write about?'**
  String get writerTopicLabel;

  /// No description provided for @emailAbSubjects.
  ///
  /// In en, this message translates to:
  /// **'A/B subjects'**
  String get emailAbSubjects;

  /// No description provided for @emailContextLabel.
  ///
  /// In en, this message translates to:
  /// **'Describe the email or paste the thread to reply to'**
  String get emailContextLabel;

  /// No description provided for @notesSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Paste chapter text, lecture notes, or topic'**
  String get notesSourceLabel;

  /// No description provided for @translatorSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter text to translate (auto-detects Hinglish & mixed scripts)'**
  String get translatorSourceLabel;

  /// No description provided for @docsPickFile.
  ///
  /// In en, this message translates to:
  /// **'Pick PDF, DOCX, TXT, PPTX, or image'**
  String get docsPickFile;

  /// No description provided for @docsPasteHint.
  ///
  /// In en, this message translates to:
  /// **'Or paste document / OCR text here'**
  String get docsPasteHint;

  /// No description provided for @docChatPassagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Document passages (separate pages with ---)'**
  String get docChatPassagesLabel;

  /// No description provided for @docChatQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Ask a grounded question about your document'**
  String get docChatQuestionLabel;

  /// No description provided for @tasksAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add a task (works offline)'**
  String get tasksAddHint;

  /// No description provided for @tasksAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get tasksAddButton;

  /// No description provided for @tasksPlanMyDay.
  ///
  /// In en, this message translates to:
  /// **'Plan my day with AI'**
  String get tasksPlanMyDay;

  /// No description provided for @voiceSpeakerLabels.
  ///
  /// In en, this message translates to:
  /// **'Speaker labels'**
  String get voiceSpeakerLabels;

  /// No description provided for @voiceTranscriptHint.
  ///
  /// In en, this message translates to:
  /// **'Paste meeting transcript or notes'**
  String get voiceTranscriptHint;

  /// No description provided for @voiceToTasks.
  ///
  /// In en, this message translates to:
  /// **'Turn action items into tasks'**
  String get voiceToTasks;

  /// No description provided for @workspaceExportBtn.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get workspaceExportBtn;

  /// No description provided for @workspaceExported.
  ///
  /// In en, this message translates to:
  /// **'Workspace export copied to clipboard.'**
  String get workspaceExported;

  /// No description provided for @workspaceSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search workspace items...'**
  String get workspaceSearchHint;

  /// No description provided for @workspaceTrashToggle.
  ///
  /// In en, this message translates to:
  /// **'30-day Trash'**
  String get workspaceTrashToggle;

  /// No description provided for @workspaceShareLink.
  ///
  /// In en, this message translates to:
  /// **'Copy read-only share link'**
  String get workspaceShareLink;

  /// No description provided for @pricingSelectPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose {plan}'**
  String pricingSelectPlan(String plan);

  /// No description provided for @referralTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite friends, earn 50 credits each'**
  String get referralTitle;

  /// No description provided for @referralSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your code so both of you get 50 bonus credits.'**
  String get referralSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'bn',
        'en',
        'gu',
        'hi',
        'kn',
        'ml',
        'mr',
        'pa',
        'ta',
        'te',
        'ur'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
