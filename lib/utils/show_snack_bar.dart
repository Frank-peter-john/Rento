import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimensions.dart';
import 'small_text.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: SmallText(
        text: text,
        color: whiteColor,
        size: Dimensions.font14,
      ),
      backgroundColor: purpleColor,
    ),
  );
}
