import 'package:flutter/material.dart';
import 'package:rento/screens/Authentication/firebase_auth_methods.dart';
import 'package:rento/screens/account/confirm/send_us_message.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';

class ConfirmEmail extends StatelessWidget {
  const ConfirmEmail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.width20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  NAVIGATION
            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: isDark
                      ? const Border(
                          bottom: BorderSide(
                            color: greyColor,
                            // style: BorderStyle.solid,
                            width: 0.5,
                          ),
                        )
                      : const Border(
                          bottom: BorderSide(
                            color: greyColor,
                            // style: BorderStyle.solid,
                            width: 0.3,
                          ),
                        ),
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: Dimensions.height10 / 2),
                  child: BigText(
                    text: 'Confirm Account',
                    size: Dimensions.font18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            // NAVIGATION
            SizedBox(height: Dimensions.height20),
            BigText(
              text: 'Let us Know its really you',
              size: Dimensions.font18,
            ),
            SizedBox(height: Dimensions.height10),
            SmallText(
              text:
                  "To continue, you will have to confirm your account through your Email.",
            ),
            SizedBox(height: Dimensions.height20),

            // CONFIRM BUTTON
            GestureDetector(
              onTap: () {
                FirebaseAuthMethods().sendEmailVerification(
                  context: context,
                );
              },
              child: Container(
                width: Dimensions.width350,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height15,
                  horizontal: Dimensions.width20,
                ),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimensions.radius20 / 2),
                    ),
                  ),
                  color: isDark ? purpleColor : blackColor,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: Dimensions.iconSize20,
                      color: whiteColor,
                    ),
                    SizedBox(width: Dimensions.height20),
                    SmallText(
                      text: "Confirm my Email",
                      size: Dimensions.font16,
                      color: whiteColor,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Dimensions.height20),

            // NEED HELP SECTION
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return const SendUsMessage();
                    },
                  ),
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
                  text: 'Need help?',
                  size: Dimensions.font14,
                ),
              ),
            ),
            // NEED HELP SECTION
          ],
        ),
      ),
    );
  }
}
