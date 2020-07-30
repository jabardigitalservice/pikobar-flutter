class FirebaseConfig {
  static String storeUrl = 'force_update_store_url';
  static String currentVersion = 'force_update_current_version';
  static String forceUpdateRequired = 'force_update_required';

  /// Remote config parameter key
  /// for menus
  static String jshUrl = 'jabarsaberhoax_url';
  static String announcement = 'announcement';
  static String jshCaption = 'jabarsaberhoax_caption';
  static String pikobarCaption = 'pikobar_caption';
  static String pikobarUrl = 'pikobar_url';
  static String worldInfoCaption = 'world_info_caption';
  static String worldInfoUrl = 'world_info_url';
  static String nationalInfoCaption = 'national_info_caption';
  static String nationalInfoUrl = 'national_info_url';
  static String donationCaption = 'donasi_caption';
  static String donationUrl = 'donasi_url';
  static String bansosCaption = 'bansos_caption';
  static String bansosUrl = 'bansos_url';
  static String logisticCaption = 'logistic_caption';
  static String logisticUrl = 'logistic_url';
  static String reportEnabled = 'lapor_enabled';
  static String reportCaption = 'lapor_caption';
  static String reportUrl = 'lapor_url';
  static String qnaEnabled = 'tanyajawab_enabled';
  static String qnaCaption = 'tanyajawab_caption';
  static String qnaUrl = 'tanyajawab_url';
  static String selfTracingCaption = 'selftracing_caption';
  static String selfTracingUrl = 'selftracing_url';
  static String selfTracingEnabled = 'selftracing_enabled';
  static String volunteerEnabled = 'volunteer_enabled';
  static String volunteerCaption = 'volunteer_caption';
  static String volunteerUrl = 'volunteer_url';
  static String selfDiagnoseEnabled = 'selfdiagnose_enabled';
  static String selfDiagnoseUrl = 'selfdiagnose_url';
  static String selfDiagnoseCaption = 'selfdiagnose_caption';
  static String spreadCheckLocation = 'ceksebaran_location';
  static String healthStatusColors = 'health_status_colors';
  static String emergencyCall = 'emergency_call';
  static String rapidTestInfo = 'rapid_test_info';
  static String rapidTestEnable = 'rapid_test_enable';
  static String groupMenuProfile = 'group_menu_profile';
  static String groupHomeBanner = 'group_home_bigbanner';
  static String importantinfoStatusVisible = 'important_info_status_visible';
  static String lastUpdateLabel = 'update_terkini_label';


  /// Remote config parameter key
  /// Access requires a login
  static String loginRequired = 'login_required';
  static String emergencyNumberMenu = 'emergency_number_menu';
  static String pikobarInfoMenu = 'pikobar_info_menu';
  static String nationalInfoMenu = 'national_info_menu';
  static String worldInfoMenu = 'world_info_menu';
  static String donationMenu = 'donasi_menu';
  static String surveyMenu = 'survey_menu';
  static String selfDiagnoseMenu = 'selfdiagnose_menu';
  static String logisticMenu = 'logistic_menu';
  static String jshMenu = 'saber_hoax_menu';
  static String volunteerMenu = 'volunteer_menu';
  static String reportMenu = 'lapor_menu';
  static String qnaMenu = 'tanyajawab_menu';
  static String spreadCheckMenu = 'spread_check';
  static String bansosMenu = 'bansos';
  static String loginRequiredDefaultVal = '{"$emergencyNumberMenu":false,'
      '"$pikobarInfoMenu":false,'
      '"$nationalInfoMenu":false,'
      '"$worldInfoMenu":false,'
      '"$donationMenu":false,'
      '"$surveyMenu":true,'
      '"$selfDiagnoseMenu":false,'
      '"$logisticMenu":false,'
      '"$jshMenu":false,'
      '"$volunteerMenu":false,'
      '"$reportMenu":false,'
      '"$qnaMenu":false,'
      '"$spreadCheckMenu":false,'
      '"$bansosMenu":false}';

  /// Remote config parameter key
  /// Profile
  static String healthStatusVisible = 'health_status_visible';
  static String otpEnabled = 'otp_enabled';
  static String termsConditions = 'terms_conditions';

  /// Remote config parameter key
  /// Contact History
  static String contactHistoryForm = 'contact_history_form';
  static String contactHistoryFormDefaultValue = '{'
      '"relation_list":['
      '"Keluarga Serumah",'
      '"Teman Kerja",'
      '"Jamaah di Tempat Ibadah",'
      '"Lainnya"]'
      '}';

  static String lastUpdateLabelDefaultValue='{'
      '"label":['
      '"Terkonfirmasi",'
      '"Positif Aktif",'
      '"Sembuh",'
      '"Meninggal",'
      '"ODP",'
      '"PDP"]'
      '}';
}
