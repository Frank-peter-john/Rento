import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rento/utils/colors.dart';
import '../../../utils/big_text.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/small_text.dart';
import 'my_properties_card.dart';

class MyPropertiesFeed extends StatelessWidget {
  const MyPropertiesFeed({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPropertyList(context),
    );
  }

  Widget _buildPropertyList(context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    // Replace with the current user's UID

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: Dimensions.height30,
                bottom: Dimensions.height10,
              ),
              child: BigText(
                text: 'My properties',
                size: Dimensions.font24,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: Dimensions.height20,
              ),
              decoration: BoxDecoration(
                border: isDark
                    ? const Border(
                        bottom: BorderSide(
                          color: greyColor,
                          // style: BorderStyle.solid,
                          width: 0.5,
                        ),
                      )
                    : const Border(
                        bottom: BorderSide(
                          color: greyColor,
                          // style: BorderStyle.solid,
                          width: 0.2,
                        ),
                      ),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userDoc = snapshot.data!;
                  final propertyCollection =
                      userDoc.reference.collection('properties');

                  return FutureBuilder<QuerySnapshot>(
                    future: propertyCollection.get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Center(
                            child:
                                CircularProgressIndicator(color: purpleColor),
                          ),
                        );
                      }

                      final propertyDocs = snapshot.data!.docs;

                      if (propertyDocs.isEmpty) {
                        return Center(
                          child: SmallText(
                            text:
                                'You have no properties in the system. Consider adding new properties.',
                            size: Dimensions.font18,
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      }

                      propertyDocs.sort((a, b) {
                        final dataA = a.data() as Map<String, dynamic>;
                        final dataB = b.data() as Map<String, dynamic>;
                        final timestampA = dataA['timestamp'] as Timestamp?;
                        final timestampB = dataB['timestamp'] as Timestamp?;
                        if (timestampA != null && timestampB != null) {
                          return timestampB.compareTo(timestampA);
                        }
                        return 0;
                      });

                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: propertyDocs.length,
                        itemBuilder: (context, index) {
                          final propertyDoc = propertyDocs[index];
                          final data =
                              propertyDoc.data() as Map<String, dynamic>?;
                          String category = data!['category'];

                          // Display the property details here
                          return MyPropertyCard(
                            ownerDoc: userDoc,
                            propertyDoc: propertyDoc,
                            category: category,
                          );
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SmallText(
                            text:
                                'Oops! Sorry, we can\'t fetch properties right now.',
                            size: Dimensions.font18,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: purpleColor,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
