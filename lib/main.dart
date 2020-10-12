import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:bump_report/ui/screens/index.dart';
import 'package:bump_report/ui/widgets/index.dart' show Loading;

import 'package:bump_report/services/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await singletonSetup();

  runApp(BumpReport());
}

final Future<FirebaseApp> _initialization = Firebase.initializeApp();

class BumpReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return FutureBuilder<FirebaseApp>(
      future: _initialization,
      builder: (BuildContext _, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading(color: Colors.blueGrey);
        }

        final StorageService storage = getIt<StorageService>();
        final String userId = storage.userId;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bump Report',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute:
              userId != null ? MapScreen.routeName : OnboardingScreen.routeName,
          routes: <String, Widget Function(BuildContext)>{
            MapScreen.routeName: (BuildContext _) => MapScreen(),
            OnboardingScreen.routeName: (BuildContext _) => OnboardingScreen(),
          },
        );
      },
    );
  }
}
