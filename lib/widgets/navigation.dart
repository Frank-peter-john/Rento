import 'package:flutter/material.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/dimensions.dart';

class TopNavigation extends StatelessWidget {
  final String text;
  final IconData icon;

  const TopNavigation({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return // NAVIGATION
        Container(
      margin: EdgeInsets.only(
        top: Dimensions.height20,
        left: Dimensions.width10,
        right: Dimensions.width10,
        bottom: Dimensions.height10,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              icon,
              size: Dimensions.iconSize20,
            ),
          ),
          SizedBox(width: Dimensions.width30 * 3),
          BigText(
            text: text,
            size: Dimensions.font18,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
