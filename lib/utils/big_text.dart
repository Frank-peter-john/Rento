import 'package:flutter/material.dart';
import 'package:rento/utils/dimensions.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;

  final double? size;
  final TextOverflow overFlow;

  const BigText({
    Key? key,
    this.color,
    this.size,
    required this.text,
    this.overFlow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: TextStyle(
        color: color,
        fontFamily: 'Circular',
        fontWeight: FontWeight.bold,
        fontSize: size == 0 ? Dimensions.font20 : size,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
