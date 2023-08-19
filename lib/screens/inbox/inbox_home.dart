import 'package:flutter/material.dart';
import '../../utils/big_text.dart';
import '../../utils/dimensions.dart';
import 'message_screen.dart';
import 'notifications.dart';

class InboxHomeScreen extends StatefulWidget {
  const InboxHomeScreen({super.key});

  @override
  State<InboxHomeScreen> createState() => _InboxHomeScreenState();
}

class _InboxHomeScreenState extends State<InboxHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height30,
          right: Dimensions.width20,
          left: Dimensions.width20,
          bottom: Dimensions.height10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: Dimensions.height10,
              ),
              child: BigText(
                text: 'Inbox',
                size: Dimensions.font24,
              ),
            ),
            // TABS
            TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(fontSize: Dimensions.font14),
              unselectedLabelColor: Colors.grey,
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: Dimensions.width30 * 2),
              labelPadding: EdgeInsets.zero,
              tabs: const [
                Tab(text: 'Messages'),
                Tab(text: 'Notifications'),
              ],
            ),

            SizedBox(height: Dimensions.height10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  MessagesScreen(),
                  NotificationsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
