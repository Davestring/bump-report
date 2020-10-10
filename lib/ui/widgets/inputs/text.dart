import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

class InputText extends StatelessWidget {
  const InputText({
    Key key,
    @required this.attributeName,
    this.inputMargin,
    this.inputWidth,
    this.inputValidators,
    this.label,
    this.textCapitalization = TextCapitalization.none,
  })  : assert(attributeName != null),
        super(key: key);

  final EdgeInsets inputMargin;
  final List<String Function(dynamic)> inputValidators;
  final String attributeName;
  final String label;
  final TextCapitalization textCapitalization;
  final double inputWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.blueGrey[50],
      ),
      margin: inputMargin,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: inputWidth,
      child: FormBuilderTextField(
        attribute: attributeName,
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          labelText: label,
          border: InputBorder.none,
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
        ),
        textCapitalization: textCapitalization,
        validators: inputValidators ?? <String Function(dynamic)>[],
      ),
    );
  }
}
