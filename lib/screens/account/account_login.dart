import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rento/screens/Authentication/login_screen.dart';
import 'package:rento/screens/Authentication/signup_screen.dart';
import 'package:rento/screens/account/account_items/legal/privacy_policy.dart';
import 'package:rento/screens/account/account_items/settings/settings_home.dart.dart';
import 'package:rento/screens/account/account_items/legal/terms_of_service.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/rento_heading.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/button.dart';

import 'account_home.dart';

class AccountLoginScreen extends StatelessWidget {
  const AccountLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarK = Theme.of(context).brightness == Brightness.dark;
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading screen if the authentication state is still loading
          return const Center(
            child: CircularProgressIndicator(
              color: purpleColor,
            ),
          );
        } else if (snapshot.hasData) {
          // User is logged in, show the home screen
          return AccountHomeScreen();
        } else {
          // Usesr is not logged in
          return Scaffold(
            body: Container(
              margin: EdgeInsets.only(
                top: Dimensions.height30,
                left: Dimensions.width20,
                right: Dimensions.width20,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: RentoHeading(),
                    ),
                    SizedBox(height: Dimensions.height20),

                    BigText(
                      text: 'My Profile',
                      size: Dimensions.font24,
                    ),
                    SizedBox(height: Dimensions.height20),

                    SmallText(
                      text: 'Login to access more services',
                      color: greyColor,
                      size: Dimensions.font15,
                    ),

                    SizedBox(height: Dimensions.height20),

                    // LOGIN BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.height20 / 1.5),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimensions.radius20 / 2),
                            ),
                          ),
                          color: purpleColor,
                        ),
                        child: SmallText(
                          text: "Login",
                          size: Dimensions.font15,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    // LOGIN BUTTON

                    SizedBox(height: Dimensions.height20),

                    // LINK TO SIGNUP PAGE
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpBy(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SmallText(
                            text: "Don't have an account?",
                            color: greyColor,
                            size: Dimensions.font14,
                          ),
                          SizedBox(width: Dimensions.width10 / 2),
                          const BigText(text: 'Sign up'),
                        ],
                      ),
                    ),
                    // LINK TO SIGNUP PAGE

                    SizedBox(height: Dimensions.height30),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SETTINGS
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return const Settings();
                                },
                              ),
                            );
                          },
                          child: const Button(
                            color: whiteColor,
                            iconLeft: Icons.settings_outlined,
                            text: "Settings ",
                            iconRight: Icons.arrow_forward_ios,
                          ),
                        ),

                        //Learn about hosting
                        GestureDetector(
                          onTap: () {},
                          child: const Button(
                            color: whiteColor,
                            iconLeft: CupertinoIcons.book,
                            text: "Learn about renting",
                            iconRight: Icons.arrow_forward_ios,
                          ),
                        ),

                        // FAQ'S
                        GestureDetector(
                          onTap: () {},
                          child: const Button(
                            color: whiteColor,
                            iconLeft: CupertinoIcons.question_circle,
                            text: "Get help",
                            iconRight: Icons.arrow_forward_ios,
                          ),
                        ),

                        // TERMS OF SERVICE
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return const TermsOfService();
                                },
                              ),
                            );
                          },
                          child: const Button(
                            color: whiteColor,
                            iconLeft: CupertinoIcons.book,
                            text: "Terms of service",
                            iconRight: Icons.arrow_forward_ios,
                          ),
                        ),

                        // PRIVACY POLICY
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return const PrivacyPolicy();
                                },
                              ),
                            );
                          },
                          child: const Button(
                            color: whiteColor,
                            iconLeft: CupertinoIcons.lock,
                            text: "Privacy policy",
                            iconRight: Icons.arrow_forward_ios,
                          ),
                        ),
                      ],
                    ),
                    // PROFILE MENUS

                    SizedBox(height: Dimensions.height10),

                    // VERSION NUMBER
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
                        if (snapshot.hasData) {
                          return SmallText(
                            text: 'Version ${snapshot.data!.version}',
                            color: isDarK ? greyColor : blackColor,
                            size: Dimensions.font12,
                          );
                        } else {
                          return const CircularProgressIndicator(
                            color: purpleColor,
                          );
                        }
                      },
                    ),
                    //  VERSION NUMBER
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
