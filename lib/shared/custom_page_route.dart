import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;
  CustomPageRoute({
    required this.child,
    required this.direction,
  }) : super(
          transitionDuration: Duration(milliseconds: 200),
          reverseTransitionDuration: Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      child: child,
      position: Tween<Offset>(
        begin: getBeginOffSet(),
        end: Offset.zero,
      ).animate(animation),
    );
  }

  Offset getBeginOffSet() {
    switch (direction) {
      case AxisDirection.up:
        return Offset(
          0,
          1,
        );
      case AxisDirection.down:
        return Offset(0, -1);

      case AxisDirection.right:
        return Offset(-1, 0);
      case AxisDirection.left:
        return Offset(1, 0);
    }
  }
}
