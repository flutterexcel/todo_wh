import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final text;
  double size;
  final weight;
  final color;
  AppText({
    Key? key,
    required this.text,
    this.weight = FontWeight.normal,
    this.color = Colors.black,
    this.size = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: weight,
        fontSize: size,
        color: color,
        fontFamily: 'roboto',
      ),
    );
  }
}
