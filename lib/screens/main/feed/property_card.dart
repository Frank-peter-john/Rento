import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rento/screens/main/feed/property_details.dart/property_details.dart';
import 'package:rento/utils/small_text.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../location/map_screen.dart';

class PropertyCard extends StatefulWidget {
  final DocumentSnapshot ownerDoc;
  final DocumentSnapshot propertyDoc;
  final String category;

  const PropertyCard({
    Key? key,
    required this.propertyDoc,
    required this.ownerDoc,
    required this.category,
  }) : super(key: key);

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  PageController pageController = PageController(viewportFraction: 1);
  var _currPageValue = 0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!.toInt();
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

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
        children: [
          FutureBuilder<QuerySnapshot>(
            future: imagesRef.get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildImageSkeleton();
              }

              final images = snapshot.data!.docs;
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return PropertyDetails(
                          ownerDoc: widget.ownerDoc,
                          propertyDoc: widget.propertyDoc,
                          category: widget.category,
                        );
                      }));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.45,
                      color:
                          isDark ? darkSearchBarColor : buttonBackgroundColor,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: images.length,
                        itemBuilder: (context, position) {
                          return _buildPageItem(position, context);
                        },
                      ),
                    ),
                  ),

                  // DOTS INDICATOR
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: DotsIndicator(
                      dotsCount: images.length,
                      position: _currPageValue,
                      decorator: DotsDecorator(
                        size: Size.square(
                          Dimensions.font10 / 3,
                        ),
                        spacing: const EdgeInsets.all(2.5),
                        activeColor: whiteColor,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
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
              final longitude = detailsData['longitude'];
              final latitude = detailsData['latitude'];

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      if (latitude != null && longitude != null)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        MapScreen(
                                  latitude: latitude,
                                  longitude: longitude,
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: MapScreen(
                                      latitude: latitude,
                                      longitude: longitude,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const Text('Click to see location'),
                              SizedBox(
                                width: Dimensions.width10 / 2,
                              ),
                              Icon(
                                Icons.location_on_outlined,
                                color: blueColor,
                                size: Dimensions.iconSize16,
                              ),
                              SizedBox(
                                width: Dimensions.width30,
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildPageItem(int index, BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final imagesRef = widget.propertyDoc.reference.collection('images');
    List<String> images = [];

    return FutureBuilder<List<String>>(
      future: _fetchImages(imagesRef),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildImageBoxSkeleton();
        }

        images = snapshot.data!;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? darkSearchBarColor : buttonBackgroundColor,
            image: DecorationImage(
              image: NetworkImage(
                images[index],
              ),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Future<List<String>> _fetchImages(CollectionReference imagesRef) async {
    final snapshot = await imagesRef.get();
    final imageURLs =
        snapshot.docs.map((doc) => doc['imageURL'] as String).toList();
    return imageURLs;
  }

  Widget _buildImageSkeleton() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.width * 0.45,
      color: isDark ? darkGrey : buttonBackgroundColor,
    );
  }

  Widget _buildImageBoxSkeleton() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.width * 0.45,
      color: isDark ? darkGrey : buttonBackgroundColor,
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
            Container(
              width: Dimensions.width30 * 4,
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
