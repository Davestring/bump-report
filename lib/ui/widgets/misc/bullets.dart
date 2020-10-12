import 'package:flutter/material.dart';

class Bullets extends StatelessWidget {
  const Bullets({
    Key key,
    @required this.active,
    @required this.length,
    this.bulletSize = 8.0,
    this.margin,
  })  : assert(active != null),
        assert(length != null),
        super(key: key);

  final EdgeInsets margin;
  final double bulletSize;
  final int active;
  final int length;

  Color _getbulletColor(int target) {
    if (active == target) {
      return Colors.blueGrey;
    }
    return Colors.blueGrey.withOpacity(0.2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
          length,
          (int index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            height: bulletSize,
            width: bulletSize,
            decoration: BoxDecoration(
              color: _getbulletColor(index),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
