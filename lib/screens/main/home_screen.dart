import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rento/screens/Search%20and%20filter/property_search.dart';
import 'package:rento/screens/main/feed/apartments.dart';
import 'package:rento/screens/main/feed/farms.dart';
import 'package:rento/screens/main/feed/offices.dart';
import 'package:rento/screens/main/feed/shops.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';
import 'feed/all_properties.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Column(
        children: [
          // SEARCH BAR
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const PropertySearch(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: const PropertySearch(),
                    );
                  },
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(
                top: Dimensions.height10,
                left: Dimensions.width20,
                right: Dimensions.width10,
                bottom: Dimensions.height10 / 3,
              ),
              margin: EdgeInsets.only(
                top: Dimensions.height30,
                left: Dimensions.width20,
                right: Dimensions.width20,
                bottom: Dimensions.height20,
              ),
              width: Dimensions.width350 * 2.5,
              height: Dimensions.height20 * 4,
              decoration: isDark
                  ? BoxDecoration(
                      color: darkSearchBarColor, // Dark background color
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimensions.radius30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(1.0), // Dark shadow color
                          blurRadius: 10,
                        ),
                      ],
                    )
                  : BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimensions.radius30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: greyColor.withOpacity(0.5),
                          blurRadius: 5,
                        )
                      ],
                    ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.search,
                    color: Theme.of(context).primaryColor,
                    size: Dimensions.iconSize30,
                  ),
                  SizedBox(width: Dimensions.width20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SmallText(
                            text: "Search for a property here.",
                            size: Dimensions.font20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SmallText(
                                text: 'Apartments',
                                color: greyColor,
                                size: Dimensions.font16,
                              ),
                              SizedBox(width: Dimensions.font10 / 2),
                              BigText(
                                text: '.',
                                color: greyColor,
                                size: Dimensions.font22,
                              ),
                              SizedBox(width: Dimensions.font10 / 2),
                              SmallText(
                                text: 'Offices',
                                color: greyColor,
                                size: Dimensions.font16,
                              ),
                              SizedBox(width: Dimensions.font10 / 2),
                              BigText(
                                text: '.',
                                color: greyColor,
                                size: Dimensions.font22,
                              ),
                              SizedBox(width: Dimensions.font10 / 2),
                              SmallText(
                                text: 'Shops',
                                color: greyColor,
                                size: Dimensions.font16,
                              ),
                              SizedBox(width: Dimensions.font10 / 2),
                              BigText(
                                text: '.',
                                color: greyColor,
                                size: Dimensions.font22,
                              ),
                              SizedBox(width: Dimensions.font10 / 2),
                              SmallText(
                                text: 'Farms',
                                color: greyColor,
                                size: Dimensions.font16,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SEARCH BAR

          // TABS
          TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(fontSize: Dimensions.font20),
            unselectedLabelColor: Colors.grey,
            // indicatorPadding:
            // EdgeInsets.symmetric(horizontal: Dimensions.width15),
            labelPadding: EdgeInsets.zero,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Apartments'),
              Tab(text: 'Offices'),
              Tab(text: 'Farms'),
              Tab(text: 'Shops'),
            ],
          ),

          SizedBox(height: Dimensions.height10),
          // TAB VIEWS
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                // FEED SCREEN SHOWING PROPERTIES
                AllPropertiesFeed(),
                ApartmentsFeed(),
                OfficesFeed(),
                FarmsFeed(),
                ShopsFeed(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
