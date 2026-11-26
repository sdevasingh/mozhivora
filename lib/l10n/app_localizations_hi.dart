// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'MOZHIVORA';

  @override
  String get tagline => 'एक कार्यस्थान। हर काम। AI के साथ स्मार्ट।';

  @override
  String get navHome => 'होम';

  @override
  String get navAsk => 'पूछें';

  @override
  String get navWriter => 'लेखक';

  @override
  String get navDocs => 'PDF और दस्तावेज़';

  @override
  String get navDocumentChat => 'दस्तावेज़ चैट';

  @override
  String get navEmail => 'ईमेल';

  @override
  String get navNotes => 'नोट्स और अध्ययन';

  @override
  String get navTranslator => 'अनुवादक';

  @override
  String get navVoice => 'वॉइस और मीटिंग';

  @override
  String get navTasks => 'कार्य योजना';

  @override
  String get navTemplates => 'टेम्पलेट्स';

  @override
  String get navWorkspace => 'कार्यस्थान';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get navPricing => 'मूल्य योजना';

  @override
  String get navTools => 'उपकरण';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get commandBarHint => 'कुछ भी पूछें, टूल खोलें, या फ़ाइलें खोजें...';

  @override
  String get commandBarShortcut => 'Ctrl+K';

  @override
  String get commandBarEmpty =>
      'तुरंत शुरू करने के लिए टूल का नाम या सवाल लिखें।';

  @override
  String onboardingStepOf(int current, int total) {
    return 'चरण $current / $total';
  }

  @override
  String get onboardingRoleTitle => 'आप MOZHIVORA का उपयोग कैसे करेंगे?';

  @override
  String get onboardingRoleSubtitle =>
      'हम आपके होम स्क्रीन और टेम्पलेट्स को आपके अनुसार सजाएंगे।';

  @override
  String get roleStudent => 'छात्र';

  @override
  String get roleStudentDesc => 'सारांश, फ्लैशकार्ड, क्विज़ और परीक्षा योजना';

  @override
  String get roleProfessional => 'पेशेवर';

  @override
  String get roleProfessionalDesc =>
      'रिपोर्ट, ईमेल, मीटिंग नोट्स और दस्तावेज़ चैट';

  @override
  String get roleCreator => 'क्रिएटर';

  @override
  String get roleCreatorDesc => 'एक जैसी ब्रांड आवाज़, स्क्रिप्ट और सोशल पोस्ट';

  @override
  String get roleBusiness => 'व्यवसाय स्वामी';

  @override
  String get roleBusinessDesc => 'प्रस्ताव, ग्राहक उत्तर और बहुभाषी संपर्क';

  @override
  String get onboardingLangTitle => 'अपनी मुख्य भाषा चुनें';

  @override
  String get onboardingLangSubtitle =>
      'आप कभी भी भाषा बदल सकते हैं या हिंग्लिश का उपयोग कर सकते हैं।';

  @override
  String get onboardingToolsTitle => 'अपने शीर्ष 3 उपकरण चुनें';

  @override
  String onboardingToolsSubtitle(int count) {
    return 'चयनित: $count / 3';
  }

  @override
  String get actionNext => 'आगे बढ़ें';

  @override
  String get actionBack => 'पीछे';

  @override
  String get actionFinish => 'कार्यस्थान खोलें';

  @override
  String get actionSkip => 'छोड़ें';

  @override
  String get greetingMorning => 'सुप्रभात';

  @override
  String get greetingAfternoon => 'नमस्कार';

  @override
  String get greetingEvening => 'शुभ संध्या';

  @override
  String get modeStudent => 'छात्र मोड';

  @override
  String get modePro => 'प्रो मोड';

  @override
  String get switchMode => 'मोड बदलें';

  @override
  String creditsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count क्रेडिट शेष',
      one: '1 क्रेडिट शेष',
      zero: '0 क्रेडिट शेष',
    );
    return '$_temp0';
  }

  @override
  String creditsResetOn(String date) {
    return '$date को रीसेट होगा';
  }

  @override
  String get quickActions => 'त्वरित कार्य';

  @override
  String get continueWork => 'जहाँ छोड़ा था वहाँ से शुरू करें';

  @override
  String get todaysTasks => 'आज के कार्य';

  @override
  String get noTasksToday => 'आज कोई कार्य तय नहीं है। अपना दिन प्लान करें।';

  @override
  String get suggestedTemplates => 'आपके लिए सुझाव';

  @override
  String get timeSavedTitle => 'साप्ताहिक बचाया गया समय';

  @override
  String timeSavedLocked(int remaining) {
    return 'वास्तविक समय-बचत आँकड़े देखने के लिए $remaining और AI जनरेशन पूरे करें।';
  }

  @override
  String get upgradeCardTitle =>
      'दस्तावेज़ चैट, वॉइस और ब्रांड वॉइस अनलॉक करें';

  @override
  String get upgradeCardSubtitle =>
      'छात्र ₹99/माह से · प्रो ₹199/माह से। कभी भी रद्द करें।';

  @override
  String get upgradeAction => 'योजनाएं देखें';

  @override
  String get dismiss => 'हटाएं';

  @override
  String get privacyPromise =>
      'आपकी फ़ाइलों का उपयोग कभी भी AI मॉडल को प्रशिक्षित करने के लिए नहीं किया जाता।';

  @override
  String get settingsAppearance => 'दिखावट';

  @override
  String get settingsThemeLight => 'पेपर (हल्का)';

  @override
  String get settingsThemeDark => 'चारकोल (गर्म गहरा)';

  @override
  String get settingsLanguage => 'भाषा और लिपि';

  @override
  String get settingsReducedMotion => 'मोशन कम करें';

  @override
  String get settingsReducedMotionDesc => 'पूरे कार्यस्थान में एनिमेशन कम करें';

  @override
  String get settingsWorkspaceMode => 'कार्यस्थान मोड';

  @override
  String get settingsRerunOnboarding => 'ऑनबोर्डिंग फिर से चलाएं';

  @override
  String get settingsPrivacyTitle => 'गोपनीयता और डेटा';

  @override
  String get settingsPrivacyBody =>
      'GDPR और भारत DPDP अधिनियम 2023 के अनुरूप। कभी भी डेटा निर्यात या हटाएं।';

  @override
  String get toolPhaseReady =>
      'फ़ेज़ 1 शेल तैयार है। पूर्ण AI क्षमताएं अगले चरणों में जुड़ेंगी।';

  @override
  String get trySamplePrompt => 'एक नमूना प्रॉम्प्ट आज़माएं';

  @override
  String get emptyWorkspaceTitle => 'आपका कार्यस्थान तैयार है';

  @override
  String get emptyWorkspaceDesc =>
      'Ask Mozhivora से शुरू करें, ड्राफ्ट लिखें, या टेम्पलेट चुनें।';

  @override
  String get authTitle => 'MOZHIVORA में साइन इन करें';

  @override
  String authGuestCarryOver(int remaining) {
    return 'अतिथि मोड: साइन अप करने पर $remaining डेमो जनरेशन साथ जुड़ जाएंगे।';
  }

  @override
  String get authUnconfiguredNotice =>
      'इस बिल्ड में Supabase कॉन्फ़िगर नहीं है। लाइव साइन-इन के लिए --dart-define से SUPABASE_URL और SUPABASE_ANON_KEY दें।';

  @override
  String get authSignIn => 'साइन इन';

  @override
  String get authSignUp => 'साइन अप';

  @override
  String get authPhoneOtp => 'फ़ोन OTP';

  @override
  String get authMagicLink => 'मैजिक लिंक';

  @override
  String get authFullName => 'पूरा नाम';

  @override
  String get authEmail => 'ईमेल पता';

  @override
  String get authPassword => 'पासवर्ड';

  @override
  String get authPhoneHint => 'फ़ोन नंबर (देश कोड सहित)';

  @override
  String get authOtpCode => '6-अंकीय OTP';

  @override
  String get authSendMagicLink => 'मैजिक लिंक भेजें';

  @override
  String get authSendOtp => 'OTP भेजें';

  @override
  String get authVerifyOtp => 'OTP सत्यापित करें';

  @override
  String get authForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get authContinueGoogle => 'Google से जारी रखें';

  @override
  String get authAccountSection => 'खाता';

  @override
  String get authSignedOutStatus => 'अतिथि के रूप में उपयोग कर रहे हैं';

  @override
  String get authSignOut => 'साइन आउट';

  @override
  String get authSignOutAll => 'सभी डिवाइस से साइन आउट करें';

  @override
  String get workspaceMemoryTitle => 'कार्यस्थान मेमोरी';

  @override
  String get workspaceMemoryDesc =>
      'आपकी भूमिका और लेखन शैली के बारे में वैकल्पिक संदर्भ।';

  @override
  String get workspaceMemoryWipe => 'मेमोरी मिटाएं';

  @override
  String get workspaceMemoryWiped => 'कार्यस्थान मेमोरी साफ़ कर दी गई।';

  @override
  String creditEstimateLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'अनुमानित $count क्रेडिट',
      one: 'अनुमानित 1 क्रेडिट',
    );
    return '$_temp0';
  }

  @override
  String get creditConfirmTitle => 'क्रेडिट उपयोग की पुष्टि करें';

  @override
  String creditConfirmBody(int count) {
    return 'इस कार्य में अनुमानित $count क्रेडिट लगेंगे। क्या आप आगे बढ़ना चाहते हैं?';
  }

  @override
  String get creditConfirmContinue => 'चलाएं';

  @override
  String get actionCancel => 'रद्द करें';

  @override
  String get actionSend => 'भेजें';

  @override
  String get actionGenerate => 'तैयार करें';

  @override
  String get actionTranslate => 'अनुवाद करें';

  @override
  String get actionCopy => 'कॉपी करें';

  @override
  String get copiedToClipboard => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get aiStreamingLabel => 'उत्तर आ रहा है...';

  @override
  String get aiResultLabel => 'परिणाम';

  @override
  String get aiDepthMode => 'गहन तर्क';

  @override
  String get askBranchChat => 'चैट शाखा बनाएं';

  @override
  String get askSubtitle =>
      'अंग्रेज़ी, हिंदी, उर्दू या हिंग्लिश में कुछ भी पूछें।';

  @override
  String get writerTopicLabel => 'आप किस विषय पर लिखना चाहते हैं?';

  @override
  String get emailAbSubjects => 'A/B विषय पंक्तियाँ';

  @override
  String get emailContextLabel =>
      'ईमेल का विवरण लिखें या उत्तर देने के लिए थ्रेड पेस्ट करें';

  @override
  String get notesSourceLabel =>
      'अध्याय का पाठ, लेक्चर नोट्स या विषय पेस्ट करें';

  @override
  String get translatorSourceLabel =>
      'अनुवाद के लिए पाठ लिखें (हिंग्लिश स्वतः पहचानी जाती है)';

  @override
  String get docsPickFile => 'PDF, DOCX, TXT, PPTX या छवि चुनें';

  @override
  String get docsPasteHint => 'या दस्तावेज़ / OCR पाठ यहाँ पेस्ट करें';

  @override
  String get docChatPassagesLabel =>
      'दस्तावेज़ अंश (पृष्ठों को --- से अलग करें)';

  @override
  String get docChatQuestionLabel => 'अपने दस्तावेज़ के बारे में प्रश्न पूछें';

  @override
  String get tasksAddHint => 'नया कार्य जोड़ें (ऑफ़लाइन भी चलता है)';

  @override
  String get tasksAddButton => 'जोड़ें';

  @override
  String get tasksPlanMyDay => 'AI से दिन की योजना बनाएं';

  @override
  String get voiceSpeakerLabels => 'स्पीकर लेबल';

  @override
  String get voiceTranscriptHint => 'मीटिंग ट्रांसक्रिप्ट या नोट्स पेस्ट करें';

  @override
  String get voiceToTasks => 'एक्शन आइटम को कार्यों में बदलें';

  @override
  String get workspaceExportBtn => 'JSON निर्यात करें';

  @override
  String get workspaceExported =>
      'कार्यस्थान निर्यात क्लिपबोर्ड पर कॉपी किया गया।';

  @override
  String get workspaceSearchHint => 'कार्यस्थान में खोजें...';

  @override
  String get workspaceTrashToggle => '30-दिन ट्रैश';

  @override
  String get workspaceShareLink => 'केवल-पठनीय शेयर लिंक कॉपी करें';

  @override
  String pricingSelectPlan(String plan) {
    return '$plan चुनें';
  }

  @override
  String get referralTitle => 'मित्रों को आमंत्रित करें, दोनों को 50 क्रेडिट';

  @override
  String get referralSubtitle =>
      'अपना कोड साझा करें ताकि दोनों को 50 बोनस क्रेडिट मिलें।';
}
