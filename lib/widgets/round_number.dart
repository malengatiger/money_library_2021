import 'package:flutter/material.dart';
import 'package:money_library_2021/util/functions.dart';
import 'package:money_library_2021/util/util.dart';

class RoundNumberWidget extends StatelessWidget {
  final int number;
  final double radius, margin;
  final Color marginColor, mainColor;
  final TextStyle textStyle;

  const RoundNumberWidget(
      {Key key,
      @required this.number,
      @required this.radius,
      @required this.margin,
      @required this.marginColor,
      @required this.mainColor,
      @required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius + margin,
      height: radius + margin,
      decoration: BoxDecoration(
          boxShadow: customShadow,
          color: marginColor == null ? secondaryColor : marginColor,
          shape: BoxShape.circle),
      child: Center(
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
              boxShadow: customShadow,
              color: mainColor == null ? baseColor : mainColor,
              shape: BoxShape.circle),
          child: Center(
            child: Text(
              "$number",
              style: textStyle == null ? Styles.blackBoldSmall : textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
