import 'package:flutter/material.dart';

import 'package:bump_report/ui/screens/index.dart';

void main() {
  runApp(BumpReport());
}

class BumpReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bump Report',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MapScreen.routeName,
      routes: <String, Widget Function(BuildContext)>{
        MapScreen.routeName: (BuildContext _) => MapScreen(),
      },
    );
  }
}
