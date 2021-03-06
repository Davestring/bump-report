import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:bump_report/services/index.dart' show StorageService;
import 'package:bump_report/ui/widgets/index.dart' show InputText;
import 'package:bump_report/ui/widgets/index.dart' show InputPicture;
import 'package:bump_report/ui/widgets/index.dart' show RegularButton;
import 'package:bump_report/utils/index.dart' show showToast;
import 'package:bump_report/services/index.dart' show getIt;

class Report extends StatefulWidget {
  const Report({
    Key key,
    @required this.latitude,
    @required this.longitude,
  })  : assert(latitude != null),
        assert(longitude != null),
        super(key: key);

  final double latitude;
  final double longitude;

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  AutovalidateMode _autovalidate;

  bool _loading;

  /// Verify if the form is success, if `true` it will create a new document
  /// with the data captured from the user, otherwise will display the form
  /// errors to the user.
  Future<void> _onCreateReport() async {
    if (!_loading && _fbKey.currentState.saveAndValidate()) {
      try {
        setState(() {
          _loading = true;
        });

        final StorageService storage = getIt<StorageService>();
        final Map<String, dynamic> values = _fbKey.currentState.value;
        final List<int> bts = values['image'][0].readAsBytesSync() as List<int>;
        final Map<String, dynamic> payload = <String, dynamic>{
          'address': values['address'],
          'coords': GeoPoint(
            double.parse(values['latitude'] as String),
            double.parse(values['longitude'] as String),
          ),
          'createdAt': DateTime.now(),
          'image': 'data:image/jpeg;charset=utf-8;base64,${base64Encode(bts)}',
          'status': 0,
          'userId': storage.userId,
        };

        await FirebaseFirestore.instance.collection('bump').add(payload);

        await showToast('Report created succesfully', Colors.green);
      } catch (_) {
        await showToast('Ups! an error occurred, try again later', Colors.red);
      } finally {
        setState(() {
          _loading = false;
        });
      }
      return;
    }

    setState(() {
      _autovalidate = AutovalidateMode.always;
    });
  }

  @override
  void initState() {
    super.initState();

    _autovalidate = AutovalidateMode.disabled;
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      height: deviceHeight * 0.8,
      child: FormBuilder(
        autovalidateMode: _autovalidate,
        initialValue: <String, dynamic>{
          'latitude': widget.latitude.toString(),
          'longitude': widget.longitude.toString(),
        },
        key: _fbKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                width: deviceWidth,
                child: CloseButton(
                  color: Colors.blueGrey[800],
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Container(
                width: deviceWidth,
                child: Text(
                  'Bump Report',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey[600],
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InputText(
                attributeName: 'latitude',
                inputMargin: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 12.0),
                inputWidth: deviceWidth * 0.50,
                label: 'Latitude',
                inputValidators: <String Function(dynamic)>[
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ],
              ),
              InputText(
                attributeName: 'longitude',
                inputMargin: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 12.0),
                inputWidth: deviceWidth * 0.50,
                label: 'Longitude',
                inputValidators: <String Function(dynamic)>[
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ],
              ),
              InputText(
                attributeName: 'address',
                inputMargin: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 4.0),
                inputWidth: deviceWidth,
                label: 'Address',
                textCapitalization: TextCapitalization.sentences,
                inputValidators: <String Function(dynamic)>[
                  FormBuilderValidators.required(),
                ],
              ),
              InputPicture(
                attributeName: 'image',
                inputMargin: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 12.0),
                label: 'Bump Picture',
                inputValidators: <String Function(dynamic)>[
                  FormBuilderValidators.required(),
                ],
              ),
              RegularButton(
                label: 'Create Report',
                isUpdating: _loading,
                margin: const EdgeInsets.symmetric(horizontal: 25.0),
                onClick: _onCreateReport,
              ),
              Container(
                margin: const EdgeInsets.only(top: 12.0, bottom: 25.0),
                width: deviceWidth,
                child: const Text(
                  'Version v1.1.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
