import 'package:flutter/material.dart';
import 'package:money_library_2021/util/util.dart';

class RoundAvatar extends StatelessWidget {
  final String path;
  final double radius;
  final bool fromNetwork;
  final Color marginColor;
  final double margin;

  const RoundAvatar(
      {Key key,
      @required this.path,
      @required this.radius,
      @required this.fromNetwork,
      this.margin = 0.0,
      this.marginColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(path != null);
    if (fromNetwork) {
      return Container(
        height: radius + margin,
        width: radius + margin,
        decoration: BoxDecoration(
            boxShadow: customShadow,
            color: marginColor == null ? baseColor : marginColor,
            shape: BoxShape.circle),
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
              boxShadow: customShadow,
              color: baseColor,
              shape: BoxShape.circle),
          child: CircleAvatar(
            child: Image.asset(path),
          ),
        ),
      );
    } else {
      return Container(
        height: radius + margin,
        width: radius + margin,
        decoration: BoxDecoration(
            boxShadow: customShadow,
            color: marginColor == null ? baseColor : marginColor,
            shape: BoxShape.circle),
        child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
              boxShadow: customShadow,
              color: baseColor,
              shape: BoxShape.circle),
          child: CircleAvatar(
            backgroundImage: AssetImage(path),
          ),
        ),
      );
    }
  }
}

//
class MyAvatar extends StatelessWidget {
  final Icon icon;

  const MyAvatar({Key key, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          boxShadow: customShadow, color: baseColor, shape: BoxShape.circle),
      child: icon,
    );
  }
}
