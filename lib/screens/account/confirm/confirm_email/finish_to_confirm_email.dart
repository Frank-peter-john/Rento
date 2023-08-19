// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rento/screens/main/main_screen.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/show_snack_bar.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/login_button.dart';

class FinishToComfirmEmail extends StatefulWidget {
  const FinishToComfirmEmail({super.key});

  @override
  State<FinishToComfirmEmail> createState() => _FinishToComfirmEmailState();
}

class _FinishToComfirmEmailState extends State<FinishToComfirmEmail> {
  final _auth = FirebaseAuth.instance;
  bool _isEmailConfirmed = false;

// THIS METHOD CHECKS IF THE EMAIL IS VERIFIED
  Future<void> checkEmailVerificationStatus() async {
    User user = _auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      setState(() {
        _isEmailConfirmed = true;
      });
      showSnackBar(
        context,
        'Your Email has been confirmed. click finish to continue using the app.',
      );
    } else {
      showSnackBar(
        context,
        'Sorry, we are still verifying your Email.',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkEmailVerificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: Dimensions.height10 / 2),
                  child: BigText(
                    text: 'Confirm Email',
                    size: Dimensions.font18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height30),
            SmallText(
              text:
                  "We've  sent a link to your Email. Please click the link to confirm your Email before you click Done.",
              size: Dimensions.font14,
            ),
            SizedBox(height: Dimensions.height20),

            SmallText(
              text:
                  ' 1. After confirming your Email, click done and wait for the process to complete.',
            ),

            SizedBox(height: Dimensions.height8),

            SmallText(
              text:
                  " 2. If the finish button does not appear, click done again.",
              color: Theme.of(context).primaryColor,
            ),

            SizedBox(height: Dimensions.height20),

            // SEND LINK AGAIN
            Row(
              children: [
                SmallText(
                  text: "Did not receive link?",
                ),
                SizedBox(width: Dimensions.width10),
                GestureDetector(
                  onTap: () {
                    _auth.currentUser!.sendEmailVerification();
                    showSnackBar(
                      context,
                      "An Email confirmation link have been sent to your Email.",
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: isDark
                          ? const Border(
                              bottom: BorderSide(
                                color: whiteColor,
                                // style: BorderStyle.solid,
                                width: 0.5,
                              ),
                            )
                          : const Border(
                              bottom: BorderSide(
                                color: greyColor,
                                // style: BorderStyle.solid,
                                width: 0.5,
                              ),
                            ),
                    ),
                    child: BigText(
                      text: 'Send link again',
                      size: Dimensions.font15,
                    ),
                  ),
                ),
              ],
            ),
            // SEND LINK AGAIN

            SizedBox(height: Dimensions.height20),

            // FINISH BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: checkEmailVerificationStatus,
                  child: LoginButton(
                    text: 'Done',
                    textColor: whiteColor,
                    color: isDark ? darkGrey : blackColor,
                  ),
                ),
                _isEmailConfirmed
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return const MainScreen();
                          }));
                        },
                        child: const LoginButton(
                          text: 'Finish',
                        ),
                      )
                    : const CircularProgressIndicator(
                        color: purpleColor,
                      ),
              ],
            ),
            // FINISH BUTTON
          ],
        ),
      ),
    );
  }
}
