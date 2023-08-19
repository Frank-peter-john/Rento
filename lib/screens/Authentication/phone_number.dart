import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:rento/screens/Authentication/finish_signup_screen.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({super.key});

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  final TextEditingController phoneNumberController = TextEditingController();
  String _selectedCountryCode = '';

  // THIS METHOD CHECKS IF THE PHONE NUMBER IS VALID
  bool _isValidPhoneNumber() {
    String phoneNumber = phoneNumberController.text.trim();
    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      return false;
    } else {
      return true;
    }
  }

  // THIS METHOD DISPOSES THE CONTROLLERS AFTER THEY ARE USED.
  @override
  void dispose() {
    super.dispose();
    phoneNumberController.dispose();
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // COUNTRY CODE PICKER
        CountryCodePicker(
          textStyle: TextStyle(
            fontSize: Dimensions.font20,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
          dialogBackgroundColor: isDark ? darkSearchBarColor : whiteColor,
          dialogSize: Size(
            Dimensions.width20 * 2.5,
            Dimensions.height120 * 3.5,
          ),
          barrierColor: isDark
              ? const Color.fromARGB(20, 158, 158, 158)
              : Colors.transparent,
          showFlagMain: true,
          showDropDownButton: true,
          showFlag: true,
          initialSelection: 'TZ',
          onChanged: (CountryCode countryCode) {
            setState(() {
              _selectedCountryCode = countryCode.toString();
            });
          },
          onInit: (CountryCode? countryCode) {
            if (countryCode != null) {
              _selectedCountryCode = countryCode.toString();
            }
          },
        ),
        // COUNTRY CODE PICKER

        SizedBox(height: Dimensions.height20),

        // PHONE NUMBER INPUT
        TextField(
          controller: phoneNumberController,
          keyboardType: TextInputType.phone,
          cursorColor: Theme.of(context).primaryColor,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.font18,
            fontFamily: "Circular",
          ),
          decoration: InputDecoration(
            labelText: 'Phone number',
            labelStyle: TextStyle(
              fontSize: Dimensions.font15,
              color: Theme.of(context).primaryColor,
            ),
            border: inputBorder,
            focusedBorder: inputBorder,
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
        // PHONE NUMBER INPUT

        SizedBox(height: Dimensions.height10),

        SmallText(
          text:
              "We'll text you to confirm your number. Standard message and data rates apply.",
        ),

        SizedBox(height: Dimensions.height20),

        // CONTINUE BUTTON
        _isValidPhoneNumber()
            ? GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return FinishSignUpScreen( phoneNumber: phoneNumberController.text);
                      },
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimensions.radius20 / 2),
                      ),
                    ),
                    color: isDark ? purpleColor1 : whiteColor,
                  ),
                  child: SmallText(
                    text: "Continue",
                    size: Dimensions.font15,
                    color: whiteColor,
                  ),
                ),
              )
            : GestureDetector(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimensions.radius20 / 2),
                      ),
                    ),
                    color: isDark ? darkSearchBarColor : buttonBackgroundColor,
                  ),
                  child: SmallText(
                    text: "Continue",
                    size: Dimensions.font15,
                    color: isDark ? greyColor : whiteColor,
                  ),
                ),
              ),
        // CONTINUE BUTTON
      ],
    );
  }
}
