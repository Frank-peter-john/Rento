import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:rento/screens/Authentication/login_screen.dart';
import 'package:rento/screens/property/my_properties/my_properties_screen.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/login_button.dart';

class MyPropertiesLogin extends StatelessWidget {
  const MyPropertiesLogin({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
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
            return const MyPropertiesFeed();
          } else {
            return Scaffold(
              body: Container(
                margin: EdgeInsets.only(
                  top: Dimensions.height30,
                  right: Dimensions.width20,
                  left: Dimensions.width20,
                  bottom: Dimensions.height20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        bottom: Dimensions.height10,
                      ),
                      child: BigText(
                        text: 'My properties',
                        size: Dimensions.font24,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: Dimensions.height20,
                      ),
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
                                  width: 0.2,
                                ),
                              ),
                      ),
                    ),

                    BigText(
                      text: "Log in to see properties you've rented",
                      size: Dimensions.font18,
                    ),
                    SizedBox(height: Dimensions.height10),
                    SmallText(
                      text:
                          "Once you log in, you will be able to see properties you've rented.",
                      color: greyColor,
                      size: Dimensions.font14,
                    ),

                    // LOGIN BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) {
                              return const LoginScreen();
                            },
                          ),
                        );
                      },
                      child: const LoginButton(
                        text: 'Login',
                      ),
                    ),
                    // LOGIN BUTTON
                  ],
                ),
              ),
            );
          }
        });
  }
}
