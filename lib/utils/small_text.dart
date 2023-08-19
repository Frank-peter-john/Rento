import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  double height;

  SmallText({
    Key? key,
    this.color,
    this.height = 1.2,
    this.size = 15,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: 'Circular',
        fontSize: size,
        height: height,
      ),
      textAlign: TextAlign.justify,
      overflow: TextOverflow.clip,
    );
  }
}
