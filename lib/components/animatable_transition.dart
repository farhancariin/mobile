import 'package:flutter/material.dart';

class AnimatableTransisition extends PageRouteBuilder {
  final Widget widget;
  final double horizontal;
  final double vertical;

  AnimatableTransisition({this.horizontal : 0.0, this.vertical: 0.0,this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return widget;
  }, transitionsBuilder: (BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return new SlideTransition(
      position: new Tween<Offset>(
        begin:  Offset(horizontal, vertical),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  });
}
