import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rento/screens/account/account_items/profile/edit_profile.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/widgets/buttons/multpurpose_button.dart';
import 'package:rento/widgets/navigation.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimensions.dart';

class ProfileScreen extends StatelessWidget {
  final User currentUser = FirebaseAuth.instance.currentUser!;

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(color: purpleColor));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final email = data['email'] ?? '';
          final firstName = data['firstname'] ?? '';
          final lastName = data['lastname'] ?? '';
          final phoneNumber = data['phoneNumber'] ?? '';
          final imageUrl = data['imageUrl'] ?? '';

          return Center(
            child: Container(
              margin: EdgeInsets.only(
                top: Dimensions.height30,
                left: Dimensions.width20,
                right: Dimensions.width20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const TopNavigation(
                    text: 'My profile',
                    icon: Icons.arrow_back_outlined,
                  ),
                  SizedBox(height: Dimensions.height20),
                  imageUrl.isNotEmpty
                      ? CircleAvatar(
                          radius: Dimensions.radius30 * 3,
                          backgroundImage: NetworkImage(imageUrl),
                          backgroundColor:
                              isDark ? darkSearchBarColor : whiteColor,
                        )
                      : CircleAvatar(
                          radius: Dimensions.radius30 * 3,
                          backgroundColor: purpleColor,
                          child: BigText(
                            text: firstName[0].toUpperCase(),
                            color: whiteColor,
                            size: Dimensions.font30 * 3,
                          ),
                        ),
                  SizedBox(height: Dimensions.height20),
                  Text('Email: $email'),
                  SizedBox(height: Dimensions.height10),
                  Text('First Name: $firstName'),
                  SizedBox(height: Dimensions.height10),
                  Text('Last Name: $lastName'),
                  SizedBox(height: Dimensions.height10),
                  Text('Phone Number: $phoneNumber'),
                  SizedBox(height: Dimensions.height30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return const ProfileEditScreen();
                          }));
                        },
                        child: MultipurposeButton(
                          text: "Edit",
                          textColor: whiteColor,
                          backgroundColor:
                              isDark ? darkSearchBarColor : blackColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
