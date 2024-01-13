// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rento/screens/Authentication/firebase_auth_methods.dart';
import 'package:rento/screens/Authentication/forgotPassword/forgot_password_screen.dart';
import 'package:rento/screens/Authentication/signup_screen.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/rento_heading.dart';
import 'package:rento/utils/show_snack_bar.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/continue_with.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userPassword = '';
  bool _isLoading = false;

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  // THIS METHOD INVOKES ALL THE FORM VALIDATORS WHEN THE LOGIN BUTTON IS CLICKED.
  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    /* Remove the cursor on submiting the form  */
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      // this triggers all the save functions in the form
      _formKey.currentState!.save();

      // use the values to send auth request.
      String response = await FirebaseAuthMethods().loginWithEmail(
        email: _userEmail,
        password: _userPassword,
        context: context,
      );

      setState(() {
        _isLoading = false;
      });

      if (response != 'success') {
        showSnackBar(context, response);
      }
    }
  }

// THIS METHOD CONTROLS PASSWORD VISIBILITY
  void _toggleObscured() {
    setState(
      () {
        _obscured = !_obscured;
        if (textFieldFocusNode.hasPrimaryFocus) {
          return; // If focus is on text field, don't unfocus
        }
        textFieldFocusNode.canRequestFocus =
            false; // Prevents focus if tap on eye
      },
    );
  }

// THIS METHOD DISPOSES THE CONTROLLERS AFTER THEY ARE USED.
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // DEFINING THE INPUT BORDER STRUCTURE
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(
        context,
        color: Theme.of(context).primaryColor,
        width: 0.5,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dimensions.radius20 / 2,
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: Dimensions.height30),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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

                  // EMAIL INPUT FIELD
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "The email field can not be empty";
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email address.';
                      } else if (value.contains('.com.com')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Theme.of(context).primaryColor,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.font16,
                    ),
                    decoration: InputDecoration(
                      labelText: 'email',
                      labelStyle: TextStyle(
                        fontSize: Dimensions.font15,
                        color: Theme.of(context).primaryColor,
                      ),
                      border: inputBorder,
                      focusedBorder: inputBorder,
                    ),
                  ),

                  SizedBox(height: Dimensions.height20),

                  // PASSWORD INPUT
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "The password field can not be empty";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    cursorColor: Theme.of(context).primaryColor,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.font16,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.font15,
                      ),
                      labelText: 'password',
                      border: inputBorder,
                      suffixIcon: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                            _obscured
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: Dimensions.iconSize24,
                            color: greyColor),
                      ),
                      focusedBorder: inputBorder,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscured,
                    focusNode: textFieldFocusNode,
                  ),

                  SizedBox(height: Dimensions.height20),

                  // LOGIN BUTTON
                  GestureDetector(
                    onTap: _trySubmit,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.height15),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              Dimensions.radius20 / 2,
                            ),
                          ),
                        ),
                        color: purpleColor,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: Dimensions.width20,
                              height: Dimensions.height20,
                              child: const CircularProgressIndicator(
                                color: whiteColor,
                                strokeWidth: 2.5,
                              ),
                            )
                          : SmallText(
                              text: "Login",
                              size: Dimensions.font15,
                              color: whiteColor,
                            ),
                    ),
                  ),
                  // LOGIN BUTTON

                  Container(
                    margin: EdgeInsets.only(
                      top: Dimensions.height10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // FORGOT PASSWORD LINK
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return const ForgotPassword();
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
                            child: SmallText(
                              text: 'Forgot password',
                              size: Dimensions.font15,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),

                        // NAVIGATE USER TO SIGN UP PAGE
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return const SignUpBy();
                                },
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SmallText(
                                text: "Don't have an account?",
                                size: Dimensions.font15,
                                color: greyColor,
                              ),
                              SizedBox(width: Dimensions.width10 / 2),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: const BigText(text: 'Sign up'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: Dimensions.height30 * 2),

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
                  // CONTINUE WITH APPLE
                  SizedBox(height: Dimensions.height30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
