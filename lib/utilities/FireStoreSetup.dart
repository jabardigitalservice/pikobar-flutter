import 'package:firebase_core/firebase_core.dart';

Future<FirebaseApp> fireStoreSetup() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'covid19',
    options: const FirebaseOptions(
      googleAppID: '0fd',
      gcmSenderID: '2120',
      apiKey: 'Uj8',
      projectID: 'tret',
    ),
  );

  return app;
}
