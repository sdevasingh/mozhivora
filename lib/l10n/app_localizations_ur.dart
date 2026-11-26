// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'MOZHIVORA';

  @override
  String get tagline => 'ایک ورک اسپیس۔ ہر کام۔ AI کے ساتھ زیادہ ذہین۔';

  @override
  String get navHome => 'ہوم';

  @override
  String get navAsk => 'پوچھیں';

  @override
  String get navWriter => 'رائٹر';

  @override
  String get navDocs => 'PDF اور دستاویزات';

  @override
  String get navDocumentChat => 'دستاویز چیٹ';

  @override
  String get navEmail => 'ای میل';

  @override
  String get navNotes => 'نوٹس اور مطالعہ';

  @override
  String get navTranslator => 'مترجم';

  @override
  String get navVoice => 'آواز اور میٹنگز';

  @override
  String get navTasks => 'ٹاسک پلانر';

  @override
  String get navTemplates => 'ٹیمپلیٹس';

  @override
  String get navWorkspace => 'ورک اسپیس';

  @override
  String get navSettings => 'ترتیبات';

  @override
  String get navPricing => 'قیمتیں';

  @override
  String get navTools => 'ٹولز';

  @override
  String get navProfile => 'پروفائل';

  @override
  String get commandBarHint =>
      'کچھ بھی پوچھیں، ٹول کھولیں، یا فائلیں تلاش کریں...';

  @override
  String get commandBarShortcut => 'Ctrl+K';

  @override
  String get commandBarEmpty =>
      'فوری شروع کرنے کے لیے ٹول کا نام یا سوال لکھیں۔';

  @override
  String onboardingStepOf(int current, int total) {
    return 'مرحلہ $current از $total';
  }

  @override
  String get onboardingRoleTitle => 'آپ MOZHIVORA کو کیسے استعمال کریں گے؟';

  @override
  String get onboardingRoleSubtitle =>
      'ہم آپ کی ہوم اسکرین اور ٹیمپلیٹس کو آپ کے مطابق ترتیب دیں گے۔';

  @override
  String get roleStudent => 'طالب علم';

  @override
  String get roleStudentDesc =>
      'خلاصے، فلیش کارڈز، کوئز اور امتحان کی منصوبہ بندی';

  @override
  String get roleProfessional => 'پیشہ ور';

  @override
  String get roleProfessionalDesc =>
      'رپورٹس، ای میلز، میٹنگ نوٹس اور دستاویز چیٹ';

  @override
  String get roleCreator => 'تخلیق کار';

  @override
  String get roleCreatorDesc => 'یکساں برانڈ آواز، اسکرپٹس اور سوشل پوسٹس';

  @override
  String get roleBusiness => 'کاروباری مالک';

  @override
  String get roleBusinessDesc => 'تجاویز، کسٹمر جوابات اور کثیر لسانی رابطہ';

  @override
  String get onboardingLangTitle => 'اپنی بنیادی زبان منتخب کریں';

  @override
  String get onboardingLangSubtitle => 'آپ کسی بھی وقت زبان تبدیل کر سکتے ہیں۔';

  @override
  String get onboardingToolsTitle => 'اپنے سرفہرست 3 ٹولز منتخب کریں';

  @override
  String onboardingToolsSubtitle(int count) {
    return 'منتخب شدہ: $count از 3';
  }

  @override
  String get actionNext => 'جاری رکھیں';

  @override
  String get actionBack => 'واپس';

  @override
  String get actionFinish => 'ورک اسپیس کھولیں';

  @override
  String get actionSkip => 'چھوڑیں';

  @override
  String get greetingMorning => 'صبح بخیر';

  @override
  String get greetingAfternoon => 'سہ پہر بخیر';

  @override
  String get greetingEvening => 'شام بخیر';

  @override
  String get modeStudent => 'اسٹوڈنٹ موڈ';

  @override
  String get modePro => 'پرو موڈ';

  @override
  String get switchMode => 'موڈ تبدیل کریں';

  @override
  String creditsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کریڈٹ باقی',
      one: '1 کریڈٹ باقی',
      zero: '0 کریڈٹ باقی',
    );
    return '$_temp0';
  }

  @override
  String creditsResetOn(String date) {
    return '$date کو ری سیٹ ہوگا';
  }

  @override
  String get quickActions => 'فوری اقدامات';

  @override
  String get continueWork => 'جہاں چھوڑا تھا وہاں سے جاری رکھیں';

  @override
  String get todaysTasks => 'آج کے کام';

  @override
  String get noTasksToday =>
      'آج کوئی کام مقرر نہیں ہے۔ اپنے دن کی منصوبہ بندی کریں۔';

  @override
  String get suggestedTemplates => 'آپ کے لیے تجاویز';

  @override
  String get timeSavedTitle => 'ہفتہ وار بچایا گیا وقت';

  @override
  String timeSavedLocked(int remaining) {
    return 'حقیقی وقت کی بچت کے اعداد و شمار دیکھنے کے لیے $remaining مزید AI تخلیقات مکمل کریں۔';
  }

  @override
  String get upgradeCardTitle => 'دستاویز چیٹ، آواز اور برانڈ وائس ان لاک کریں';

  @override
  String get upgradeCardSubtitle =>
      'طالب علم ₹99/ماہ سے · پرو ₹199/ماہ سے۔ کسی بھی وقت منسوخ کریں۔';

  @override
  String get upgradeAction => 'پلان دیکھیں';

  @override
  String get dismiss => 'برخاست کریں';

  @override
  String get privacyPromise =>
      'آپ کی فائلیں کبھی بھی AI ماڈلز کی تربیت کے لیے استعمال نہیں ہوتیں۔';

  @override
  String get settingsAppearance => 'ظاہری شکل';

  @override
  String get settingsThemeLight => 'پیپر (ہلکا)';

  @override
  String get settingsThemeDark => 'چارکول (گرم گہرا)';

  @override
  String get settingsLanguage => 'زبان اور رسم الخط';

  @override
  String get settingsReducedMotion => 'حرکت کم کریں';

  @override
  String get settingsReducedMotionDesc =>
      'پورے ورک اسپیس میں اینیمیشنز کم کریں';

  @override
  String get settingsWorkspaceMode => 'ورک اسپیس موڈ';

  @override
  String get settingsRerunOnboarding => 'آن بورڈنگ دوبارہ چلائیں';

  @override
  String get settingsPrivacyTitle => 'رازداری اور ڈیٹا';

  @override
  String get settingsPrivacyBody =>
      'GDPR اور انڈیا DPDP ایکٹ 2023 کے مطابق۔ کسی بھی وقت ڈیٹا برآمد یا حذف کریں۔';

  @override
  String get toolPhaseReady =>
      'فیز 1 شیل تیار ہے۔ مکمل AI صلاحیتیں آنے والے مراحل میں شامل ہوں گی۔';

  @override
  String get trySamplePrompt => 'نمونہ پرامپٹ آزمائیں';

  @override
  String get emptyWorkspaceTitle => 'آپ کا ورک اسپیس تیار ہے';

  @override
  String get emptyWorkspaceDesc =>
      'Ask Mozhivora سے شروع کریں، ڈرافٹ لکھیں، یا ٹیمپلیٹ منتخب کریں۔';

  @override
  String get authTitle => 'MOZHIVORA میں سائن ان کریں';

  @override
  String authGuestCarryOver(int remaining) {
    return 'مہمان موڈ: سائن اپ کرنے پر $remaining ڈیمو تخلیقات برقرار رہیں گی۔';
  }

  @override
  String get authUnconfiguredNotice =>
      'اس بلڈ میں Supabase کنفیگر نہیں ہے۔ لائیو سائن ان کے لیے --dart-define کے ذریعے SUPABASE_URL اور SUPABASE_ANON_KEY فراہم کریں۔';

  @override
  String get authSignIn => 'سائن ان';

  @override
  String get authSignUp => 'سائن اپ';

  @override
  String get authPhoneOtp => 'فون OTP';

  @override
  String get authMagicLink => 'میجک لنک';

  @override
  String get authFullName => 'پورا نام';

  @override
  String get authEmail => 'ای میل پتہ';

  @override
  String get authPassword => 'پاس ورڈ';

  @override
  String get authPhoneHint => 'فون نمبر (ملکی کوڈ کے ساتھ)';

  @override
  String get authOtpCode => '6 ہندسوں کا OTP';

  @override
  String get authSendMagicLink => 'میجک لنک بھیجیں';

  @override
  String get authSendOtp => 'OTP بھیجیں';

  @override
  String get authVerifyOtp => 'OTP کی تصدیق کریں';

  @override
  String get authForgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get authContinueGoogle => 'Google کے ساتھ جاری رکھیں';

  @override
  String get authAccountSection => 'اکاؤنٹ';

  @override
  String get authSignedOutStatus => 'بطور مہمان استعمال کر رہے ہیں';

  @override
  String get authSignOut => 'سائن آؤٹ';

  @override
  String get authSignOutAll => 'تمام آلات سے سائن آؤٹ کریں';

  @override
  String get workspaceMemoryTitle => 'ورک اسپیس میموری';

  @override
  String get workspaceMemoryDesc =>
      'آپ کے کردار اور تحریری انداز کے بارے میں اختیاری سیاق و سباق۔';

  @override
  String get workspaceMemoryWipe => 'میموری صاف کریں';

  @override
  String get workspaceMemoryWiped => 'ورک اسپیس میموری صاف کر دی گئی۔';

  @override
  String creditEstimateLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تخمینی $count کریڈٹ',
      one: 'تخمینی 1 کریڈٹ',
    );
    return '$_temp0';
  }

  @override
  String get creditConfirmTitle => 'کریڈٹ کے استعمال کی تصدیق کریں';

  @override
  String creditConfirmBody(int count) {
    return 'اس عمل میں تخمینی $count کریڈٹ استعمال ہوں گے۔ کیا آپ جاری رکھنا چاہتے ہیں؟';
  }

  @override
  String get creditConfirmContinue => 'عمل چلائیں';

  @override
  String get actionCancel => 'منسوخ کریں';

  @override
  String get actionSend => 'بھیجیں';

  @override
  String get actionGenerate => 'تیار کریں';

  @override
  String get actionTranslate => 'ترجمہ کریں';

  @override
  String get actionCopy => 'کاپی کریں';

  @override
  String get copiedToClipboard => 'کلپ بورڈ پر کاپی ہو گیا';

  @override
  String get aiStreamingLabel => 'جواب آ رہا ہے...';

  @override
  String get aiResultLabel => 'نتیجہ';

  @override
  String get aiDepthMode => 'گہرا تجزیہ';

  @override
  String get askBranchChat => 'چیٹ برانچ کریں';

  @override
  String get askSubtitle => 'انگریزی، ہندی، اردو یا ہنگلش میں کچھ بھی پوچھیں۔';

  @override
  String get writerTopicLabel => 'آپ کس موضوع پر لکھنا چاہتے ہیں؟';

  @override
  String get emailAbSubjects => 'A/B سبجیکٹ لائنز';

  @override
  String get emailContextLabel =>
      'ای میل کی تفصیل لکھیں یا جواب کے لیے تھریڈ پیسٹ کریں';

  @override
  String get notesSourceLabel => 'سبق کا متن، لیکچر نوٹس یا موضوع پیسٹ کریں';

  @override
  String get translatorSourceLabel =>
      'ترجمہ کے لیے متن لکھیں (ہنگلش خودکار شناخت)';

  @override
  String get docsPickFile => 'PDF، DOCX، TXT، PPTX یا تصویر منتخب کریں';

  @override
  String get docsPasteHint => 'یا دستاویز / OCR متن یہاں پیسٹ کریں';

  @override
  String get docChatPassagesLabel =>
      'دستاویز کے حصے (صفحات کو --- سے الگ کریں)';

  @override
  String get docChatQuestionLabel => 'اپنی دستاویز کے بارے میں سوال پوچھیں';

  @override
  String get tasksAddHint => 'نیا کام شامل کریں (آف لائن بھی کام کرتا ہے)';

  @override
  String get tasksAddButton => 'شامل کریں';

  @override
  String get tasksPlanMyDay => 'AI کے ساتھ دن کی منصوبہ بندی کریں';

  @override
  String get voiceSpeakerLabels => 'اسپیکر لیبلز';

  @override
  String get voiceTranscriptHint => 'میٹنگ ٹرانسکرپٹ یا نوٹس پیسٹ کریں';

  @override
  String get voiceToTasks => 'ایکشن آئٹمز کو کاموں میں بدلیں';

  @override
  String get workspaceExportBtn => 'JSON برآمد کریں';

  @override
  String get workspaceExported => 'ورک اسپیس برآمد کلپ بورڈ پر کاپی ہو گیا۔';

  @override
  String get workspaceSearchHint => 'ورک اسپیس میں تلاش کریں...';

  @override
  String get workspaceTrashToggle => '30 دن کا کوڑے دان';

  @override
  String get workspaceShareLink => 'صرف پڑھنے کا لنک کاپی کریں';

  @override
  String pricingSelectPlan(String plan) {
    return '$plan منتخب کریں';
  }

  @override
  String get referralTitle => 'دوستوں کو مدعو کریں، دونوں کو 50 کریڈٹ';

  @override
  String get referralSubtitle =>
      'اپنا کوڈ شیئر کریں تاکہ دونوں کو 50 بونس کریڈٹ ملیں۔';
}
