import 'package:flutter/material.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height30,
          right: Dimensions.width20,
          left: Dimensions.width20,
          bottom: Dimensions.height20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: Dimensions.height10,
              ),
              child: BigText(
                text: 'Wishlists',
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
          ],
        ),
      ),
    );
  }
}
