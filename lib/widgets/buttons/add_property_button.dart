import 'package:flutter/material.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';

class AddPropertyButton extends StatelessWidget {
  const AddPropertyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: Dimensions.height10 / 2,
        left: Dimensions.width20,
        right: Dimensions.width10,
        bottom: Dimensions.height10 / 3,
      ),
      width: Dimensions.width350 * 2.5,
      height: Dimensions.height20 * 4,
      decoration: BoxDecoration(
        color: purpleColor,
        borderRadius: BorderRadius.all(
          Radius.circular(Dimensions.radius20 / 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(
            text: "Rento your property",
            size: Dimensions.font16,
            color: whiteColor,
          ),
          // SizedBox(height: Dimensions.height10),
          Row(
            children: [
              Icon(
                Icons.house_outlined,
                color: whiteColor,
                size: Dimensions.iconSize30,
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: Dimensions.height10 / 1.5),
                      SmallText(
                        text: "It's  easy to set up and start earning.",
                        color: whiteColor,
                        size: Dimensions.font14,
                      ),

                      // PROPERTIES
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SmallText(
                            text: 'Apartments',
                            color: whiteColor,
                            size: Dimensions.font12,
                          ),
                          SizedBox(width: Dimensions.font10 / 4),
                          BigText(
                            text: '.',
                            color: whiteColor,
                            size: Dimensions.font18,
                          ),
                          SizedBox(width: Dimensions.font10 / 4),
                          SmallText(
                            text: 'Offices',
                            color: whiteColor,
                            size: Dimensions.font12,
                          ),
                          SizedBox(width: Dimensions.font10 / 4),
                          BigText(
                            text: '.',
                            color: whiteColor,
                            size: Dimensions.font18,
                          ),
                          SizedBox(width: Dimensions.font10 / 4),
                          SmallText(
                            text: 'Shops',
                            color: whiteColor,
                            size: Dimensions.font12,
                          ),
                          SizedBox(width: Dimensions.font10 / 4),
                          BigText(
                            text: '.',
                            color: whiteColor,
                            size: Dimensions.font18,
                          ),
                          SizedBox(width: Dimensions.font10 / 4),
                          SmallText(
                            text: 'Farms',
                            color: whiteColor,
                            size: Dimensions.font12,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
