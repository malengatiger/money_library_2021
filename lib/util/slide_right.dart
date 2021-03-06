import 'package:flutter/material.dart';

/// Slide right
class SlideRightRoute extends PageRouteBuilder {
  final Widget? widget;

  SlideRightRoute({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget!;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        });
}

class ScaleRoute extends PageRouteBuilder {
  final Widget? widget;
  static late AnimationController animationController;
  static var _animation =
      CurvedAnimation(parent: animationController, curve: Curves.bounceInOut);

  ScaleRoute({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget!;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return ScaleTransition(scale: _animation);
        });
}
