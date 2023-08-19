import 'package:flutter/material.dart';
import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/dimensions.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          Icons.notifications_outlined,
          color: Theme.of(context).primaryColor,
          size: Dimensions.iconSize30,
        ),
        Positioned(
          top: -1,
          right: 0,
          child: Icon(
            Icons.circle,
            color: Colors.blue,
            size: Dimensions.iconSize20,
          ),
        ),
        Positioned(
          top: 2,
          right: Dimensions.width10,
          child: BigText(
            text: '3',
            size: Dimensions.iconSize15,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
