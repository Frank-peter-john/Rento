import 'package:flutter/material.dart';
import 'package:rento/widgets/navigation.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(children: [
        TopNavigation(
          text: "Privacy policy",
          icon: Icons.arrow_back,
        )
      ]),
    );
  }
}
