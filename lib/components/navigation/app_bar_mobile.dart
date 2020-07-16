import 'package:booklogr/components/navigation/user_menu.dart';
import 'package:flutter/material.dart';
import 'package:booklogr/utils/utils.dart';

import 'nav_bar_sign_in.dart';

class AppBarMobile extends StatelessWidget implements PreferredSizeWidget {
  AppBarMobile({this.selectedTabName, this.loggedIn});

  final String selectedTabName;
  final bool loggedIn;

  @override
  Size get preferredSize => Size.fromHeight(55.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15.0,
        ),
        child: Text(
          selectedTabName,
          style: kAppBarTextStyle,
        ),
      ),
      actions: <Widget>[
        if (loggedIn) UserMenu(),
        if (!loggedIn) NavBarSignIn(),
      ],
      backgroundColor: kNavBarBackground,
    );
  }
}
