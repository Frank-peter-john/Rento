import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rento/models/place.dart';
import 'package:rento/screens/property/rent_your_property/add_farm.dart/farm_images.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/screens/location/location_input.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/next_button.dart';
import 'package:rento/widgets/navigation.dart';

class AddFarmDetails extends StatefulWidget {
  const AddFarmDetails({super.key});

  @override
  State<AddFarmDetails> createState() => _AddFarmDetailsState();
}

class _AddFarmDetailsState extends State<AddFarmDetails> {
  PlaceLocation? _pickedLocation;

  final _formKey = GlobalKey<FormState>();
  String _farmName = '';
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
          .doc(_farmName)
          .collection('details')
          .doc('details');

      await apartmentCollection.doc(_farmName).set({
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'farm',
      });

      await detailsRef.set({
        'name': _farmName,
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
        return AddFarmImagesScreen(farmName: _farmName);
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
                text: "Add your farm details",
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
                        text: "Now, add details of your farm.",
                        size: Dimensions.font16,
                      ),

                      SizedBox(height: Dimensions.height20),

                      //FARM NAME
                      SmallText(
                        text: "Enter your farm name.",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),

                      TextFormField(
                        key: const ValueKey('farmName'),
                        onSaved: (value) {
                          _farmName = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your farm name';
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

                      // FARM PRICE
                      SmallText(
                        text: "Enter your farm\'s  price per  square meters. ",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),
                      TextFormField(
                        key: const ValueKey('farmPrice'),
                        onSaved: (value) {
                          _price = double.parse(value!);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your farm\'s price per square meters.';
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

                      // FARM LOCATION
                      SmallText(
                        text: "Enter your farm's location.",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),

                      LocationInput(onSelectPlace: _selectPlace),

                      SizedBox(height: Dimensions.height20),

                      // FARM DESCRIPTION
                      SmallText(
                        text: "Describe your farm in a few words.",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),

                      TextFormField(
                        onSaved: (value) {
                          _description = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please descibe your farm.';
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
