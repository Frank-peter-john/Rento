// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rento/screens/property/rent_your_property/add_payment/add_payment_method.dart';
import 'package:rento/widgets/navigation.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/small_text.dart';
import '../../../../widgets/buttons/next_button.dart';

class AddFarmImagesScreen extends StatefulWidget {
  final String farmName;
  const AddFarmImagesScreen({super.key, required this.farmName});

  @override
  State<AddFarmImagesScreen> createState() => _AddFarmImagesScreenState();
}

class _AddFarmImagesScreenState extends State<AddFarmImagesScreen> {
  final List<dynamic> _selectedImages = [];
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = false;

// THIS METHOD PICKS AN IMAGE FROM THE DEVICE
  Future<void> _pickImages() async {
    List<XFile>? pickedImages;
    if (kIsWeb) {
      pickedImages = await ImagePicker().pickMultiImage();
    } else {
      pickedImages = await ImagePicker().pickMultiImage();
    }
    List<dynamic> images = [];
    for (var pickedImage in pickedImages) {
      if (kIsWeb) {
        final imageUrl = pickedImage.path;
        images.add(imageUrl);
      } else {
        final imageFile = File(pickedImage.path);
        images.add(imageFile);
      }
    }
    setState(() {
      _selectedImages.addAll(images);
    });
  }

// THIS METHOD REMOVES WRONGLY SELECTED IMAGES.
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

// THIS METHOD SAVES IMAGES TO FIREBASE
  Future<void> _saveImagesToFirebase() async {
    setState(() {
      _isLoading = true;
    });
    // Upload images to Firebase Storage
    final storage = FirebaseStorage.instance;
    final firestore = FirebaseFirestore.instance;
    final farmName = widget.farmName;

    for (var image in _selectedImages) {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final reference =
          storage.ref().child('users/$userId/$farmName/$fileName');

      if (kIsWeb) {
        final imageUrl = image as String;
        final response = await http.get(Uri.parse(imageUrl));
        final imageData = response.bodyBytes;
        await reference.putData(imageData);
      } else {
        final imageFile = image as File;
        await reference.putFile(imageFile);
      }

      // Get the image URL
      final imageUrl = await reference.getDownloadURL();

      // Store the image URL in the users collection
      final userRef = firestore.collection('users').doc(userId);
      final propertiesRef = userRef.collection('properties').doc(farmName);

      // Store the image URL in the images sub-collection
      final imagesRef = propertiesRef.collection('images').doc(fileName);
      await imagesRef.set({'imageURL': imageUrl});
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return const AddPaymentMethod();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopNavigation(
              text: 'Add farm images ',
              icon: Icons.arrow_back_outlined,
            ),

            SizedBox(height: Dimensions.height20),

            SmallText(
              text: "Now, add your farm images. ",
              size: Dimensions.font16,
            ),
            SizedBox(height: Dimensions.height10),

            SmallText(
              text:
                  'Click the plus button to add Images. Add as many images as you like.',
              size: Dimensions.font14,
            ),
            SizedBox(height: Dimensions.height20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _pickImages,
                  color: Theme.of(context).primaryColor,
                  iconSize: Dimensions.iconSize24,
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),
            SizedBox(
              height: Dimensions.height120 * 2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  dynamic image = _selectedImages[index];
                  Widget imageWidget;
                  if (kIsWeb) {
                    imageWidget = Image.network(
                      image,
                      width: Dimensions.width30 * 8,
                      height: Dimensions.height120 * 2,
                      fit: BoxFit.cover,
                    );
                  } else {
                    File imageFile = image as File;
                    imageWidget = Image.file(
                      imageFile,
                      width: Dimensions.width30 * 8,
                      height: Dimensions.height120 * 2,
                      fit: BoxFit.cover,
                    );
                  }
                  return Container(
                    width: Dimensions.width30 * 8,
                    height: Dimensions.height120 * 2,
                    margin: EdgeInsets.all(Dimensions.height10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: imageWidget,
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            color: Colors.white,
                            onPressed: () => _removeImage(index),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // NEXT BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _saveImagesToFirebase,
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
    );
  }
}
