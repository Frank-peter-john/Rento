import 'package:flutter/material.dart';
import 'package:rento/utils/dimensions.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: Dimensions.width20,
              left: Dimensions.width10,
              right: Dimensions.width10,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                  ),
                ),
                SizedBox(width: Dimensions.width30 * 5),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
