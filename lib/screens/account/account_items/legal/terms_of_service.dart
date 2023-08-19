import 'package:flutter/material.dart';
import 'package:rento/widgets/navigation.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(children: [
        TopNavigation(
          text: "Terms of Service",
          icon: Icons.arrow_back,
        ),
      ]),
    );
  }
}
