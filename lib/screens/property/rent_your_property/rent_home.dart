import 'package:flutter/material.dart';
import 'package:rento/screens/property/rent_your_property/add_farm.dart/farm_details.dart';
import 'package:rento/screens/property/rent_your_property/add_office/office_details.dart';
import 'package:rento/screens/property/rent_your_property/add_shop/shop_details.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/rento_heading.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/continue_with.dart';
import 'add_apartment/add_apartment_details.dart';

class RentHomeScreen extends StatelessWidget {
  const RentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height20,
          left: Dimensions.width10,
          right: Dimensions.width10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: Dimensions.iconSize24,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: Dimensions.width30 * 5),
                const RentoHeading(),
              ],
            ),
            SizedBox(height: Dimensions.height30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bottom border
                  Container(
                    margin: EdgeInsets.only(
                      bottom: Dimensions.height20,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: isDark
                            ? const BorderSide(
                                color: greyColor,
                                width: 0.5,
                              )
                            : const BorderSide(
                                color: greyColor,
                                width: 0.3,
                              ),
                      ),
                    ),
                  ),
                  BigText(
                    text: 'Hello, Welcome to Rento earning!',
                    size: Dimensions.font18,
                  ),
                  SizedBox(height: Dimensions.height10),
                  SmallText(
                    text: "Rent your property and start earning instantly.",
                    size: Dimensions.font14,
                  ),
                  SizedBox(height: Dimensions.height30),
                  SmallText(
                    text: "What type of property do you want to rent?",
                    size: Dimensions.font16,
                  ),
                  SizedBox(height: Dimensions.height20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const AddApartmentDetails();
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
                        return const AddOfficeDetails();
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
                        return const AddShopDetails();
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
                        return const AddFarmDetails();
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
