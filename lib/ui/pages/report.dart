import 'package:flutter/material.dart';

import 'package:bump_report/models/index.dart' show Bump;

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  Bump _report;

  @override
  void initState() {
    super.initState();

    _report = Bump();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      height: deviceHeight * 0.85,
      child: const Center(
        child: Text('Modal content goes here'),
      ),
    );
  }
}
