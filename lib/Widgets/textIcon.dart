import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appText.dart';

class TextIcon extends StatelessWidget {
  final text;
  final icon;
  double iconSize;
  final color;
  TextIcon(
      {Key? key,
      this.text = "",
      this.icon,
      this.iconSize = 20,
      this.color = Colors.blueAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Icon(
            icon,
            size: iconSize,
            color: color,
          ),
          SizedBox(
            height: 8,
          ),
          AppText(
            text: text,
            color: color,
            size: 16,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
