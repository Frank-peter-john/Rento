import 'package:flutter/material.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/continue_with.dart';
import 'package:rento/widgets/navigation.dart';
import 'search_by_price.dart';

class PropertySearch extends StatelessWidget {
  const PropertySearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height30,
          left: Dimensions.width10,
          right: Dimensions.width10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopNavigation(
              text: 'Search property',
              icon: Icons.arrow_back,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimensions.height10),
                  SmallText(
                    text: "Let us help you get any property you want.",
                    size: Dimensions.font14,
                  ),
                  SizedBox(height: Dimensions.height30),
                  SmallText(
                    text: "Choose the property you want to search",
                    size: Dimensions.font16,
                  ),
                  SizedBox(height: Dimensions.height20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const SearchScreen();
                      }));
                    },
                    child: ContinueWith(
                      text: 'Apartment',
                      iconUrl: 'assets/icons/apartments.png',
                      iconColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const SearchScreen();
                      }));
                    },
                    child: ContinueWith(
                      text: 'Office space',
                      iconUrl: 'assets/icons/office1.png',
                      iconColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const SearchScreen();
                      }));
                    },
                    child: ContinueWith(
                      text: 'Shop',
                      iconUrl: 'assets/icons/shop.png',
                      iconColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const SearchScreen();
                      }));
                    },
                    child: ContinueWith(
                      text: 'Farmland',
                      iconUrl: 'assets/icons/farm.png',
                      iconColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
