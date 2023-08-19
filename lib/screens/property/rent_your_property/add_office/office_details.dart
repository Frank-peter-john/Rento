import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rento/models/place.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/screens/location/location_input.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/next_button.dart';
import 'package:rento/widgets/navigation.dart';

import 'office_images.dart';

class AddOfficeDetails extends StatefulWidget {
  const AddOfficeDetails({super.key});

  @override
  State<AddOfficeDetails> createState() => _AddOfficeDetailsState();
}

class _AddOfficeDetailsState extends State<AddOfficeDetails> {
  PlaceLocation? _pickedLocation;

  final _formKey = GlobalKey<FormState>();
  String _officeName = '';
  double _price = 0.0;
  String _description = '';
  bool _isLoading = false;

  // Get the selected place
  void _selectPlace(double lat, double lng) {
    setState(() {
      _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    });
  }

  void _saveDetails() async {
    final isValid = _formKey.currentState!.validate();
    /* Remove the cursor on submiting the form  */
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      // this triggers all the save functions in the form
      _formKey.currentState!.save();

      String userId = FirebaseAuth.instance.currentUser!.uid;
      final apartmentCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('properties');

      final detailsRef = apartmentCollection
          .doc(_officeName)
          .collection('details')
          .doc('details');

      await apartmentCollection.doc(_officeName).set({
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'office',
      });

      await detailsRef.set({
        'name': _officeName,
        'price': _price,
        'latitude': _pickedLocation!.latitude,
        'longitude': _pickedLocation!.longitude,
        'description': _description,
      });

      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return AddOfficeImagesScreen(officeName: _officeName);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    // DEFINIMG THE INPUT BORDER STRUCTURE
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(
        context,
        color: darkSearchBarColor,
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
        margin: EdgeInsets.only(top: Dimensions.height30),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopNavigation(
                text: "Add your office details",
                icon: Icons.arrow_back,
              ),
              SizedBox(height: Dimensions.height20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: Dimensions.width30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(
                        text: "Now, add details of your office.",
                        size: Dimensions.font16,
                      ),

                      SizedBox(height: Dimensions.height20),

                      //OFFICE NAME
                      SmallText(
                        text: "Enter your office name.",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),

                      TextFormField(
                        key: const ValueKey('officeName'),
                        onSaved: (value) {
                          _officeName = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your office name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.font16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            fontSize: Dimensions.font15,
                            color: Theme.of(context).primaryColor,
                          ),
                          border: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                      ),

                      SizedBox(height: Dimensions.height20),

                      // OFFICE PRICE
                      SmallText(
                        text: "Enter your offices\'s  price month. ",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),
                      TextFormField(
                        key: const ValueKey('officePrice'),
                        onSaved: (value) {
                          _price = double.parse(value!);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your office\'s price per month.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.font16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Price',
                          labelStyle: TextStyle(
                            fontSize: Dimensions.font15,
                            color: Theme.of(context).primaryColor,
                          ),
                          border: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                      ),

                      SizedBox(height: Dimensions.height20),

                      // OFFICE LOCATION
                      SmallText(
                        text: "Enter your office's  location.",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),

                      LocationInput(onSelectPlace: _selectPlace),

                      SizedBox(height: Dimensions.height20),

                      // OFFICE DESCRIPTION
                      SmallText(
                        text: "Describe your office space in a few words.",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),

                      TextFormField(
                        onSaved: (value) {
                          _description = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please descibe your office space.';
                          }
                          return null;
                        },
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.font14,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: Dimensions.font15,
                          ),
                          labelText: 'Description...',
                          border: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                        minLines: 4,
                        maxLines: 20,
                      ),
                      // TEXT INPUT

                      SizedBox(height: Dimensions.height30),

                      // SAVE AND CONTINUE BUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: _saveDetails,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: purpleColor,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
