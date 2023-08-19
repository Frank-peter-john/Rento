import 'package:flutter/material.dart';
import 'package:rento/utils/dimensions.dart';
import 'package:rento/utils/small_text.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({
    super.key,
    required this.text,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  // This variables will hold the first and second parts of the text.
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;
  double textHeight = Dimensions.screenHeight / 7;

  @override
  void initState() {
    super.initState();
    // Check if text length is more than textheight required.
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt(), widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? SmallText(
              height: 1.5,
              color: Theme.of(context).primaryColor,
              text: firstHalf,
              size: Dimensions.font14,
            )
          : Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: SmallText(
                    height: 1.8,
                    color: Theme.of(context).primaryColor,
                    size: Dimensions.font12,
                    text: hiddenText
                        ? ('$firstHalf....view more')
                        : ('$firstHalf$secondHalf ...view less'),
                  ),
                ),
              ],
            ),
    );
  }
}
