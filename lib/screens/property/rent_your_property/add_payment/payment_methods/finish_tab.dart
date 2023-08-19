import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:rento/screens/main/main_screen.dart';

import 'package:rento/utils/big_text.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/login_button.dart';
import '../../../../../utils/colors.dart';

class FinishTab extends StatefulWidget {
  const FinishTab({Key? key}) : super(key: key);

  @override
  State<FinishTab> createState() => _FinishTabState();
}

class _FinishTabState extends State<FinishTab> {
  List<Map<String, dynamic>> paymentMethods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPaymentMethods();
  }

  Future<void> fetchPaymentMethods() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final paymentMethodsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('paymentMethods');

      final snapshot = await paymentMethodsCollection.get();

      final List<Map<String, dynamic>> methods = [];

      for (var doc in snapshot.docs) {
        final method = doc.data();
        methods.add(method);
      }

      setState(() {
        paymentMethods = methods;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: purpleColor,
              strokeWidth: 5,
            ),
          )
        : SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(Dimensions.height15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: BigText(
                      text: 'Your payment methods',
                      size: Dimensions.font16,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),
                  paymentMethods.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SmallText(
                              text: 'No payment method chosen.',
                              size: Dimensions.font16,
                              color: greyColor,
                            ),
                            SizedBox(height: Dimensions.height10),
                            SmallText(
                              text:
                                  'Please go back and choose atleast one payment method.',
                              color: greyColor,
                              size: Dimensions.font16,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            if (paymentMethods.any(
                                (method) => method['methodType'] == 'Bank'))
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SmallText(
                                    text: 'Banks',
                                    size: Dimensions.font16,
                                  ),
                                  SizedBox(
                                    height: Dimensions.height10,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: paymentMethods.length,
                                    itemBuilder: (context, index) {
                                      final method = paymentMethods[index];
                                      if (method['methodType'] == 'Bank') {
                                        return BankPaymentMethodCard(
                                          bankName: method['bankName'],
                                          accountNumber:
                                              method['accountNumber'],
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                  SizedBox(height: Dimensions.height20),
                                ],
                              ),
                            if (paymentMethods.any(
                                (method) => method['methodType'] == 'Crypto'))
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SmallText(
                                    text: 'Crypto',
                                    size: Dimensions.font16,
                                  ),
                                  SizedBox(height: Dimensions.height10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: paymentMethods.length,
                                    itemBuilder: (context, index) {
                                      final method = paymentMethods[index];
                                      if (method['methodType'] == 'Crypto') {
                                        return CryptoPaymentMethodCard(
                                          coinName: method['coinName'],
                                          walletAddress: method['walletAdress'],
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                  SizedBox(height: Dimensions.height20),
                                ],
                              ),
                            if (paymentMethods.any(
                                (method) => method['methodType'] == 'Paypal'))
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SmallText(
                                    text: 'Paypal',
                                    size: Dimensions.font16,
                                  ),
                                  SizedBox(height: Dimensions.height10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: paymentMethods.length,
                                    itemBuilder: (context, index) {
                                      final method = paymentMethods[index];
                                      if (method['methodType'] == 'Paypal') {
                                        return PayPalPaymentMethodCard(
                                          payPalAddress: method['payPalEmail'],
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                  SizedBox(height: Dimensions.height20),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        // isDismissible: false,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius20),
                                        ),
                                        builder: (ctx) {
                                          return Center(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                top: Dimensions.height30,
                                                right: Dimensions.width20,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      size: Dimensions
                                                              .iconSize30 *
                                                          2,
                                                      color: greenColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions.height10,
                                                  ),
                                                  Center(
                                                    child: BigText(
                                                      text:
                                                          'You have Succesfully added your property.',
                                                      size: Dimensions.font16,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions.height30,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (context,
                                                                  animation,
                                                                  secondaryAnimation) =>
                                                              const MainScreen(),
                                                          transitionsBuilder:
                                                              (context,
                                                                  animation,
                                                                  secondaryAnimation,
                                                                  child) {
                                                            return FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child:
                                                                  const MainScreen(),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        LoginButton(
                                                            text: 'Done')
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions.height20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [LoginButton(text: 'Finish')],
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height30),
                                ],
                              ),
                          ],
                        ),
                ],
              ),
            ),
          );
  }
}

class BankPaymentMethodCard extends StatelessWidget {
  final String bankName;
  final String accountNumber;

  const BankPaymentMethodCard({
    super.key,
    required this.bankName,
    required this.accountNumber,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      color: isDark ? darkSearchBarColor : whiteColor,
      child: Container(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmallText(
              text: bankName,
              size: Dimensions.font14,
            ),
            SizedBox(height: Dimensions.height10 / 2),
            SmallText(text: accountNumber, size: Dimensions.font14),
          ],
        ),
      ),
    );
  }
}

class CryptoPaymentMethodCard extends StatelessWidget {
  final String? coinName;
  final String? walletAddress;

  const CryptoPaymentMethodCard({
    super.key,
    this.coinName,
    this.walletAddress,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      color: isDark ? darkSearchBarColor : whiteColor,
      child: Container(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (coinName != null)
              SmallText(
                text: coinName!,
                size: Dimensions.font14,
              ),
            if (walletAddress != null)
              SmallText(
                text: walletAddress!,
                size: Dimensions.font14,
              )
          ],
        ),
      ),
    );
  }
}

class PayPalPaymentMethodCard extends StatelessWidget {
  final String payPalAddress;

  const PayPalPaymentMethodCard({
    super.key,
    required,
    required this.payPalAddress,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      color: isDark ? darkSearchBarColor : whiteColor,
      child: Container(
        padding: EdgeInsets.all(Dimensions.height15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmallText(
              text: 'Paypal address',
              size: Dimensions.font14,
            ),
            SmallText(
              text: payPalAddress,
              size: Dimensions.font14,
            )
          ],
        ),
      ),
    );
  }
}
