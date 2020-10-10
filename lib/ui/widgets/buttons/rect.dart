import 'package:flutter/material.dart';

class RectButton extends StatelessWidget {
  /// Creates a rounded-rectangulargle icon button.
  ///
  /// The [icon] argument must not be null.
  const RectButton({
    Key key,
    @required this.icon,
    this.backgroundColor,
    this.height,
    this.iconColor,
    this.iconSize,
    this.margin,
    this.onClick,
    this.splashColor,
    this.width,
  })  : assert(icon != null),
        super(key: key);

  final Color backgroundColor;
  final Color iconColor;
  final Color splashColor;
  final EdgeInsets margin;
  final Function onClick;
  final IconData icon;
  final double height;
  final double iconSize;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          color: backgroundColor,
          child: InkWell(
            onTap: onClick as void Function(),
            splashColor: splashColor,
            child: SizedBox(
              height: height,
              width: width,
              child: Icon(
                icon,
                color: iconColor,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
