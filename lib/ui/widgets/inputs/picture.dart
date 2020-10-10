import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

class InputPicture extends StatelessWidget {
  const InputPicture({
    Key key,
    @required this.attributeName,
    this.inputMargin,
    this.inputValidators,
    this.label,
    this.imageMaxHeight = 800.0,
    this.imageMaxWidth = 800.0,
    this.imageWidth = 130.0,
  })  : assert(attributeName != null),
        super(key: key);

  final EdgeInsets inputMargin;
  final List<String Function(dynamic)> inputValidators;
  final String attributeName;
  final String label;
  final double imageMaxHeight;
  final double imageMaxWidth;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: inputMargin,
      width: imageWidth,
      child: FormBuilderImagePicker(
        attribute: attributeName,
        decoration: const InputDecoration(
          border: InputBorder.none,
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
        ),
        iconColor: Colors.blueGrey[300],
        imageWidth: imageWidth,
        labelText: label,
        maxHeight: imageMaxHeight,
        maxWidth: imageMaxWidth,
        maxImages: 1,
        validators: inputValidators ?? <String Function(dynamic)>[],
      ),
    );
  }
}
