class Environment {
  static String imageAssets = 'assets/images/';
  static String logoAssets = 'assets/logo/';
  static String iconAssets = 'assets/icons/';
  static String flareAssets = 'assets/flares/';

  static Map<String, String> headerPost = {};

  // production
  static String apiProd = 'https://sapawarga.jabarprov.go.id/api/v1';
  static String apiProdStorage =
      'https://sapawarga.jabarprov.go.id/api/storage'; //
  static String databaseNameProd = 'SapawargaDB.db';

  // staging
  static String apiStaging = 'https://sapawarga-staging.jabarprov.go.id/api/v1';
  static String apiStagingStorage =
      'https://sapawarga-staging.jabarprov.go.id/api/storage';
  static String databaseNameStaging = 'SapawargaDBStaging.db';

  // mock
  static String apiMock = 'http://52.74.74.33:3000/v1';

  static String googleApiKey = '%GOOGLE_API_KEY%';
  static String defaultPassword = '123456';
  static String saberHoaxPhone = '+6282118670700';
  static String csPhone = '+6281212124023';
  static String laporPhone = '1708';

  static String sentryDNS = '%SENTRY_DNS%';
}
