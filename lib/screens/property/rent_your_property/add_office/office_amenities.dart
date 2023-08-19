import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/next_button.dart';
import 'package:rento/widgets/navigation.dart';
import '../../../../widgets/buttons/multpurpose_button.dart';
import '../add_payment/add_payment_method.dart';

class OfficeAmenities extends StatefulWidget {
  final String officeName;
  const OfficeAmenities({super.key, required this.officeName});

  @override
  State<OfficeAmenities> createState() => _OfficeAmenitiesState();
}

class _OfficeAmenitiesState extends State<OfficeAmenities> {
  List<int> numberList = List<int>.generate(11, (index) => index);

  bool _hasWifi = false;
  bool _hasFan = false;
  bool _hasChairs = false;
  bool _hasBed = false;
  bool _hasAirCoindition = false;
  bool _hasLights = false;
  bool _hasTv = false;
  bool _hasCameras = false;
  bool _hasAlarm = false;
  bool _isLoading = false;

  void _saveAmenities() async {
    setState(() {
      _isLoading = true;
    });
    // Get the current user's ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Create a reference to the "properties" collection
    CollectionReference propertiesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('properties');

    try {
      // Create a document reference for the "apartment" document using the user's ID
      DocumentReference apartmentRef = propertiesRef.doc(widget.officeName);

      // Create a document reference for the "apartment type" document using the selected type
      DocumentReference amenitiesRef =
          apartmentRef.collection('amenities').doc('amenities');

      // Save the details to Firestore
      await amenitiesRef.set({
        'hasWifi': _hasWifi,
        'hasFan': _hasFan,
        'hasChairs': _hasChairs,
        'hasBed': _hasBed,
        'hasAirCondition': _hasAirCoindition,
        'hasLights': _hasLights,
        'hasTv': _hasTv,
        'hasCameras': _hasCameras,
        'hasAlarm': _hasAlarm,
      });

      setState(() {
        _isLoading = false;
      });

      // Continue to the next screen
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return const AddPaymentMethod();
      }));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: SmallText(
              text: 'Error',
              size: Dimensions.font16,
            ),
            content: SmallText(
              text: 'An error occurred while saving the details.',
              size: Dimensions.font14,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const MultipurposeButton(
                  text: 'Ok',
                  backgroundColor: purpleColor,
                  textColor: whiteColor,
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopNavigation(
              text: "Add your office amenities",
              icon: Icons.arrow_back,
            ),
            SizedBox(height: Dimensions.height20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText(
                    text: "What amenities does your office have?",
                    size: Dimensions.font16,
                  ),
                  SizedBox(height: Dimensions.height20),

                  // LIST OF AMENITIES

                  Row(
                    children: [
                      Icon(
                        Icons.tv_outlined,
                        size: Dimensions.iconSize16,
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value: _hasTv,
                          checkColor: isDark ? blackColor : whiteColor,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _hasTv = value!;
                            });
                          },
                          title: SmallText(
                            text: 'TV',
                            size: Dimensions.font14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.wind_power_outlined,
                        size: Dimensions.iconSize16,
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value: _hasFan,
                          checkColor: isDark ? blackColor : whiteColor,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _hasFan = value!;
                            });
                          },
                          title: SmallText(
                            text: 'Fan',
                            size: Dimensions.font14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.wifi_outlined,
                        size: Dimensions.iconSize16,
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value: _hasWifi,
                          checkColor: isDark ? blackColor : whiteColor,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _hasWifi = value!;
                            });
                          },
                          title: SmallText(
                            text: 'Wi-fi',
                            size: Dimensions.font14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.chair_outlined,
                        size: Dimensions.iconSize16,
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value: _hasChairs,
                          checkColor: isDark ? blackColor : whiteColor,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _hasChairs = value!;
                            });
                          },
                          title: SmallText(
                            text: 'Chairs',
                            size: Dimensions.font14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.bed_outlined,
                        size: Dimensions.iconSize16,
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value: _hasBed,
                          checkColor: isDark ? blackColor : whiteColor,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _hasBed = value!;
                            });
                          },
                          title: SmallText(
                            text: 'Beds',
                            size: Dimensions.font14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outlined,
                        size: Dimensions.iconSize16,
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value: _hasLights,
                          checkColor: isDark ? blackColor : whiteColor,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _hasLights = value!;
                            });
                          },
                          title: SmallText(
                            text: 'Lights',
                            size: Dimensions.font14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.alarm_outlined,
                        size: Dimensions.iconSize16,
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value: _hasAlarm,
                          checkColor: isDark ? blackColor : whiteColor,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _hasAlarm = value!;
                            });
                          },
                          title: SmallText(
                            text: 'Alarm',
                            size: Dimensions.font14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: Dimensions.iconSize16,
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value: _hasCameras,
                          checkColor: isDark ? blackColor : whiteColor,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _hasCameras = value!;
                            });
                          },
                          title: SmallText(
                            text: 'Cameras',
                            size: Dimensions.font14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.ac_unit_outlined,
                        size: Dimensions.iconSize16,
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          value: _hasAirCoindition,
                          checkColor: isDark ? blackColor : whiteColor,
                          activeColor: Theme.of(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _hasAirCoindition = value!;
                            });
                          },
                          title: SmallText(
                            text: 'Air condition',
                            size: Dimensions.font14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.height20 * 2.5),

                  // NEXT BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: _saveAmenities,
                        child: _isLoading
                            ? SizedBox(
                                width: Dimensions.width30,
                                height: Dimensions.height30,
                                child: const CircularProgressIndicator(
                                  color: purpleColor,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const NextButton(
                                text: 'Save and Continue',
                              ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.height30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
