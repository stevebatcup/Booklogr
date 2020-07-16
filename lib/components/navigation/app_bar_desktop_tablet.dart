import 'package:booklogr/components/navigation/nav_bar.dart';
import 'package:booklogr/components/navigation/user_menu.dart';
import 'package:booklogr/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'nav_bar_sign_in.dart';

class AppBarDesktopTablet extends StatelessWidget
    implements PreferredSizeWidget {
  final NavBarSection activeSection;

  AppBarDesktopTablet({this.activeSection});

  @override
  Size get preferredSize => Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    bool showLogo = !Navigator.canPop(context);
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    return AppBar(
      leading: null,
      centerTitle: false,
      iconTheme: IconThemeData(color: kPrimaryColour),
      title: NavBar(activeSection: activeSection, showLogo: showLogo),
      actions: <Widget>[
        if (loggedIn) UserMenu(),
        if (!loggedIn) NavBarSignIn(),
      ],
      backgroundColor: Colors.grey[50],
    );
  }
}
