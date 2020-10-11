import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key key,
    @required this.color,
  })  : assert(color != null),
        super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
