import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rento/screens/Authentication/login_screen.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/show_snack_bar.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/multpurpose_button.dart';

class FinishForgotPassword extends StatelessWidget {
  final String email;
  FinishForgotPassword({super.key, required this.email});

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
                    text: 'Forgot password',
                    size: Dimensions.font18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.height30),
            SmallText(
              text: "We've  sent a password reset email to $email",
              size: Dimensions.font14,
            ),
            SizedBox(height: Dimensions.height20),

            // SEND LINK AGAIN
            Row(
              children: [
                SmallText(
                  text: "Did not receive link?",
                  size: Dimensions.font14,
                ),
                SizedBox(width: Dimensions.width10),
                GestureDetector(
                  onTap: () {
                    _auth.currentUser!.sendEmailVerification();
                    showSnackBar(
                      context,
                      "A password reset link sent to $email.",
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).primaryColor,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return const LoginScreen();
                    }));
                  },
                  child: const MultipurposeButton(
                    text: 'Ok',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
