import 'package:booklogr/screens/home_screen_mobile.dart';
import 'package:booklogr/screens/search_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeScreen extends StatelessWidget {
  static final String pageRoute = "/";

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      if (sizingInformation.isMobile) {
        return HomeScreenMobile();
      } else {
        return SearchFormScreen();
      }
    });
  }
}
