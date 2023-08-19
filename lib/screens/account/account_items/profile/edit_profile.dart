// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rento/screens/account/account_items/profile/storage_methods.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/pick_image.dart';
import 'package:rento/utils/show_snack_bar.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/navigation.dart';
import '../../../../utils/dimensions.dart';
import '../../../../widgets/buttons/multpurpose_button.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  final _formKey = GlobalKey<FormState>();
  Uint8List? _selectedImage;
  bool _isLoading = false;
  String _firstName = '';
  String _lastName = '';
  String _phoneNumber = '';
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _firstName = userData['firstname'] ?? '';
        _lastName = userData['lastname'] ?? '';
        _phoneNumber = userData['phoneNumber'] ?? '';
        _imageUrl = userData['imageUrl'];

        _firstNameController.text = _firstName;
        _lastNameController.text = _lastName;
        _phoneNumberController.text = _phoneNumber;
      });
    } catch (error) {
      // Handle error
    }
  }

  Future<void> _selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    /* Remove the cursor on submiting the form  */
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      String imageUrl = await StorageMethods()
          .uploadImage('users/profilePics/$uid', _selectedImage!);
      try {
        FirebaseFirestore.instance.collection('users').doc(uid).update({
          'firstname': _firstName,
          'lastname': _lastName,
          'phoneNumber': _phoneNumber,
          'imageUrl': imageUrl,
        });
        setState(() {
          _isLoading = false;
        });

        Navigator.pop(context);
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        return showSnackBar(context, 'Oops! something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // DEFINING THE INPUT BORDER STRUCTURE
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context,
          color: Theme.of(context).primaryColor, width: 0.5),
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dimensions.radius20 / 2,
        ),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height30,
          left: Dimensions.width20,
          right: Dimensions.width20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopNavigation(
                text: 'Edit your profile',
                icon: Icons.arrow_back_outlined,
              ),
              SizedBox(height: Dimensions.height20),
              Center(
                child: Stack(
                  children: [
                    _imageUrl.isNotEmpty
                        ? _selectedImage != null
                            ? CircleAvatar(
                                radius: Dimensions.radius30 * 3,
                                backgroundImage: MemoryImage(_selectedImage!),
                                backgroundColor:
                                    isDark ? darkSearchBarColor : whiteColor,
                              )
                            : CircleAvatar(
                                radius: Dimensions.radius30 * 3,
                                backgroundImage: NetworkImage(_imageUrl),
                                backgroundColor:
                                    isDark ? darkSearchBarColor : whiteColor,
                              )
                        : CircleAvatar(
                            radius: Dimensions.radius30 * 3,
                            backgroundColor: purpleColor,
                            child: Text(
                              _firstName.isNotEmpty ? _firstName[0] : '',
                              style: TextStyle(
                                fontSize: Dimensions.font20 * 2.5,
                                color: whiteColor,
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: -2,
                      left: 120,
                      child: IconButton(
                        onPressed: _selectImage,
                        icon: Icon(
                          Icons.add_a_photo_outlined,
                          color: _imageUrl.isEmpty
                              ? Theme.of(context).primaryColor
                              : purpleColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              SmallText(text: 'First name'),
              SizedBox(height: Dimensions.height10),
              TextFormField(
                controller: _firstNameController,
                onChanged: (value) {
                  _firstName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              SmallText(text: 'Last name'),
              SizedBox(height: Dimensions.height10),
              TextFormField(
                controller: _lastNameController,
                onChanged: (value) {
                  _lastName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              SmallText(text: 'Phone number'),
              SizedBox(height: Dimensions.height10),
              TextFormField(
                controller: _phoneNumberController,
                onChanged: (value) {
                  _phoneNumber = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 10) {
                    return 'Your phone number must have 10 digits.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
              ),
              SizedBox(height: Dimensions.height30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _submitForm,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: purpleColor,
                            ),
                          )
                        : MultipurposeButton(
                            text: "Save",
                            textColor: whiteColor,
                            backgroundColor:
                                isDark ? darkSearchBarColor : blackColor,
                          ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height30),
            ],
          ),
        ),
      ),
    ));
  }
}
