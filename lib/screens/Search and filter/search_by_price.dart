import 'package:flutter/material.dart';
import 'package:rento/screens/Search%20and%20filter/search_apartment.dart';
import 'package:rento/widgets/buttons/multpurpose_button.dart';
import 'package:rento/widgets/navigation.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/small_text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double minPrice = 0;
  double maxPrice = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _searchProperty() async {
    final isValid = _formKey.currentState!.validate();
    /* Remove the cursor on submiting the form  */
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      // this triggers all the save functions in the form
      _formKey.currentState!.save();
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchApatmentScreen(
            minPrice: minPrice,
            maxPrice: maxPrice,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
// DEFINING THE INPUT BORDER STRUCTURE
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(
        context,
        color: greyColor,
        width: 0.5,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dimensions.radius20 / 2,
        ),
      ),
    );
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height30,
          left: Dimensions.width20,
          right: Dimensions.width20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopNavigation(
                text: 'Search property by price',
                icon: Icons.arrow_back,
              ),
              SmallText(
                text: "Enter your minimum price ",
                size: Dimensions.font14,
              ),
              SizedBox(height: Dimensions.height10),
              TextFormField(
                key: const ValueKey('minPrice'),
                onChanged: (value) {
                  minPrice = double.parse(value);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the minimum price.';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.font16,
                ),
                decoration: InputDecoration(
                  labelText: 'minimum price',
                  labelStyle: TextStyle(
                    fontSize: Dimensions.font15,
                    color: Theme.of(context).primaryColor,
                  ),
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              SmallText(
                text: "Enter your maximum price . ",
                size: Dimensions.font14,
              ),
              SizedBox(height: Dimensions.height10),
              TextFormField(
                key: const ValueKey('maxPrice'),
                onChanged: (value) {
                  maxPrice = double.parse(value);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your maximum price.';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.font16,
                ),
                decoration: InputDecoration(
                  labelText: ' maximum price',
                  labelStyle: TextStyle(
                    fontSize: Dimensions.font15,
                    color: Theme.of(context).primaryColor,
                  ),
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: purpleColor,
                        )
                      : GestureDetector(
                          onTap: _searchProperty,
                          child: const MultipurposeButton(
                            text: 'Search',
                            textColor: whiteColor,
                            backgroundColor: purpleColor,
                          ),
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
