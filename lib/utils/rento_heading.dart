import 'package:flutter/material.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';

class RentoHeading extends StatelessWidget {
  const RentoHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return BigText(
      text: 'Rento',
      size: Dimensions.font30,
      color: purpleColor,
    );
  }
}
