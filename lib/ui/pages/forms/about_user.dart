import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:bump_report/services/index.dart' show StorageService;
import 'package:bump_report/ui/screens/index.dart' show MapScreen;
import 'package:bump_report/ui/widgets/index.dart' show InputText;
import 'package:bump_report/ui/widgets/index.dart' show RegularButton;
import 'package:bump_report/ui/widgets/index.dart' show Template;
import 'package:bump_report/utils/index.dart' show showToast;
import 'package:bump_report/services/index.dart' show getIt;

class AboutUser extends StatefulWidget {
  const AboutUser({
    Key key,
    @required this.scaffoldKey,
  })  : assert(scaffoldKey != null),
        super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _AboutUserState createState() => _AboutUserState();
}

class _AboutUserState extends State<AboutUser> {
  final CollectionReference _db = FirebaseFirestore.instance.collection('user');
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
        final Map<String, dynamic> payload = <String, dynamic>{
          'name': values['name'].trim(),
          'lastname': values['lastname'].trim(),
          'email': values['email'].trim(),
        };

        final QuerySnapshot snapshot =
            await _db.where('email', isEqualTo: payload['email']).get();

        if (snapshot.docs.isEmpty) {
          final DocumentReference ref = await _db.add(payload);
          storage.userId = ref.id;
        } else {
          storage.userId = snapshot.docs.first.id;
        }

        await showToast('We registered your data succesfully', Colors.green);
      } catch (_) {
        await showToast('Ups! an error occurred, try again later', Colors.red);
        return;
      } finally {
        setState(() {
          _loading = false;
        });
      }

      await Navigator.pushNamedAndRemoveUntil(
        widget.scaffoldKey.currentContext,
        MapScreen.routeName,
        (_) => false,
      );
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
    final double deviceWidth = MediaQuery.of(context).size.width;

    return FormBuilder(
      autovalidateMode: _autovalidate,
      key: _fbKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(25.0),
              child: const Template(
                title: 'Welcome!',
                description: 'Before continue please tell us about you..',
                icon: Icons.thumb_up_outlined,
              ),
            ),
            InputText(
              attributeName: 'name',
              inputMargin: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 12.0),
              inputWidth: deviceWidth * 0.50,
              label: 'Name(s)',
              textCapitalization: TextCapitalization.sentences,
              inputValidators: <String Function(dynamic)>[
                FormBuilderValidators.required(),
              ],
            ),
            InputText(
              attributeName: 'lastname',
              inputMargin: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 12.0),
              inputWidth: deviceWidth * 0.50,
              label: 'Lastname',
              textCapitalization: TextCapitalization.sentences,
              inputValidators: <String Function(dynamic)>[
                FormBuilderValidators.required(),
              ],
            ),
            InputText(
              attributeName: 'email',
              inputMargin: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 25.0),
              inputWidth: deviceWidth * 0.66,
              label: 'Email',
              inputValidators: <String Function(dynamic)>[
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ],
            ),
            RegularButton(
              label: 'Continue',
              isUpdating: _loading,
              margin: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 25.0),
              onClick: _onCreateReport,
            ),
          ],
        ),
      ),
    );
  }
}
