import 'package:flutter/material.dart';
import 'package:rento/widgets/navigation.dart';

class PaymentsTermsOfservice extends StatelessWidget {
  const PaymentsTermsOfservice({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          TopNavigation(
            text: 'Payments and Payouts',
            icon: Icons.arrow_back,
          ),
        ],
      ),
    );
  }
}
