import 'package:flutter/material.dart';

class RegularButton extends StatelessWidget {
  const RegularButton({
    Key key,
    @required this.label,
    @required this.onClick,
    this.isUpdating,
    this.margin,
  }) : super(key: key);

  final EdgeInsets margin;
  final Function onClick;
  final String label;
  final bool isUpdating;

  Widget _renderer() {
    if (isUpdating) {
      return const SizedBox(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
      );
    }

    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: margin,
      child: ButtonTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: FlatButton(
          color: Colors.blueGrey,
          onPressed: onClick as void Function(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: _renderer(),
          ),
        ),
      ),
    );
  }
}
