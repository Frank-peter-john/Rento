import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/show_snack_bar.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/multpurpose_button.dart';
import 'package:rento/widgets/navigation.dart';
import '../../../utils/dimensions.dart';

class RentingScreen extends StatefulWidget {
  final String name;
  final String price;
  final DocumentSnapshot propertyDoc;

  const RentingScreen(
      {super.key,
      required this.name,
      required this.price,
      required this.propertyDoc});

  @override
  State<RentingScreen> createState() => _RentingScreenState();
}

class _RentingScreenState extends State<RentingScreen> {
  String propertyStatus = '';

  Future<void> _reserveProperty() async {
    try {
      // Get a reference to the property document
      await widget.propertyDoc.reference.update({'status': 'Reserved'});

      setState(() {
        propertyStatus = 'Reserved';
      });

      // Show the success dialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reservation Successful'),
            content: const Text('You have successfully reserved the property.'),
            actions: <Widget>[
              TextButton(
                child: const MultipurposeButton(
                  text: 'Ok',
                  textColor: whiteColor,
                  backgroundColor: purpleColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      showSnackBar(context, "Oops! sory, something went wrong");
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height30 * 5,
          left: Dimensions.width10,
          right: Dimensions.width10,
          bottom: Dimensions.height10,
        ),
        child: Column(
          children: [
            const TopNavigation(
              text: 'Reserve property',
              icon: Icons.arrow_back_outlined,
            ),
            SizedBox(
              height: Dimensions.font30 * 6,
              width: Dimensions.width350 * 8,
              child: ClipRect(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.height20),
                      child: Column(
                        children: [
                          BigText(
                            text: 'Reserve now and pay later',
                            size: Dimensions.font20,
                          ),
                          SizedBox(height: Dimensions.height10),
                          SmallText(text: widget.name, size: Dimensions.font18),
                          SizedBox(height: Dimensions.height10),
                          SmallText(
                            text: '${widget.price} Tsh',
                            size: Dimensions.font16,
                          ),
                          SizedBox(height: Dimensions.height10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: _reserveProperty,
                                child: const MultipurposeButton(
                                  text: 'Reserve',
                                  textColor: whiteColor,
                                  backgroundColor: purpleColor,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ),
            SizedBox(height: Dimensions.height20),
            SizedBox(height: Dimensions.height20),
            SizedBox(height: Dimensions.height20 * 3),
            GestureDetector(
              onTap: () {
                showSnackBar(context,
                    "This feature is still on development, it willl be available on the next version.");
              },
              child: Container(
                margin: EdgeInsets.only(left: Dimensions.width30),
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
                  color: isDark ? darkGrey : buttonBackgroundColor,
                ),
                child: SmallText(
                  text: 'Pay now',
                  size: Dimensions.font16,
                  color: whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
