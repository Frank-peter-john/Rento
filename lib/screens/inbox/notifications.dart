import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: Dimensions.iconSize30,
          ),
          SizedBox(
            height: Dimensions.height20,
          ),
          const Text(
            'No notifications yet, your notifications will appear here. ',
          ),
        ],
      ),
    );
  }
}
