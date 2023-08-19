import 'package:flutter/material.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';

class MultipurposeButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const MultipurposeButton({
    super.key,
    required this.text,
    this.backgroundColor = purpleColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.width30 * 3,
      alignment: Alignment.center,
      padding: EdgeInsets.all(Dimensions.height7),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.radius20 / 2),
          ),
        ),
        color: backgroundColor,
      ),
      child: SmallText(
        text: text,
        color: textColor,
        size: Dimensions.font15,
      ),
    );
  }
}
