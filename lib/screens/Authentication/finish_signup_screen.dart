// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rento/screens/Authentication/firebase_auth_methods.dart';
import 'package:rento/screens/account/account_items/legal/payments_terms_of_service.dart';
import 'package:rento/screens/account/account_items/legal/privacy_policy.dart';
import 'package:rento/screens/account/account_items/legal/terms_of_service.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/rento_heading.dart';
import 'package:rento/utils/small_text.dart';
import '../../utils/show_snack_bar.dart';

class FinishSignUpScreen extends StatefulWidget {
  final String phoneNumber;
  const FinishSignUpScreen({super.key, required this.phoneNumber});

  @override
  State<FinishSignUpScreen> createState() => _FinishSignUpScreenState();
}

class _FinishSignUpScreenState extends State<FinishSignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _comfirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _firstName = '';
  var _lastName = '';
  var _userEmail = '';
  var _userPassword = '';
  bool _isLoading = false;

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;
  bool _termsAccepted = false;

// THIS METHOD CHECKS IF THE TERMS CHECK BOX IS TICKED.
  void _onTermsAccepted(bool? value) {
    setState(() {
      _termsAccepted = value ?? false;
    });
  }

//THIS METHOD CONTROLS PASSWORD VISIBLITY
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

//THIS METHOD  CHECKS IF PASSWORD IS NOT ALL INTEGERS
  bool hasNonNumeric(String password) {
    final RegExp regex = RegExp(r'[^0-9]');
    return regex.hasMatch(password);
  }

// THIS METHOD INVOKES ALL THE FORM VALIDATORS WHEN THE SIGNUP BUTTON IS CLICKED.
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

      String response = await FirebaseAuthMethods().signUpWithEmail(
        email: _userEmail,
        password: _userPassword,
        firstName: _firstName,
        lastName: _lastName,
        phoneNumber: widget.phoneNumber,
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

// THIS METHOD DISPOSES THE CONTROLLERS AFTER THEY ARE USED.
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _comfirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
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
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimensions.height30),

                  const Center(child: RentoHeading()),

                  SizedBox(height: Dimensions.height20),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_outlined),
                      ),
                      SizedBox(
                        width: Dimensions.width20,
                      ),
                      Center(
                        child: Text(
                          'Finish Signing up',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.font30,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.height20),

                  // FIRST NAME INPUT
                  TextFormField(
                    key: const ValueKey('firstName'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _firstName = value!;
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
                      labelText: 'First name',
                      border: inputBorder,
                      focusedBorder: inputBorder,
                    ),
                  ),

                  SizedBox(height: Dimensions.height20),

                  // LAST NAME INPUT
                  TextFormField(
                    key: const ValueKey('lastName'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _lastName = value!;
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
                      labelText: 'Last name',
                      border: inputBorder,
                      focusedBorder: inputBorder,
                    ),
                  ),

                  SizedBox(height: Dimensions.height8),

                  SmallText(
                    text:
                        "Make sure these names match those in your national ID",
                  ),
                  SizedBox(height: Dimensions.height20),

                  // EMAIL INPUT FIELD
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !value.contains('@') ||
                          !value.contains('.com') ||
                          value.contains('.com.com')) {
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
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: Dimensions.font15,
                        color: Theme.of(context).primaryColor,
                      ),
                      border: inputBorder,
                      focusedBorder: inputBorder,
                    ),
                  ),

                  SizedBox(height: Dimensions.height8),
                  SmallText(
                    text:
                        "Make sure your Email is correct, you will have to confirm it.",
                  ),
                  SizedBox(height: Dimensions.height8),

                  SmallText(
                    text:
                        "We'll send you reservation informations and confirmations.",
                  ),
                  SizedBox(height: Dimensions.height20),

                  // PASSWORD ONPUT
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return 'Password must be atleast 8 characters long.';
                      } else if (!hasNonNumeric(value)) {
                        return 'Password can not be all intergers.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    controller: _passwordController,
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
                      labelText: 'Password',
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
                      enabledBorder: inputBorder,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscured,
                    focusNode: textFieldFocusNode,
                  ),

                  SizedBox(height: Dimensions.height10),

                  // AGREE TO THE TERMS AND CONDITIONS.
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    checkColor: isDark ? blackColor : whiteColor,
                    activeColor: Theme.of(context).primaryColor,
                    selectedTileColor: Colors.transparent,
                    value: _termsAccepted,
                    onChanged: _onTermsAccepted,
                    contentPadding: const EdgeInsets.all(0),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SmallText(
                          text: "I agree to Rento's ",
                        ),
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
                          child: SmallText(
                            text: 'Terms of service, ',
                            color: blueColor,
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
                          child: SmallText(
                            text: 'privacy policy, ',
                            color: blueColor,
                          ),
                        ),
                        Row(
                          children: [
                            SmallText(
                              text: 'and ',
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) {
                                      return const PaymentsTermsOfservice();
                                    },
                                  ),
                                );
                              },
                              child: SmallText(
                                text: 'Payments terms of service.',
                                color: blueColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Dimensions.height20),

                  // SIGN UP BUTTON
                  _termsAccepted
                      ? GestureDetector(
                          onTap: _trySubmit,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height15,
                            ),
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
                                    text: "Sign Up",
                                    color: whiteColor,
                                    size: Dimensions.font15,
                                  ),
                          ),
                        )
                      : GestureDetector(
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.height15),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimensions.radius20 / 2),
                                ),
                              ),
                              color: isDark
                                  ? darkSearchBarColor
                                  : buttonBackgroundColor,
                            ),
                            child: SmallText(
                              text: "Signup",
                              size: Dimensions.font15,
                              color: isDark ? greyColor : whiteColor,
                            ),
                          ),
                        ),
                  // SIGN UP BUTTO

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
