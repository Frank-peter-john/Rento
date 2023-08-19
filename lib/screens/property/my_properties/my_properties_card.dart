import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';
import '../../main/feed/property_details.dart/property_details.dart';

class MyPropertyCard extends StatefulWidget {
  final DocumentSnapshot ownerDoc;
  final DocumentSnapshot propertyDoc;
  final String category;

  const MyPropertyCard({
    Key? key,
    required this.propertyDoc,
    required this.ownerDoc,
    required this.category,
  }) : super(key: key);

  @override
  State<MyPropertyCard> createState() => _MyPropertyCardState();
}

class _MyPropertyCardState extends State<MyPropertyCard> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final imagesRef = widget.propertyDoc.reference.collection('images');
    final data = widget.propertyDoc.data() as Map<String, dynamic>;
    final status = data['status'];
    final detailsRef =
        widget.propertyDoc.reference.collection('details').doc('details');

    return Container(
      margin: EdgeInsets.only(
        bottom: Dimensions.height20 * 2,
        left: Dimensions.width20,
        right: Dimensions.width20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<QuerySnapshot>(
            future: imagesRef.get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildImageSkeleton();
              }

              final images = snapshot.data!.docs;
              final imagedata = images[0].data() as Map<String, dynamic>;
              final imageURL = images.isNotEmpty ? imagedata['imageURL'] : '';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => PropertyDetails(
                        ownerDoc: widget.ownerDoc,
                        propertyDoc: widget.propertyDoc,
                        category: widget.category,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.3,
                  width: Dimensions.width30 * 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius20,
                    ),
                    color: isDark ? darkSearchBarColor : buttonBackgroundColor,
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        imageURL,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: Dimensions.height10),
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: detailsRef.get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.data() == null) {
                return _buildDetailsSkeleton();
              }

              final detailsData = snapshot.data!.data()!;
              final name = detailsData['name'];
              final price = detailsData['price'];

              final formattedPrice =
                  NumberFormat.decimalPattern().format(price);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.category),
                      SizedBox(width: Dimensions.width10),
                      Container(
                        width: Dimensions.width30 * 2,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: const Color.fromARGB(255, 52, 172, 56),
                        ),
                        child: Center(
                          child: SmallText(
                            text: '$status',
                            color: whiteColor,
                            size: Dimensions.font12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(name),
                      Row(
                        children: [
                          Icon(
                            Icons.star_outline,
                            size: Dimensions.iconSize15,
                          ),
                          const Text('4.9'),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: Dimensions.height10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 0.4,
                            ),
                          ),
                        ),
                        child: widget.category == 'shop' ||
                                widget.category == 'apartment'
                            ? SmallText(
                                text: '$formattedPrice Tsh/Month',
                                size: Dimensions.font15,
                              )
                            : SmallText(
                                text: '$formattedPrice Tsh/Square meter',
                                size: Dimensions.font15,
                              ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          SizedBox(height: Dimensions.height20),
        ],
      ),
    );
  }

  Widget _buildImageSkeleton() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.width * 0.3,
      width: Dimensions.width30 * 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Dimensions.radius20,
        ),
        color: isDark ? darkSearchBarColor : buttonBackgroundColor,
      ),
    );
  }

  Widget _buildDetailsSkeleton() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: Dimensions.width30 * 5,
              height: Dimensions.height20,
              color: isDark ? darkGrey : buttonBackgroundColor,
            ),
          ],
        ),
        SizedBox(height: Dimensions.height7),
        Container(
          width: Dimensions.width30 * 5,
          height: Dimensions.height20,
          color: isDark ? darkGrey : buttonBackgroundColor,
        ),
        SizedBox(height: Dimensions.height7),
        Container(
          width: Dimensions.width30 * 5,
          height: Dimensions.height20,
          color: isDark ? darkGrey : buttonBackgroundColor,
        ),
        SizedBox(height: Dimensions.height7),
      ],
    );
  }
}
