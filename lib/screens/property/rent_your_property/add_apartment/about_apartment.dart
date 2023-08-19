// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/next_button.dart';
import 'package:rento/widgets/navigation.dart';
import '../../../../widgets/buttons/multpurpose_button.dart';
import 'add_images.dart';

class AboutApartment extends StatefulWidget {
  final String apartmentName;
  const AboutApartment({super.key, required this.apartmentName});

  @override
  State<AboutApartment> createState() => _AboutApartmentState();
}

class _AboutApartmentState extends State<AboutApartment> {
  List<int> numberList = List<int>.generate(11, (index) => index);

  bool _isLoading = false;
  String _selectedType = '';
  bool _hasKitchen = false;
  bool _hasInsideFence = false;
  bool _hasCorridor = false;
  bool _hasDining = false;
  bool _hasPublicToilet = false;
  bool _hasSittingRoom = false;
  bool _hasStore = false;
  bool _hasBasement = false;
  bool _hasGarden = false;
  bool _hasParking = false;
  String _selectedToiletType = 'private';
  String _selectedWindowType = 'glass';
  int _numMasterBedrooms = 0;
  int _numOtherBedrooms = 0;

  @override
  void initState() {
    super.initState();
    _numMasterBedrooms = numberList[0];
    _numOtherBedrooms = numberList[0];
  }

