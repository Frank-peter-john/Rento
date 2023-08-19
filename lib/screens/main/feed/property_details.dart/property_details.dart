import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rento/screens/property/rent_property/rent_property.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/utils/expandable_text.dart';
import '../../../../widgets/buttons/multpurpose_button.dart';
import '../../../inbox/chat_screen.dart';
import '../../../location/map_screen.dart';

class PropertyDetails extends StatefulWidget {
  final DocumentSnapshot ownerDoc;
  final DocumentSnapshot propertyDoc;
  final String category;
  const PropertyDetails({
    super.key,
    required this.propertyDoc,
    required this.category,
    required this.ownerDoc,
  });

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  PageController pageController = PageController(viewportFraction: 1);
  var _currPageValue = 0;

  // Create values for the page value.
  @override
  void initState() {
    super.initState();
    pageController.addListener(
      () {
        setState(() {
          _currPageValue = pageController.page!.toInt();
        });
      },
    );
  }

  // Dispose the page value after use(remove it from the memory).
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

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height30,
          left: Dimensions.width10,
          right: Dimensions.width10,
          bottom: Dimensions.height10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NAVIGATION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: Dimensions.iconSize20,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    CupertinoIcons.heart,
                    size: Dimensions.iconSize20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            // NAVIGATION
            SizedBox(
              height: Dimensions.height20,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                            Container(
                              height: MediaQuery.of(context).size.width * 0.45,
                              color: isDark
                                  ? darkSearchBarColor
                                  : buttonBackgroundColor,
                              child: PageView.builder(
                                controller: pageController,
                                itemCount: images.length,
                                itemBuilder: (context, position) {
                                  return _buildPageItem(position, context);
                                },
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

                    // DETAILS SECTION

                    SizedBox(height: Dimensions.height10),
                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: detailsRef.get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data!.data() == null) {
                          return _buildDetailsSkeleton();
                        }

                        final detailsData = snapshot.data!.data()!;
                        final name = detailsData['name'];
                        final price = detailsData['price'];
                        final description = detailsData['description'];
                        final longitude = detailsData['longitude'];
                        final latitude = detailsData['latitude'];

                        final ownerData =
                            widget.ownerDoc.data() as Map<String, dynamic>;

                        final ownerId = widget.ownerDoc.id;
                        final firstname = ownerData['firstname'];
                        final lastname = ownerData['lastname'] ?? '';
                        final phoneNumber = ownerData['phoneNumber'] ?? '';
                        final String imageUrl =
                            ownerData['imageUrl'] ?? 'unknown';
                        final ownerName = '$firstname $lastname';

                        final formattedPrice =
                            NumberFormat.decimalPattern().format(price);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SmallText(
                                  text: name,
                                  size: Dimensions.font22,
                                ),
                                SizedBox(width: Dimensions.width10),
                                Container(
                                  width: Dimensions.width30 * 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius20),
                                    color:
                                        const Color.fromARGB(255, 52, 172, 56),
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
                            SizedBox(height: Dimensions.height10),

                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isDark
                                        ? greyColor
                                        : buttonBackgroundColor,
                                    width: 0.1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.height10),
                            // DESCRIPTION
                            ExpandableText(
                              text: description,
                            ),
                            SizedBox(height: Dimensions.height10),

                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isDark
                                        ? greyColor
                                        : buttonBackgroundColor,
                                    width: 0.1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.height10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SmallText(
                                  text: 'category:',
                                  size: Dimensions.font12,
                                ),
                                SizedBox(width: Dimensions.width20),
                                BigText(
                                  text: widget.category,
                                  size: Dimensions.font12,
                                ),
                                SizedBox(width: Dimensions.width30),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star_outline,
                                        size: Dimensions.iconSize15,
                                      ),
                                      const Text('4.9'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.height10),

                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isDark
                                        ? greyColor
                                        : buttonBackgroundColor,
                                    width: 0.1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.height10),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (latitude != null && longitude != null) 
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              MapScreen(
                                            latitude: latitude,
                                            longitude: longitude,
                                          ),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
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

                                        // Send message to owner
                                      ],
                                    ),
                                  ),
                                SizedBox(height: Dimensions.height10),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isDark
                                            ? greyColor
                                            : buttonBackgroundColor,
                                        width: 0.1,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Dimensions.height10),
                                Container(
                                  child: widget.category == 'shop' ||
                                          widget.category == 'apartment'
                                      ? SmallText(
                                          text: '$formattedPrice Tsh/Month',
                                          size: Dimensions.font15,
                                        )
                                      : SmallText(
                                          text:
                                              '$formattedPrice Tsh/Square meter',
                                          size: Dimensions.font15,
                                        ),
                                ),
                                SizedBox(height: Dimensions.height10),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isDark
                                            ? greyColor
                                            : buttonBackgroundColor,
                                        width: 0.1,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Dimensions.height20),
                                //  USER'S PROFILE IMAGE
                                Row(
                                  children: [
                                    imageUrl.isNotEmpty
                                        ? CircleAvatar(
                                            radius: Dimensions.radius20 * 2,
                                            backgroundImage:
                                                NetworkImage(imageUrl),
                                            backgroundColor: isDark
                                                ? darkGrey
                                                : buttonBackgroundColor,
                                          )
                                        : CircleAvatar(
                                            radius: Dimensions.radius20 * 2,
                                            backgroundColor: purpleColor1,
                                            child: SmallText(
                                              text: ownerName[0].toUpperCase(),
                                              color: whiteColor,
                                              size: Dimensions.font26,
                                            ),
                                          ),
                                    SizedBox(width: Dimensions.height15),

                                    // USER'S FIRSTNAME
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SmallText(
                                            text: ownerName,
                                            size: Dimensions.font18,
                                          ),
                                          SizedBox(height: Dimensions.height10),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (ctx) {
                                                return ChatScreen(
                                                  receiverId: ownerId,
                                                  receiverName: ownerName,
                                                );
                                              }));
                                            },
                                            child: MultipurposeButton(
                                              text: 'Message',
                                              textColor: whiteColor,
                                              backgroundColor: isDark
                                                  ? darkGrey
                                                  : blackColor,
                                            ),
                                          ),
                                          SizedBox(height: Dimensions.height10),
                                          SmallText(text: phoneNumber),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: Dimensions.height20 * 3),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (ctx) {
                                      return RentingScreen(
                                          name: name,
                                          price: formattedPrice,
                                          propertyDoc: widget.propertyDoc);
                                    }));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: Dimensions.width30),
                                    width: Dimensions.width350,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height15,
                                      horizontal: Dimensions.width20,
                                    ),
                                    decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                Dimensions.radius20 / 2),
                                          ),
                                        ),
                                        color: purpleColor),
                                    child: SmallText(
                                      text: 'Rent this ${widget.category}',
                                      size: Dimensions.font16,
                                      color: whiteColor,
                                    ),
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
              ),
            ),
          ],
        ),
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
