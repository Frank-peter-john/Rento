import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rento/utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/small_text.dart';
import 'property_card.dart';

class OfficesFeed extends StatelessWidget {
  const OfficesFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPropertyList(),
    );
  }

  Widget _buildPropertyList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: userDocs.length,
              itemBuilder: (context, index) {
                final userDoc = userDocs[index];
                return FutureBuilder<QuerySnapshot>(
                  future: userDoc.reference.collection('properties').get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox(); // Return an empty container or placeholder widget
                    }
                    final propertyDocs = snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final category = data['category'];
                      final timestamp = data['timestamp'];
                      return category != null && timestamp != null;
                    }).toList();

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
                          if (category == 'office') {
                            // Display the property details here
                            return PropertyCard(
                              ownerDoc: userDoc,
                              propertyDoc: propertyDoc,
                              category: category,
                            );
                          } else if (category != 'office') {
                            return const SizedBox();
                          } else {
                            return SmallText(
                              text: 'Oops! sory, something went wrong.',
                              size: Dimensions.font18,
                              color: Theme.of(context).primaryColor,
                            );
                          }
                        });
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
                      text: 'Oops! sory we can\'t fetch shops right now.',
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
        });
  }
}
