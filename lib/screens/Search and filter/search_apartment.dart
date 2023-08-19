import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/widgets/navigation.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/small_text.dart';
import '../main/feed/property_card.dart';

class SearchApatmentScreen extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  const SearchApatmentScreen(
      {super.key, required this.minPrice, required this.maxPrice});

  @override
  State<SearchApatmentScreen> createState() => _SearchApatmentScreenState();
}

class _SearchApatmentScreenState extends State<SearchApatmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPropertyList(context),
    );
  }

  Widget _buildPropertyList(context) {
    // DEFINING THE INPUT BORDER STRUCTURE

    return Container(
      margin: EdgeInsets.only(
          top: Dimensions.height30,
          left: Dimensions.width10,
          right: Dimensions.width10),
      child: Column(children: [
        const TopNavigation(
          text: 'Explore',
          icon: Icons.arrow_back_outlined,
        ),
        SizedBox(height: Dimensions.height10),

        // Text INPApatment
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userDocs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: userDocs.length,
                    itemBuilder: (context, index) {
                      final userDoc = userDocs[index];
                      return FutureBuilder<QuerySnapshot>(
                        future:
                            userDoc.reference.collection('properties').get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox(); // Return an empty container or placeholder widget
                          }

                          // Filter the property documents based on the minPrice and maxPrice
                          // Filter the property documents based on the minPrice and maxPrice

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

                                if (category == 'apartment') {
                                  // Display the property details here
                                  return PropertyCard(
                                    ownerDoc: userDoc,
                                    category: category,
                                    propertyDoc: propertyDoc,
                                  );
                                } else if (category != 'apartment') {
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
              }),
        ),
      ]),
    );
  }
}
