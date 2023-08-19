import 'package:flutter/material.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';

class Button extends StatelessWidget {
  final Color? color;
  final String text;
  final IconData? iconLeft;
  final IconData? iconRight;
  const Button({
    super.key,
    this.color,
    required this.text,
    this.iconLeft,
    this.iconRight,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(
        bottom: Dimensions.height10,
      ),
      width: Dimensions.width350 * 2.5,
      height: Dimensions.height20 * 2,
      decoration: BoxDecoration(
        border: Border(
          bottom: isDark
              ? const BorderSide(
                  color: greyColor,
                  width: 0.5,
                )
              : const BorderSide(
                  color: greyColor,
                  width: 0.3,
                ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.height10),
        child: Row(
          children: [
            Icon(
              iconLeft,
              color: Theme.of(context).primaryColor,
              size: Dimensions.iconSize20,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: Dimensions.width20),
                child: SmallText(
                  text: text,
                  size: Dimensions.font15,
                ),
              ),
            ),
            Icon(
              iconRight,
              color: Theme.of(context).primaryColor,
              size: Dimensions.iconSize20,
            ),
          ],
        ),
      ),
    );
  }
}
