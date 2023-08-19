import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:rento/widgets/buttons/button.dart';
import '../../utils/big_text.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/small_text.dart';
import '../../widgets/buttons/add_property_button.dart';
import '../../widgets/buttons/multpurpose_button.dart';
import '../property/rent_your_property/rent_home.dart';
import 'account_items/legal/privacy_policy.dart';
import 'account_items/settings/themes/theme_provider.dart';
import 'account_items/legal/terms_of_service.dart';
import 'account_items/profile/profile_screen.dart';

class AccountHomeScreen extends StatelessWidget {
  AccountHomeScreen({super.key});
  final User currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          String firstName = data['firstname'];
          String imageUrl =
              data.containsKey('imageUrl') ? data['imageUrl'] : '';
          return Scaffold(
            body: Container(
              margin: EdgeInsets.only(
                top: Dimensions.width20,
                left: Dimensions.width10,
                right: Dimensions.width10,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: BigText(
                        text: 'My account',
                        size: Dimensions.font26,
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return ProfileScreen();
                        }));
                      },
                      child: Row(
                        children: [
                          //  USER'S PROFILE IMAGE
                          imageUrl.isNotEmpty
                              ? CircleAvatar(
                                  radius: Dimensions.radius20 * 2,
                                  backgroundImage: NetworkImage(imageUrl),
                                  backgroundColor:
                                      isDark ? darkGrey : buttonBackgroundColor,
                                )
                              : CircleAvatar(
                                  radius: Dimensions.radius20 * 2,
                                  backgroundColor: purpleColor1,
                                  child: SmallText(
                                    text: firstName[0].toUpperCase(),
                                    color: whiteColor,
                                    size: Dimensions.font26,
                                  ),
                                ),

                          SizedBox(width: Dimensions.height15),

                          // USER'S FIRSTNAME
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(
                                  text: firstName,
                                  size: Dimensions.font18,
                                ),
                                SizedBox(height: Dimensions.height7 / 2),
                                SmallText(
                                  text: 'Show profile',
                                  color: greyColor,
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            Icons.arrow_forward_ios,
                            size: Dimensions.iconSize22,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: Dimensions.height20,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: isDark
                              ? const BorderSide(
                                  color: greyColor,
                                  width: 0.5,
                                )
                              : const BorderSide(
                                  color: greyColor,
                                  width: 0.3,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),

                    // ADD PROPERTY BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const RentHomeScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: const RentHomeScreen(),
                              );
                            },
                          ),
                        );
                      },
                      child: const AddPropertyButton(),
                    ),
                    // ADD PROPERTY BBUTTON

                    SizedBox(height: Dimensions.height30),

                    // SETTINGS SECTION
                    BigText(
                      text: 'Settings',
                      size: Dimensions.font18,
                    ),
                    SizedBox(height: Dimensions.height20),

                    // CHANGE THEME
                    Padding(
                      padding: EdgeInsets.only(right: Dimensions.width20),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: isDark
                                ? const BorderSide(
                                    color: greyColor,
                                    width: 0.5,
                                  )
                                : const BorderSide(
                                    color: greyColor,
                                    width: 0.3,
                                  ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.wb_sunny_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: Dimensions.width20),
                            Expanded(
                              child: SmallText(
                                text: 'Change theme',
                                size: Dimensions.font15,
                              ),
                            ),
                            Consumer<ThemeProvider>(
                                builder: (context, provider, child) {
                              return DropdownButton<String>(
                                value: provider.currentTheme,
                                underline: Container(),
                                iconEnabledColor: purpleColor,
                                iconSize: Dimensions.iconSize30,
                                alignment: AlignmentDirectional.bottomStart,
                                focusColor: Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius15),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'light',
                                    child: BigText(
                                      text: 'Light',
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'dark',
                                    child: BigText(
                                      text: 'Dark',
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'system',
                                    child: BigText(
                                      text: 'System',
                                    ),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  provider.changeTheme(value ?? 'system');
                                },
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                    // CHANGE THEME

                    SizedBox(height: Dimensions.height20),

                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: FontAwesomeIcons.language,
                        text: "Change language",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: CupertinoIcons.profile_circled,
                        text: "Personal information",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: Icons.security_outlined,
                        text: "Two factor authentication",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: Icons.notifications_outlined,
                        text: "Notifications",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    // SETTINGS SECTION

                    SizedBox(height: Dimensions.height20),

                    // RENTING SECTION
                    BigText(
                      text: 'Renting',
                      size: Dimensions.font18,
                    ),
                    SizedBox(height: Dimensions.height20),
                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: Icons.house_outlined,
                        text: "Learn about renting & leasing",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: Icons.people_alt_outlined,
                        text: "Refer a friend and get a commision",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    // RENTING SECTION

                    SizedBox(height: Dimensions.height20),

                    // SUPPORT SECTION
                    BigText(
                      text: 'Support',
                      size: Dimensions.font18,
                    ),
                    SizedBox(height: Dimensions.height20),
                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: Icons.add_home_outlined,
                        text: "How Rento works",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: CupertinoIcons.question_circle,
                        text: "Get help",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: CupertinoIcons.question,
                        text: "FAQ'S",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    // SUPPORT SECTION

                    SizedBox(height: Dimensions.height20),

                    // LEGAL SECTION
                    BigText(
                      text: 'Legal',
                      size: Dimensions.font18,
                    ),
                    SizedBox(height: Dimensions.height20),

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
                    SizedBox(height: Dimensions.height20),

                    // LOG OUT BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const BigText(
                                    text: 'Logout',
                                  ),
                                  content: SmallText(
                                    text: 'Are you sure you want to log out?',
                                    size: Dimensions.font14,
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // CANCEL LOGOUT
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: MultipurposeButton(
                                            text: "Cancel",
                                            backgroundColor:
                                                isDark ? darkGrey : blackColor,
                                            textColor: whiteColor,
                                          ),
                                        ),

                                        // LOGOUT
                                        GestureDetector(
                                          onTap: () {
                                            FirebaseAuth.instance.signOut();
                                            Navigator.of(context).pop();
                                          },
                                          child: const MultipurposeButton(
                                            text: "Logout",
                                            backgroundColor: purpleColor,
                                            textColor: whiteColor,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
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
                            child: const BigText(text: 'Log out'),
                          ),
                        ),
                        // LOG OUT BUTTON

                        // VERSION NUMBER
                        FutureBuilder<PackageInfo>(
                          future: PackageInfo.fromPlatform(),
                          builder:
                              (context, AsyncSnapshot<PackageInfo> snapshot) {
                            if (snapshot.hasData) {
                              return SmallText(
                                text: 'Version ${snapshot.data!.version}',
                                color: isDark ? greyColor : blackColor,
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

                    SizedBox(height: Dimensions.height30),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmallText(
                    text: 'Oops!, something went wrong',
                    size: Dimensions.font18,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: SizedBox(
              height: Dimensions.height30 * 2,
              width: Dimensions.width30 * 2,
              child: const CircularProgressIndicator(
                color: purpleColor,
              ),
            ),
          );
        }
      },
    );
  }
}
