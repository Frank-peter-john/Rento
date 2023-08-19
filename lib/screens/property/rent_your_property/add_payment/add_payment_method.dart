// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rento/utils/colors.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';
import 'package:rento/widgets/buttons/multpurpose_button.dart';
import 'package:rento/widgets/buttons/next_button.dart';
import 'package:rento/widgets/navigation.dart';
import 'payment_methods/finish_tab.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({
    super.key,
  });

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Tab> _tabs = [
    const Tab(text: 'Banks'),
    const Tab(text: 'Crypto'),
    const Tab(text: 'PayPal'),
    const Tab(text: 'Finish'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

// THIS METHOD ENABLES NAVIGATION TO THE NEXT TAB
  void goToNextTab() {
    final newIndex = _tabController.index + 1;
    if (newIndex < _tabs.length) {
      _tabController.animateTo(newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopNavigation(
            text: 'Add a payment method',
            icon: Icons.arrow_back_outlined,
          ),
          Container(
            margin: EdgeInsets.only(
              left: Dimensions.width30,
              right: Dimensions.width30,
              top: Dimensions.height20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SmallText(
                  text: "Finally, add a payment method.",
                  size: Dimensions.font16,
                ),
                SizedBox(height: Dimensions.height20),
                SmallText(
                  text:
                      "How would you like to receive payment? You can add more than one payment method.",
                  size: Dimensions.font14,
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.height20),
          TabBar(
            indicatorPadding:
                EdgeInsets.symmetric(horizontal: Dimensions.width30),
            controller: _tabController,
            tabs: _tabs,
            labelColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(fontSize: Dimensions.font16),
            unselectedLabelColor: greyColor,
            unselectedLabelStyle: TextStyle(fontSize: Dimensions.font14),
            indicatorColor: Theme.of(context).primaryColor,
          ),
          SizedBox(height: Dimensions.height20),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                BankPaymentMethod(),
                CryptoPaymentMethod(),
                PayPalPaymentMethod(),
                FinishTab()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BankPaymentMethod extends StatefulWidget {
  // final VoidCallback saveBankDetails;
  const BankPaymentMethod({
    super.key,
  });

  @override
  State<BankPaymentMethod> createState() => _BankPaymentMethodState();
}

class _BankPaymentMethodState extends State<BankPaymentMethod> {
  List<String> selectedBanks = [];
  Map<String, TextEditingController> bankAccountControllers = {};
  late bool showSkipButton = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

// THIS METHOD CONTROLS THE VISIBILITY  OF THE SKIP BUTTON
  void updateSkipButtonVisibility() {
    setState(() {
      showSkipButton = selectedBanks.isEmpty;
    });
  }

// THIS METHOD VALIDATES AND SAVES THE BANK DETAILS CHOSEN BY THE OWNER.
  void saveBankDetails() async {
    final isValid = _formKey.currentState!.validate();

    /* Remove the cursor on submiting the form  */
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final collectionRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('paymentMethods');

        for (final bank in selectedBanks) {
          final accountNumber = bankAccountControllers[bank]?.text ?? '';
          final paymentMethod = {
            'methodType': 'Bank',
            'bankName': bank,
            'accountNumber': accountNumber,
          };

          final newDocRef =
              collectionRef.doc(bank); // Use bank name as the document ID

          await newDocRef.set(paymentMethod);
        }
        setState(() {
          _isLoading = false;
        });
        // Navigate to the next tab
        final addPaymentMethodState =
            context.findAncestorStateOfType<_AddPaymentMethodState>();
        addPaymentMethodState?.goToNextTab();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in bankAccountControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // DEFINING THE INPUT BORDER STRUCTURE
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context,
          color: Theme.of(context).primaryColor, width: 0.5),
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dimensions.radius20 / 2,
        ),
      ),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                value: selectedBanks.contains("CRDB"),
                checkColor: isDark ? blackColor : whiteColor,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(
                    () {
                      if (value == true) {
                        selectedBanks.add("CRDB");
                        bankAccountControllers["CRDB"] =
                            TextEditingController();
                      } else {
                        selectedBanks.remove("CRDB");
                        bankAccountControllers.remove("CRDB");
                      }
                      updateSkipButtonVisibility();
                    },
                  );
                },
                title: SmallText(
                  text: "CRDB",
                  size: Dimensions.font14,
                ),
              ),
              CheckboxListTile(
                value: selectedBanks.contains("NBC"),
                checkColor: isDark ? blackColor : whiteColor,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedBanks.add("NBC");
                      bankAccountControllers["NBC"] = TextEditingController();
                    } else {
                      selectedBanks.remove("NBC");
                      bankAccountControllers.remove("NBC");
                    }
                    updateSkipButtonVisibility();
                  });
                },
                title: SmallText(
                  text: "NBC",
                  size: Dimensions.font14,
                ),
              ),
              CheckboxListTile(
                value: selectedBanks.contains("NMB"),
                checkColor: isDark ? blackColor : whiteColor,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedBanks.add("NMB");
                      bankAccountControllers["NMB"] = TextEditingController();
                    } else {
                      selectedBanks.remove("NMB");
                      bankAccountControllers.remove("NMB");
                    }
                    updateSkipButtonVisibility();
                  });
                },
                title: SmallText(
                  text: "NMB",
                  size: Dimensions.font14,
                ),
              ),
              CheckboxListTile(
                value: selectedBanks.contains("STANBIC"),
                checkColor: isDark ? blackColor : whiteColor,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedBanks.add("STANBIC");
                      bankAccountControllers["STANBIC"] =
                          TextEditingController();
                    } else {
                      selectedBanks.remove("STANBIC");
                      bankAccountControllers.remove("STANBIC");
                    }
                    updateSkipButtonVisibility();
                  });
                },
                title: SmallText(
                  text: "STANBIC",
                  size: Dimensions.font14,
                ),
              ),
              CheckboxListTile(
                value: selectedBanks.contains("EXIM"),
                checkColor: isDark ? blackColor : whiteColor,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedBanks.add("EXIM");
                      bankAccountControllers["EXIM"] = TextEditingController();
                    } else {
                      selectedBanks.remove("EXIM");
                      bankAccountControllers.remove("EXIM");
                    }
                    showSkipButton = false;
                  });
                },
                title: SmallText(
                  text: "EXIM",
                  size: Dimensions.font14,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Visibility(
                visible: showSkipButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to the next tab
                        final addPaymentMethodState = context
                            .findAncestorStateOfType<_AddPaymentMethodState>();
                        addPaymentMethodState?.goToNextTab();
                      },
                      child: MultipurposeButton(
                        text: 'Skip',
                        textColor: whiteColor,
                        backgroundColor:
                            isDark ? darkSearchBarColor : blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedBanks.isNotEmpty)
                Column(
                  children: [
                    for (String bank in selectedBanks)
                      Container(
                        margin: EdgeInsets.only(bottom: Dimensions.height10),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width30,
                          ),
                          child: TextFormField(
                            controller: bankAccountControllers[bank],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the account number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: '$bank Account',
                              labelStyle: TextStyle(
                                fontSize: Dimensions.font12,
                                decorationColor: greyColor,
                                color: Theme.of(context).primaryColor,
                              ),
                              border: inputBorder,
                              focusedBorder: inputBorder,
                            ),
                            cursorColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    SizedBox(height: Dimensions.height20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: saveBankDetails,
                          child: _isLoading
                              ? SizedBox(
                                  width: Dimensions.width20,
                                  height: Dimensions.height20,
                                  child: const CircularProgressIndicator(
                                    color: purpleColor,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const NextButton(
                                  text: 'Save and continue',
                                ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height30),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CryptoPaymentMethod extends StatefulWidget {
  const CryptoPaymentMethod({Key? key}) : super(key: key);

  @override
  State<CryptoPaymentMethod> createState() => _CryptoPaymentMethodState();
}

class _CryptoPaymentMethodState extends State<CryptoPaymentMethod> {
  List<String> selectedCoins = [];
  Map<String, TextEditingController> cryptoPaymentControllers = {};
  bool showSkipButton = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var controller in cryptoPaymentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // THIS METHOD CONTROLS THE VISIBILITY  OF THE SKIP BUTTON
  void updateSkipButtonVisibility() {
    setState(() {
      showSkipButton = selectedCoins.isEmpty;
    });
  }

// THIS METHOD SAVES THE BANK DETAILS CHOSEN BY A USER.
  void saveCryptoDetails() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final collectionRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('paymentMethods');
        for (final coin in selectedCoins) {
          final walletAdress = cryptoPaymentControllers[coin]?.text ?? '';
          final paymentMethod = {
            'methodType': 'Crypto',
            'coinName': coin,
            'walletAdress': walletAdress,
          };

          final newDocRef =
              collectionRef.doc(coin); // Use bank name as the document ID

          await newDocRef.set(paymentMethod);
        }

        setState(() {
          _isLoading = false;
        });
      }

      // Navigate to the next tab
      final addPaymentMethodState =
          context.findAncestorStateOfType<_AddPaymentMethodState>();
      addPaymentMethodState?.goToNextTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // DEFINING THE INPUT BORDER STRUCTURE
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context,
          color: Theme.of(context).primaryColor, width: 0.5),
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dimensions.radius20 / 2,
        ),
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.width30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                value: selectedCoins.contains("BITCOIN"),
                checkColor: isDark ? blackColor : whiteColor,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(
                    () {
                      if (value == true) {
                        selectedCoins.add("BITCOIN");
                        cryptoPaymentControllers["BITCOIN"] =
                            TextEditingController();
                      } else {
                        selectedCoins.remove("BITCOIN");
                        cryptoPaymentControllers.remove("BITCOIN");
                      }
                      updateSkipButtonVisibility();
                    },
                  );
                },
                title: SmallText(
                  text: "BITCOIN",
                  size: Dimensions.font14,
                ),
              ),
              CheckboxListTile(
                value: selectedCoins.contains("ETHERIUM"),
                checkColor: isDark ? blackColor : whiteColor,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedCoins.add("ETHERIUM");
                      cryptoPaymentControllers["ETHERIUM"] =
                          TextEditingController();
                    } else {
                      selectedCoins.remove("ETHERIUM");
                      cryptoPaymentControllers.remove("ETHERIUM");
                    }
                    updateSkipButtonVisibility();
                  });
                },
                title: SmallText(
                  text: "ETHERIUM",
                  size: Dimensions.font14,
                ),
              ),
              CheckboxListTile(
                value: selectedCoins.contains("DOGE"),
                checkColor: isDark ? blackColor : whiteColor,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedCoins.add("DOGE");
                      cryptoPaymentControllers["DOGE"] =
                          TextEditingController();
                    } else {
                      selectedCoins.remove("DOGE");
                      cryptoPaymentControllers.remove("DOGE");
                    }
                    updateSkipButtonVisibility();
                  });
                },
                title: SmallText(
                  text: "DOGE",
                  size: Dimensions.font14,
                ),
              ),
              CheckboxListTile(
                value: selectedCoins.contains("SOLANA"),
                checkColor: isDark ? blackColor : whiteColor,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      selectedCoins.add("SOLANA");
                      cryptoPaymentControllers["SOLANA"] =
                          TextEditingController();
                    } else {
                      selectedCoins.remove("SOLANA");
                      cryptoPaymentControllers.remove("SOLANA");
                    }
                    updateSkipButtonVisibility();
                  });
                },
                title: SmallText(
                  text: "SOLANA",
                  size: Dimensions.font14,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Visibility(
                visible: showSkipButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to the next tab
                        final addPaymentMethodState = context
                            .findAncestorStateOfType<_AddPaymentMethodState>();
                        addPaymentMethodState?.goToNextTab();
                      },
                      child: MultipurposeButton(
                        text: 'Skip',
                        textColor: whiteColor,
                        backgroundColor:
                            isDark ? darkSearchBarColor : blackColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedCoins.isNotEmpty)
                Column(
                  children: [
                    for (String coin in selectedCoins)
                      Container(
                        margin: EdgeInsets.only(bottom: Dimensions.height10),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width30),
                          child: TextFormField(
                            controller: cryptoPaymentControllers[coin],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the coin adress';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: '$coin address',
                              labelStyle: TextStyle(
                                fontSize: Dimensions.font12,
                                decorationColor: greyColor,
                                color: Theme.of(context).primaryColor,
                              ),
                              border: inputBorder,
                              focusedBorder: inputBorder,
                            ),
                            cursorColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    SizedBox(height: Dimensions.height20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: saveCryptoDetails,
                          child: _isLoading
                              ? SizedBox(
                                  width: Dimensions.width20,
                                  height: Dimensions.height20,
                                  child: const CircularProgressIndicator(
                                    color: purpleColor,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const NextButton(
                                  text: 'Save and continue',
                                ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height30),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// PAYPAL PAYMENT CLASS
class PayPalPaymentMethod extends StatefulWidget {
  const PayPalPaymentMethod({super.key});

  @override
  State<PayPalPaymentMethod> createState() => _PayPalPaymentMethodState();
}

class _PayPalPaymentMethodState extends State<PayPalPaymentMethod> {
  TextEditingController paypalEmailController = TextEditingController();
  bool showSkipButton = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    paypalEmailController.dispose();
    super.dispose();
  }

  void savePayPalDetails() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final collectionRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('paymentMethods');

        final payPalEmail = paypalEmailController.text;
        final paymentMethod = {
          'methodType': 'Paypal',
          'payPalEmail': payPalEmail,
        };

        final newDocRef =
            collectionRef.doc('Paypal'); // Use 'Paypal' as the document ID

        await newDocRef.set(paymentMethod);
      }

      setState(() {
        _isLoading = false;
      });

      // Navigate to the next tab
      final addPaymentMethodState =
          context.findAncestorStateOfType<_AddPaymentMethodState>();
      addPaymentMethodState?.goToNextTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // DEFINING THE INPUT BORDER STRUCTURE
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context,
          color: Theme.of(context).primaryColor, width: 0.5),
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dimensions.radius20 / 2,
        ),
      ),
    );
    return Container(
      margin: EdgeInsets.only(
        left: Dimensions.width30,
        right: Dimensions.width30,
        top: Dimensions.height20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
              child: TextFormField(
                controller: paypalEmailController,
                validator: (value) {
                  if (value!.isEmpty ||
                      !value.contains('@') ||
                      !value.contains('.com')) {
                    return 'Please enter a valid Email address.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    showSkipButton = value.isEmpty;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter your PayPal Account',
                  labelStyle: TextStyle(
                    fontSize: Dimensions.font12,
                    decorationColor: greyColor,
                    color: Theme.of(context).primaryColor,
                  ),
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
                cursorColor: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: Dimensions.height20),
            Visibility(
              visible: showSkipButton,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to the next tab
                      final addPaymentMethodState = context
                          .findAncestorStateOfType<_AddPaymentMethodState>();
                      addPaymentMethodState?.goToNextTab();
                    },
                    child: MultipurposeButton(
                      text: 'Skip',
                      textColor: whiteColor,
                      backgroundColor: isDark ? darkSearchBarColor : blackColor,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !showSkipButton,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: savePayPalDetails,
                    child: _isLoading
                        ? SizedBox(
                            width: Dimensions.width20,
                            height: Dimensions.height20,
                            child: const CircularProgressIndicator(
                              color: purpleColor,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const NextButton(
                            text: 'Save and Continue',
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
