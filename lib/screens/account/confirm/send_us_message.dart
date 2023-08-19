import 'package:flutter/material.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/multpurpose_button.dart';
import 'package:rento/widgets/navigation.dart';

class SendUsMessage extends StatefulWidget {
  const SendUsMessage({super.key});

  @override
  State<SendUsMessage> createState() => _SendUsMessageState();
}

class _SendUsMessageState extends State<SendUsMessage> {
  final TextEditingController _textEditingController = TextEditingController();

  // THIS METHOD CHECKS IF THE MESSAGE IS VALID
  bool _isValidInput() {
    String message = _textEditingController.text.trim();
    if (message.isEmpty || message.length < 20) {
      return false;
    } else {
      return true;
    }
  }

// THIS METHOD DISPOSES THE CONTROLLERS AFTER THEY ARE USED.
  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(
        context,
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dimensions.radius20 / 2,
        ),
      ),
    );

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: Dimensions.width20,
          right: Dimensions.width20,
        ),
        child: Column(
          children: [
            //  NAVIGATION
            const TopNavigation(
              text: 'Confirm account',
              icon: Icons.arrow_back,
            ),
            // NAVIGATION

            Container(
              margin: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.width20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(
                    text: 'Send us a message',
                    size: Dimensions.font26,
                  ),
                  SizedBox(height: Dimensions.height10),
                  SmallText(
                    text:
                        "Including detailed info here will help us get you to the right person.",
                    color: primaryColor,
                  ),
                  SizedBox(height: Dimensions.height20),

                  // TEXT INPUT
                  TextField(
                    controller: _textEditingController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    cursorColor: Theme.of(context).primaryColor,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.font14,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.font15,
                      ),
                      labelText: 'Write a message...',
                      border: inputBorder,
                      focusedBorder: inputBorder,
                    ),
                    minLines: 4,
                    maxLines: 20,
                  ),
                  // TEXT INPUT
                  SizedBox(height: Dimensions.height10),

                  SmallText(
                    text: '20 characters minimum',
                    size: Dimensions.font14,
                  ),

                  SizedBox(height: Dimensions.height30),

                  // SEND BUTTON
                  _isValidInput()
                      ? GestureDetector(
                          child: const MultipurposeButton(
                            text: 'Send',
                            backgroundColor: purpleColor,
                            textColor: whiteColor,
                          ),
                        )
                      : MultipurposeButton(
                          text: 'Send',
                          backgroundColor: isDark
                              ? darkSearchBarColor
                              : buttonBackgroundColor,
                          textColor: isDark ? greyColor : whiteColor,
                        ),
                  // SEND BUTTON
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
