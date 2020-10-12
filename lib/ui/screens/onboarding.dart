import 'package:flutter/material.dart';

import 'package:bump_report/ui/pages/index.dart' show AboutUser;
import 'package:bump_report/ui/widgets/index.dart' show Bullets;
import 'package:bump_report/ui/widgets/index.dart' show Template;

const List<Map<String, dynamic>> pages = <Map<String, dynamic>>[
  <String, dynamic>{
    'title': 'Map',
    'description': 'Visualize on the main page the potholes that are near you',
    'icon': Icons.map_outlined,
  },
  <String, dynamic>{
    'title': 'Report',
    'description':
        'Make a report of the potholes that you consider need urgent repair, do not forget to be specific in the requested data to take quick actions',
    'icon': Icons.warning_amber_outlined,
  },
  <String, dynamic>{
    'title': 'Repair Progress',
    'description':
        'On the map you can see the potholes that are already being repaired, it is not necessary to report them again',
    'icon': Icons.trending_up_sharp,
  },
];

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _controller = PageController();

  List<Widget> _slides;
  double _current;

  @override
  void initState() {
    _slides = pages.map<Widget>((Map<String, dynamic> item) {
      return Template(
        icon: item['icon'] as IconData,
        title: item['title'] as String,
        description: item['description'] as String,
        margin: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 48.0),
      );
    }).toList();

    _slides.add(AboutUser(scaffoldKey: _scaffoldKey));
    _current = 0.0;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              itemBuilder: (BuildContext context, int index) {
                _controller.addListener(() {
                  setState(() {
                    _current = _controller.page;
                  });
                });
                return _slides[index];
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Bullets(
                active: _current.round(),
                length: _slides.length,
                margin: const EdgeInsets.symmetric(vertical: 40.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
