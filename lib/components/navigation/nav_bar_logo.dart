import 'package:flutter/material.dart';

class NavBarLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Image.asset(
        'assets/images/web-logo.png',
      ),
      width: 160.0,
    );
  }
}