  void _saveDetails() async {
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
      DocumentReference apartmentRef = propertiesRef.doc(widget.apartmentName);

      // Create a document reference for the "apartment type" document using the selected type
      DocumentReference apartmentTypeRef =
          apartmentRef.collection('about').doc(_selectedType);

      // Validate the number of bedrooms
      if (_selectedType != 'Single' &&
          _numMasterBedrooms == 0 &&
          _numOtherBedrooms == 0) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: BigText(
                text: 'Invalid Number of Bedrooms',
                size: Dimensions.font16,
              ),
              content: SmallText(
                text:
                    'The number of master bedrooms and other bedrooms cannot be zero at the same time.',
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
        return; // Stop execution if the validation fails
      }

      // Save the details to Firestore
      await apartmentTypeRef.set({
        'hasKitchen': _hasKitchen,
        'hasInsideFence': _hasInsideFence,
        'hasCorridor': _hasCorridor,
        'hasDining': _hasDining,
        'hasPublicToilet': _hasPublicToilet,
        'hasSittingRoom': _hasSittingRoom,
        'hasStore': _hasStore,
        'hasBasement': _hasBasement,
        'hasGarden': _hasGarden,
        'hasParking': _hasParking,
        'selectedToiletType': _selectedToiletType,
        'selectedWindowType': _selectedWindowType,
        'numMasterBedrooms': _numMasterBedrooms,
        'numOtherBedrooms': _numOtherBedrooms,
        // Add other apartment details you want to save
      });

      setState(() {
        _isLoading = false;
      });

      // Continue to the next screen
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return AddApartmentImagesScreen(apartmentName: widget.apartmentName);
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
              text: "Add your apartment",
              icon: Icons.arrow_back,
            ),
            SizedBox(height: Dimensions.height20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText(
                    text: "Let's add your apartment now.",
                    size: Dimensions.font16,
                  ),
                  SizedBox(height: Dimensions.height20),
                  BigText(
                    text: 'Choose your apartment type',
                    size: Dimensions.font16,
                  ),
                  SizedBox(height: Dimensions.height10),

                  Column(
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Single',
                            groupValue: _selectedType,
                            activeColor: purpleColor,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value!;
                              });
                            },
                          ),
                          SmallText(
                            text: 'Single room apartment',
                            size: Dimensions.font14,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Multiple',
                            groupValue: _selectedType,
                            activeColor: purpleColor,
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value!;
                              });
                            },
                          ),
                          SmallText(
                            text: 'Multiple rooms apartment',
                            size: Dimensions.font14,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height30),

                  // SINGLE ROOM
                  if (_selectedType == 'Single') ...[
                    BigText(
                      text: 'Tell us more about the apartment.',
                      size: Dimensions.font16,
                    ),
                    SizedBox(height: Dimensions.height10),

                    // BORDER
                    Container(
                      margin: EdgeInsets.only(
                        bottom: Dimensions.height10,
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
                    // BORDER

                    Row(
                      children: [
                        Icon(
                          Icons.soup_kitchen_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            value: _hasKitchen,
                            checkColor: isDark ? blackColor : whiteColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _hasKitchen = value!;
                              });
                            },
                            title: SmallText(
                              text: 'Kitchen',
                              size: Dimensions.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.fence_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            value: _hasInsideFence,
                            checkColor: isDark ? blackColor : whiteColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _hasInsideFence = value!;
                              });
                            },
                            title: SmallText(
                              text: 'Fence',
                              size: Dimensions.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.line_axis_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        Expanded(
                          child: CheckboxListTile(
                              value: _hasCorridor,
                              checkColor: isDark ? blackColor : whiteColor,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  _hasCorridor = value!;
                                });
                              },
                              title: SmallText(
                                text: 'Corridor',
                                size: Dimensions.font14,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),

                    // TOILET TYPE
                    Row(
                      children: [
                        Icon(
                          Icons.wash_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        SizedBox(width: Dimensions.width12),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SmallText(
                                  text: 'Toilet',
                                  size: Dimensions.font14,
                                ),
                              ),
                              DropdownButton(
                                value: _selectedToiletType,
                                underline: Container(),
                                iconEnabledColor: greyColor,
                                iconSize: Dimensions.iconSize30,
                                alignment: AlignmentDirectional.bottomStart,
                                focusColor: Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius15),
                                items: [
                                  DropdownMenuItem(
                                    value: 'public',
                                    child: SmallText(
                                      text: 'Public',
                                      size: Dimensions.font14,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'private',
                                    child: SmallText(
                                      text: 'Private',
                                      size: Dimensions.font14,
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedToiletType = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //WINDOW TYPE
                    Row(
                      children: [
                        Icon(
                          Icons.window_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        SizedBox(width: Dimensions.width12),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SmallText(
                                  text: 'Windows',
                                  size: Dimensions.font14,
                                ),
                              ),
                              DropdownButton(
                                value: _selectedWindowType,
                                underline: Container(),
                                iconEnabledColor: greyColor,
                                iconSize: Dimensions.iconSize30,
                                alignment: AlignmentDirectional.bottomStart,
                                focusColor: Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius15),
                                items: [
                                  DropdownMenuItem(
                                    value: 'glass',
                                    child: SmallText(
                                      text: 'Glass',
                                      size: Dimensions.font14,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'wiremesh',
                                    child: SmallText(
                                      text: 'Wiremesh',
                                      size: Dimensions.font14,
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedWindowType = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // WINDOW TYPE

                    SizedBox(height: Dimensions.height20 * 2.5),

                    // NEXT BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return AddApartmentImagesScreen(
                                apartmentName: widget.apartmentName,
                              );
                            }));
                          },
                          child: GestureDetector(
                            onTap: _saveDetails,
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
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height30),
                  ]
                  //  SINGLE ROOM

                  // MULTIPLE ROOMS
                  else if (_selectedType == 'Multiple') ...[
                    //MULTIPLE  ROOMS

                    BigText(
                      text: 'Tell us more about the apartment',
                      size: Dimensions.font16,
                    ),
                    SizedBox(height: Dimensions.height10),

                    //  BORDER
                    Container(
                      margin: EdgeInsets.only(
                        bottom: Dimensions.height10,
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
                    // BORDER

                    SizedBox(height: Dimensions.height10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallText(
                          text: 'Number of master bedrooms',
                          size: Dimensions.font14,
                        ),
                        DropdownButton<int>(
                          value: _numMasterBedrooms,
                          underline: Container(),
                          focusColor: Colors.transparent,
                          menuMaxHeight: 150,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius15),
                          items: numberList.map((int number) {
                            return DropdownMenuItem<int>(
                              value: number,
                              child: Text(number.toString()),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              _numMasterBedrooms = newValue!;
                            });
                          },
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallText(
                          text: 'Number of other bedrooms',
                          size: Dimensions.font14,
                        ),
                        DropdownButton<int>(
                          value: _numOtherBedrooms,
                          underline: Container(),
                          focusColor: Colors.transparent,
                          menuMaxHeight: 150,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius15),
                          items: numberList.map((int number) {
                            return DropdownMenuItem<int>(
                              value: number,
                              child: Text(number.toString()),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              _numOtherBedrooms = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.soup_kitchen_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            value: _hasKitchen,
                            checkColor: isDark ? blackColor : whiteColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _hasKitchen = value!;
                              });
                            },
                            title: SmallText(
                              text: 'Kitchen',
                              size: Dimensions.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.wash_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            value: _hasPublicToilet,
                            checkColor: isDark ? blackColor : whiteColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _hasPublicToilet = value!;
                              });
                            },
                            title: SmallText(
                              text: 'Public toilet',
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
                            value: _hasSittingRoom,
                            checkColor: isDark ? blackColor : whiteColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _hasSittingRoom = value!;
                              });
                            },
                            title: SmallText(
                              text: 'Sitting room',
                              size: Dimensions.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.dining_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            value: _hasDining,
                            checkColor: isDark ? blackColor : whiteColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _hasDining = value!;
                              });
                            },
                            title: SmallText(
                              text: 'Dining',
                              size: Dimensions.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            value: _hasStore,
                            checkColor: isDark ? blackColor : whiteColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _hasStore = value!;
                              });
                            },
                            title: SmallText(
                              text: 'Store',
                              size: Dimensions.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.agriculture_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            value: _hasGarden,
                            checkColor: isDark ? blackColor : whiteColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _hasGarden = value!;
                              });
                            },
                            title: SmallText(
                              text: 'Garden',
                              size: Dimensions.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.local_parking_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            value: _hasParking,
                            checkColor: isDark ? blackColor : whiteColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _hasParking = value!;
                              });
                            },
                            title: SmallText(
                              text: 'Parking',
                              size: Dimensions.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.backpack_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            value: _hasBasement,
                            checkColor: isDark ? blackColor : whiteColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _hasBasement = value!;
                              });
                            },
                            title: SmallText(
                              text: 'Basement',
                              size: Dimensions.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.fence_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            value: _hasInsideFence,
                            checkColor: isDark ? blackColor : whiteColor,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _hasInsideFence = value!;
                              });
                            },
                            title: SmallText(
                              text: 'Fence',
                              size: Dimensions.font14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    //WINDOW TYPE
                    Row(
                      children: [
                        Icon(
                          Icons.window_outlined,
                          size: Dimensions.iconSize16,
                        ),
                        SizedBox(width: Dimensions.width12),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: SmallText(
                                  text: 'Windows',
                                  size: Dimensions.font14,
                                ),
                              ),
                              DropdownButton(
                                value: _selectedWindowType,
                                underline: Container(),
                                iconEnabledColor: greyColor,
                                iconSize: Dimensions.iconSize30,
                                alignment: AlignmentDirectional.bottomStart,
                                focusColor: Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius15),
                                items: [
                                  DropdownMenuItem(
                                    value: 'glass',
                                    child: SmallText(
                                      text: 'Glass',
                                      size: Dimensions.font14,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'wiremesh',
                                    child: SmallText(
                                      text: 'Wiremesh',
                                      size: Dimensions.font14,
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedWindowType = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // WINDOW TYPE

                    SizedBox(height: Dimensions.height20 * 2.5),

                    // NEXT BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _saveDetails,
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
                  //  MULTIPLE ROOMS
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
