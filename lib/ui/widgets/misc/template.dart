import 'package:flutter/material.dart';

class Template extends StatelessWidget {
  const Template({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.description,
    this.margin,
  })  : assert(icon != null),
        assert(title != null),
        assert(description != null),
        super(key: key);

  final EdgeInsets margin;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.blueGrey[200],
            size: 160.0,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              description,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
