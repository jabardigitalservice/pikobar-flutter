class FirebaseConfig {
  static String storeUrl = 'force_update_store_url';
  static String currentVersion = 'force_update_current_version';
  static String forceUpdateRequired = 'force_update_required';

  /// Remote config parameter key
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
  static String reportHotlineEnabled = 'lapor_hotline_enabled';
  static String reportHotlineCaption = 'lapor_hotline_caption';
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
  static String massiveTestUrl = 'massive_test_url';
  static String massiveTestCaption = 'massive_test_caption';
  static String spreadCheckLocation = 'ceksebaran_location';
  static String healthStatusColors = 'health_status_colors';
  static String emergencyCall = 'emergency_call';
  static String rapidTestInfo = 'rapid_test_info';
  static String rapidTestEnable = 'rapid_test_enable';
  static String groupMenuProfile = 'group_menu_profile';
  static String groupHomeBanner = 'group_home_bigbanner';
  static String importantinfoStatusVisible = 'important_info_status_visible';
  static String labels = 'labels';
  static String statisticsSwitch = 'statistics_switch';
  static String bottomSheetContent = 'bottom_sheet_content';
  static String geolocationEnabled = 'geolocation_enabled';
  static String emergencyNumberTab = 'emergency_number_tab';
  static String successMessageSelfReport = 'succes_message_self_report';
  static String nikMessage = 'nik_message';
  static String dashboardPikobarApiKey = 'dashboard_pikobar_api_key';
  static String selfIsolation = 'self_isolation';

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
  static String massiveTestMenu = 'massive_test_menu';
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
      '"$massiveTestMenu":false,'
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

  static String labelsDefaultValue = '{'
      '"statistics":{'
      '"confirmed": "Terkonfirmasi",'
      '"positif": "Positif Aktif",'
      '"recovered": "Sembuh",'
      '"deaths": "Meninggal",'
      '"odp": "ODP",'
      '"odp_detail": "Dari Total ",'
      '"pdp_detail": "Dari Total ",'
      '"pdp": "PDP"'
      '},'
      '"pcr_rdt": {'
      '"rdt": {'
      '"sum": "Jumlah RDT yang telah dilakukan",'
      '"positif": "Reaktif",'
      '"negatif": "Non-Reaktif",'
      '"invalid": "Invalid"'
      '},'
      '"pcr": {'
      '"sum": "Jumlah PCR yang telah dilakukan",'
      '"positif": "Positif",'
      '"negatif": "Negatif",'
      '"invalid": "Invalid"'
      '}'
      '},'
      '"profile": {},'
      '"menu": {'
      '"title": "Pusat Layanan & Informasi",'
      '"description": "Saatnya berbagi informasi dan lawan COVID-19"'
      '},'
      '"news": {'
      '"title": "Berita Terkini",'
      '"description": "Anti-hoax dengan berita terpercaya"'
      '},'
      '"video": {'
      '"title": "Video Terkini",'
      '"description": "Cari informasi melalui video dibawawah ini"'
      '},'
      '"info_graphics": {'
      '"title": "Info Praktikal",'
      '"description": "Info yang memuat infograpis terkait COVID-19"'
      '},'
      '"documents": {'
      '"title": "Dokumen",'
      '"description": "Lihat dan unduh dokumen serta rilis pers seputar informasi COVID-19 di Jawa Barat"'
      '},'
      '"check_distribution": {'
      ' "by_radius": {'
      '"confirmed": "Terkonfirmasi",'
      '"odp": "ODP",'
      '"pdp": "PDP"'
      ' },'
      '"by_region": {'
      '"confirmed": "Terkonfirmasi",'
      '"odp": "ODP",'
      '"pdp": "PDP"'
      '}'
      '}'
      '}';

  static String bottomSheetDefaultValue = '{'
      '"statistics_bottom_sheet": {'
      '"kontak_erat": {'
      '"title": "Kontak Erat",'
      '"message": "Orang yang memiliki riwayat kontak dengan kasus probable atau terkonfirmasi COVID-19."'
      '},'
      '"suspek": {'
      '"title": "Suspek",'
      '"message": "<p>Orang yang memiliki salah satu dari kriteria berikut : <br><br>i. Mengalami Infeksi Saluran Pernapasan Akut (ISPA) DAN pada 14 hari terakhir sebelum timbul gejala memiliki riwayat perjalanan atau tinggal di negara/wilayah Indonesia yang melaporkan transmisi lokal. <br><br>ii. Mengalami salah satu gejala/tanda ISPA DAN pada 14 hari terakhir sebelum timbul gejala memiliki riwayat kontak dengan kasus terkonfirmasi/probable COVID-19. <br><br>iii. Mengalami ISPA berat/pneumonia berat yang membutuhkan perawatan di rumah sakit DAN tidak ada penyebab lain berdasarkan gambaran klinik yang meyakinkan.</p>"'
      '},'
      '"probable": {'
      '"title": "Probable",'
      '"message": "Kasus suspek dengan ISPA Berat/ARDS/meninggal dengan gambaran klinis yang meyakinkan COVID-19 dan belum ada hasil pemeriksaan laboratorium RT-PCR."'
      '},'
      '"discarded": {'
      '"title": "Discarded",'
      '"message": "Kasus dikatakan discarded apabila orang dengan status ini dinyatakan selesai menjalani masa perawatan / karantina"'
      '}'
      '},'
      '"rdt_bottom_sheet": {'
      '"reaktif": {'
      '"title": "Reaktif",'
      '"message": "Reaktif artinya ditemukan adanya antibodi terhadap virus penyebab COVID-19."'
      '},'
      '"non-reaktif": {'
      '"title": "Non-Reaktif",'
      '"message": "Non Reaktif artinya tidak ditemukan adanya antibodi terhadap virus penyebab COVID-19."'
      '},'
      '"invalid": {'
      '"title": "Invalid",'
      '"message": "Negatif artinya sampel yang diperiksa tidak dapat mengeluarkan hasil pemeriksaan."'
      '}'
      '},'
      '"pcr_bottom_sheet": {'
      '"positif": {'
      '"title": "Positif",'
      '"message": "Positif artinya ditemukan adanya RNA dari SARS-CoV-2 yang merupakan penyebab COVID-19."'
      '},'
      '"negatif": {'
      '"title": "Negatif",'
      '"message": "Negatif artinya tidak ditemukan adanya RNA dari SARS-CoV-2 yang merupakan penyebab COVID 19."'
      '},'
      '"inkonklusif": {'
      '"title": "Inkonklusif",'
      '"message": "Inkonklusif artinya keberadaan RNA dari SARS-CoV-2 yang merupakan penyebab COVID 19 belum dapat disimpulkan."'
      '}'
      '}'
      '}';

  static String emergencyCallDefaultValue = '['
      '{'
      '"title": "119 Call Center",'
      '"image": "https://firebasestorage.googleapis.com/v0/b/jabarprov-covid19.appspot.com/o/public%2Fphone.png?alt=media&token=fba990d3-3ca1-4078-a8cb-2eb7432fdf05",'
      '"phone_number": "119",'
      '"action": "call",'
      '"message": ""'
      ' },'
      '{'
      '"title": "WA Hotline Pikobar",'
      '"image": "https://firebasestorage.googleapis.com/v0/b/jabarprov-covid19.appspot.com/o/public%2Fwhatsapp_icon.png?alt=media&token=b0554181-390d-453e-8a58-890dd4942ab7",'
      ' "phone_number": "+6285697391854",'
      '"action": "whatsapp",'
      ' "message": "Halo Admin! Saya ingin tanya seputar PIKOBAR"'
      '}'
      ']';

  static String emergencyNumberTabDefaultValue = '['
      '{'
      '"name": "No Darurat",'
      '"analytics": "tapped_nomor_darurat_tab"'
      '},'
      '{'
      '"name": "RS Rujukan COVID-19",'
      '"analytics": "tapped_rs_rujukan_tab"'
      '},'
      '{'
      '"name": "Call Center Kota/Kab",'
      '"analytics": "tapped_call_center_tab"'
      '},'
      '{'
      '"name": "Website Gugus Tugas Kota/Kabupaten Jawa Barat",'
      ' "analytics": "tapped_gugus_tugas_web_tab"'
      '},'
      ' {'
      '"name": "Pusat Isolasi",'
      '"analytics": "tapped_pusat_Isolasi_tab"'
      '}'
      ']';

  static String successMessageSelfReportDefaultValue = '{'
      '"saved_message": ['
      '{'
      '"icon": "https://firebasestorage.googleapis.com/v0/b/jabarprov-covid19.appspot.com/o/public%2Fdaily_success.png?alt=media&token=5a08e00b-b47b-4d5a-9230-3e50d0fe2fe5",'
      ' "title": "Berhasil Disimpan",'
      '"description": "Terima kasih, laporan Anda membantu kami dalam melakukan penanganan kasus secara tepat.",'
      '"city_id": ['
      '"default"'
      ' ]'
      '}'
      '],'
      '"indications_message": ['
      ' {'
      '"icon": "https://firebasestorage.googleapis.com/v0/b/jabarprov-covid19.appspot.com/o/public%2Findications_info.png?alt=media&token=cb1dc19a-30d6-4e3a-88aa-55f69ff9cc3a",'
      '"title": "Anda terdeteksi bergejala",'
      ' "description": "Jika Anda merasakan gejala selama isolasi mandiri, segera lapor ke Puskesmas terdekat untuk mendapatkan arahan lebih lanjut.",'
      ' "city_id": ['
      '"default"'
      ']'
      '}'
      '],'
      '"temperature_message": ['
      '{'
      '"icon": "https://firebasestorage.googleapis.com/v0/b/jabarprov-covid19.appspot.com/o/public%2Ftemperature_info.png?alt=media&token=6b4103a5-87e4-4da9-a53c-76de3cd65105",'
      '"title": "Informasi Tambahan",'
      ' "description": "Agar dapat memantau suhu tubuh secara akurat, penting bagi Anda untuk memiliki thermometer selama isolasi mandiri.",'
      ' "city_id": ['
      ' "default"'
      ']'
      ' }'
      ']'
      '}';

  static String nikMessageDefaultValue = '{'
      '"title": "NIK Tidak Terdaftar",'
      ' "description": "<p>Hanya NIK yang terdaftar untuk melakukan karantina mandiri yang dapat mengakses menu ini</p><p>Apabila Anda memiliki pertanyaan atau saran mengenai Kebijakan Privasi kami, jangan ragu untuk hubungi kami melalui email</p>"'
      '}';

  static String selfIsolationDefaultValue = '['
      '{'
      '"title": "Telekonsultasi \nDokter",'
      '"icon":"https://firebasestorage.googleapis.com/v0/b/jabarprov-covid19.appspot.com/o/public%2Ftelekonsultasi.png?alt=media&token=473d3122-ae38-4bca-9781-ea8015a23df5",'
      '"analytics": "tapped_mobile_telekonsultasi_dokter",'
      '"url":          "https://wa.me/6285697391854?text=Halo%20Admin!%20Saya%20ingin%20tanya%20seputar%20Isolasi%20Mandiri"'
      '},'
      ' {'
      ' "title": "Permohonan Vitamin/Obat",'
      ' "icon":          "https://firebasestorage.googleapis.com/v0/b/jabarprov-covid19.appspot.com/o/public%2Fhandle_with_care.png?alt=media&token=5ec08bc2-9687-4d19-9b76-a356be9b30b8",'
      ' "analytics": "tapped_mobile_permohonan_isoman",'
      ' "url": "https://bit.ly/pcbr-isomanvit"'
      ' }'
      ']';
}
