import 'package:flutter/material.dart';
import 'package:rento/utils/dimensions.dart';

class ProfileImage extends StatefulWidget {
  final String profileImageurl;
  const ProfileImage({super.key, required this.profileImageurl});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  bool _expanded = false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        width: _expanded
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width / 3,
        height: _expanded
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            Dimensions.radius20,
          ),
          image: DecorationImage(
            image: AssetImage(
              widget.profileImageurl,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
