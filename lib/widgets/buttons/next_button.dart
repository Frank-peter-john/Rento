import 'package:flutter/material.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';

class NextButton extends StatelessWidget {
  final String text;

  const NextButton({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.height20),
      width: Dimensions.width30 * 7,
      alignment: Alignment.center,
      padding: EdgeInsets.all(Dimensions.height10),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                Dimensions.radius20 / 2,
              ),
            ),
          ),
          color: purpleColor1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SmallText(
            text: text,
            size: Dimensions.font15,
            color: whiteColor,
          ),
          Icon(
            Icons.arrow_forward_rounded,
            size: Dimensions.iconSize20,
            color: whiteColor,
          ),
        ],
      ),
    );
  }
}
