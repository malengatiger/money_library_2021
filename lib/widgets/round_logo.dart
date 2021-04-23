import 'package:flutter/material.dart';
import 'package:money_library_2021/util/util.dart';

class RoundLogo extends StatefulWidget {
  final double radius, margin;
  const RoundLogo({Key? key, required this.radius, required this.margin})
      : super(key: key);

  @override
  _RoundLogoState createState() => _RoundLogoState();
}

class _RoundLogoState extends State<RoundLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.radius,
      height: widget.radius,
      decoration: BoxDecoration(
          boxShadow: customShadow,
          color: secondaryColor,
          shape: BoxShape.circle),
      child: Center(
        child: ScaleTransition(
          scale: animation as Animation<double>,
          child: Container(
            width: widget.radius - widget.margin,
            height: widget.radius - widget.margin,
            decoration: BoxDecoration(
                boxShadow: customShadow,
                color: baseColor,
                shape: BoxShape.circle),
            child: Center(
              child: Image.asset('assets/logo/logo.png', scale: .5),
            ),
          ),
        ),
      ),
    );
  }
}
