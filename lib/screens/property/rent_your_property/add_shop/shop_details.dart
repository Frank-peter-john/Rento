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

import 'shop_images.dart';

class AddShopDetails extends StatefulWidget {
  const AddShopDetails({super.key});

  @override
  State<AddShopDetails> createState() => _AddShopDetailsState();
}

class _AddShopDetailsState extends State<AddShopDetails> {
  PlaceLocation? _pickedLocation;

  final _formKey = GlobalKey<FormState>();
  String _shopName = '';
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
          .doc(_shopName)
          .collection('details')
          .doc('details');

      await apartmentCollection.doc(_shopName).set({
        'timestamp': FieldValue.serverTimestamp(),
        'category': 'shop',
      });

      await detailsRef.set({
        'name': _shopName,
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
        return AddShopImagesScreen(shopName: _shopName);
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
                text: "Add your shop details",
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
                        text: "Now, add details of your shop.",
                        size: Dimensions.font16,
                      ),

                      SizedBox(height: Dimensions.height20),

                      //SHOP NAME
                      SmallText(
                        text: "Enter your shop name.",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),

                      TextFormField(
                        key: const ValueKey('shopName'),
                        onSaved: (value) {
                          _shopName = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your shop name';
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

                      // SHOP PRICE
                      SmallText(
                        text: "Enter your shop price per month. ",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),
                      TextFormField(
                        key: const ValueKey('shopPrice'),
                        onSaved: (value) {
                          _price = double.parse(value!);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your shop price.';
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

                      // SHOP LOCATION
                      SmallText(
                        text: "Enter your shop location.",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),

                      LocationInput(onSelectPlace: _selectPlace),

                      SizedBox(height: Dimensions.height20),

                      // SHOP DESCRIPTION
                      SmallText(
                        text: "Describe your shop in a few words.",
                        size: Dimensions.font14,
                      ),
                      SizedBox(height: Dimensions.height10),

                      TextFormField(
                        onSaved: (value) {
                          _description = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please describe your shop.';
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
