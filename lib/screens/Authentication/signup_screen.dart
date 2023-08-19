import 'package:flutter/material.dart';
import 'package:rento/screens/Authentication/phone_number.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/rento_heading.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/continue_with.dart';

class SignUpBy extends StatefulWidget {
  const SignUpBy({super.key});

  @override
  State<SignUpBy> createState() => _SignUpByState();
}

class _SignUpByState extends State<SignUpBy> {
  @override
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width30,
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // svg logo
              Flexible(
                flex: 12,
                child: Container(),
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: Dimensions.iconSize24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: Dimensions.width30 * 5),
                  const RentoHeading(),
                ],
              ),

              SizedBox(height: Dimensions.height30),

              // PHONE NUMBER INPUT
              const PhoneNumberInput(),
              // PHONE NUMBER INPUT

              SizedBox(height: Dimensions.height20),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark ? whiteColor : greyColor,
                      thickness: 0.2,
                    ),
                  ),
                  SizedBox(width: Dimensions.width8 / 2),
                  SmallText(
                    text: 'OR',
                    size: Dimensions.font16,
                  ),
                  SizedBox(width: Dimensions.width8 / 2),
                  Expanded(
                    child: Divider(
                      color: isDark ? whiteColor : greyColor,
                      thickness: 0.2,
                    ),
                  ),
                ],
              ),

              SizedBox(height: Dimensions.height20),

              // CONTINUE WITH GOOGLE
              GestureDetector(
                onTap: () {},
                child: const ContinueWith(
                  text: 'Continue with Google',
                  iconUrl: 'assets/icons/google_icon.png',
                ),
              ),
              // CONTINUE WITH GOOGLE

              SizedBox(height: Dimensions.height20),

              // CONTINUE WITH FACEBOOK
              GestureDetector(
                onTap: () {},
                child: const ContinueWith(
                  text: 'Continue with Facebook',
                  iconUrl: 'assets/icons/facebook_icon.png',
                ),
              ),
              // CONTINUE WITH FACEBOOK

              SizedBox(height: Dimensions.height20),

              // CONTINUE WITH APPLE
              GestureDetector(
                onTap: () {},
                child: ContinueWith(
                  iconUrl: 'assets/icons/apple_icon.png',
                  text: 'Continue with Apple',
                  iconColor: Theme.of(context).primaryColor,
                ),
              ),
              // CONTINUE WITH APPPLE

              Flexible(
                flex: 25,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
