import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:bump_report/ui/screens/index.dart';
import 'package:bump_report/ui/widgets/index.dart' show Loading;

void main() {
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

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bump Report',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: MapScreen.routeName,
          routes: <String, Widget Function(BuildContext)>{
            MapScreen.routeName: (BuildContext _) => MapScreen(),
          },
        );
      },
    );
  }
}
