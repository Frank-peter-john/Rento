import 'package:flutter/material.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';

class EmailInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const EmailInputField(
      {super.key,
      required this.textEditingController,
      this.isPass = false,
      required this.hintText,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(
        context,
        color: whiteColor,
      ),
      borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius20 / 2)),
    );

    return TextField(
      controller: textEditingController,
      cursorColor: primaryColor,
      style: TextStyle(color: primaryColor, fontSize: Dimensions.font16),
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: primaryColor,
          fontSize: Dimensions.font15,
        ),
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
