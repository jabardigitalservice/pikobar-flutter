import 'package:flutter/material.dart';

enum PageTransitionType {
  fade,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade,
}

class PageTransition<T> extends PageRouteBuilder<T> {
  final Widget child;
  final PageTransitionType type;
  final Curve curve;
  final Alignment alignment;
  final Duration duration;

  PageTransition({
    Key key,
    @required this.child,
    @required this.type,
    this.curve = Curves.linear,
    this.alignment,
    this.duration = const Duration(milliseconds: 300),
    RouteSettings settings,
  }) : super(
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return child;
      },
      transitionDuration: duration,
      settings: settings,
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) {
        switch (type) {
          case PageTransitionType.fade:
            return FadeTransition(opacity: animation, child: child);
            break;
          case PageTransitionType.rightToLeft:
            return SlideTransition(
              transformHitTests: false,
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-1.0, 0.0),
                ).animate(secondaryAnimation),
                child: child,
              ),
            );
            break;
          case PageTransitionType.leftToRight:
            return SlideTransition(
              transformHitTests: false,
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: SlideTransition(
                position:  Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(1.0, 0.0),
                ).animate(secondaryAnimation),
                child: child,
              ),
            );
            break;
          case PageTransitionType.upToDown:
            return SlideTransition(
              transformHitTests: false,
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(animation),
              child:  SlideTransition(
                position:  Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0.0, 1.0),
                ).animate(secondaryAnimation),
                child: child,
              ),
            );
            break;
          case PageTransitionType.downToUp:
            return SlideTransition(
              transformHitTests: false,
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child:  SlideTransition(
                position:  Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0.0, -1.0),
                ).animate(secondaryAnimation),
                child: child,
              ),
            );
            break;
          case PageTransitionType.scale:
            return ScaleTransition(
              alignment: alignment,
              scale: CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.00,
                  0.50,
                  curve: curve,
                ),
              ),
              child: child,
            );
            break;
          case PageTransitionType.rotate:
            return  RotationTransition(
              alignment: alignment,
              turns: animation,
              child:  ScaleTransition(
                alignment: alignment,
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
            );
            break;
          case PageTransitionType.size:
            return Align(
              alignment: alignment,
              child: SizeTransition(
                sizeFactor: CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
                child: child,
              ),
            );
            break;
          case PageTransitionType.rightToLeftWithFade:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(-1.0, 0.0),
                  ).animate(secondaryAnimation),
                  child: child,
                ),
              ),
            );
            break;
          case PageTransitionType.leftToRightWithFade:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(1.0, 0.0),
                  ).animate(secondaryAnimation),
                  child: child,
                ),
              ),
            );
            break;
          default:
            return FadeTransition(opacity: animation, child: child);
        }
      });
}

class FadedPageRoute<T> extends PageRoute<T> {
  FadedPageRoute(this.child);
  @override
  // TODO: implement barrierColor
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;


  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}

class SizedPageRoute<T> extends PageRoute<T> {
  SizedPageRoute(this.child);
  @override
  // TODO: implement barrierColor
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;


  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Align(
      child: SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}