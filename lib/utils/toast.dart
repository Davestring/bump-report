import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

/// Display on screen a custom toast using the [message] and [color] params.
Future<void> showToast(String message, Color color) async {
  await Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 5,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
