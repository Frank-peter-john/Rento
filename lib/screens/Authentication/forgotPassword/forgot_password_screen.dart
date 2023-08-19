import 'package:flutter/material.dart';
import 'package:rento/screens/Authentication/firebase_auth_methods.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/login_button.dart';
import 'package:rento/widgets/navigation.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var _userEmail = '';
  final _formKey = GlobalKey<FormState>();

  // THIS METHOD INVOKES ALL THE FORM VALIDATORS WHEN THE SIGNUP BUTTON IS CLICKED.
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();

    /* Remove the cursor on submiting the form  */
    FocusScope.of(context).unfocus();

    if (isValid) {
      // this triggers all the save functions in the form
      _formKey.currentState!.save();

      // use the values to send auth request.
      FirebaseAuthMethods().forgotPassword(
        email: _userEmail,
        context: context,
      );
    }
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
      body: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height20,
          left: Dimensions.width20,
          right: Dimensions.width20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopNavigation(
                text: "Forgot password",
                icon: Icons.arrow_back,
              ),
              SizedBox(height: Dimensions.height20),
              SmallText(
                text:
                    'Enter your Email. We will Email you a link to change your password. ',
                size: Dimensions.font14,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: Dimensions.height10),

              // EMAIL INPUT FIELD
              TextFormField(
                key: const ValueKey('email'),
                validator: (value) {
                  if (value!.isEmpty ||
                      !value.contains('@') ||
                      !value.contains('.com')) {
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
                  enabledBorder: inputBorder,
                ),
              ),

              SizedBox(height: Dimensions.height30),
              GestureDetector(
                onTap: _trySubmit,
                child: LoginButton(
                  text: 'Submit',
                  color: isDark ? purpleColor1 : blackColor,
                  textColor: whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
