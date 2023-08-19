import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rento/screens/account/account_login.dart';
import 'package:rento/screens/main/home_screen.dart';
import 'package:rento/screens/property/my_properties/my_properties_login_screen.dart';
import 'package:rento/screens/inbox/inbox_login.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void onTapNav(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  // List of all pages.
  List pages = [
    const Homescreen(),
    const MyPropertiesLogin(),
    const InboxLoginScreen(),
    const AccountLoginScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? blackColor : whiteColor,
        useLegacyColorScheme: false,
        iconSize: Dimensions.iconSize24,
        selectedItemColor: isDark ? whiteColor : purpleColor,
        unselectedItemColor: greyColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex /*shows which icon is active*/,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        onTap: onTapNav,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            activeIcon: Icon(
              CupertinoIcons.search,
            ),
            label: "Explore",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_home_outlined),
            activeIcon: Icon(Icons.add_home_outlined),
            label: "Add property",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svgs/message-regular.svg',
              width: Dimensions.iconSize22,
              height: Dimensions.iconSize22,
              color: greyColor,
            ),
            activeIcon: SvgPicture.asset(
              'assets/svgs/message-regular.svg',
              width: Dimensions.iconSize24,
              height: Dimensions.iconSize24,
              color: isDark ? whiteColor : purpleColor,
            ),
            label: "inbox",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person_outline),
            label: "profile",
          ),
        ],
      ),
    );
  }
}
