import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WebPageRoute<T> extends MaterialPageRoute<T> {
  WebPageRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }
}
