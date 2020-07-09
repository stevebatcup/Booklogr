import 'package:flutter/material.dart';
import 'package:booklogr/utils/utils.dart';
import 'package:booklogr/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:booklogr/screens/sign_in_screen.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  MainAppBar({this.selectedTabName, this.loggedIn});

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
        if (loggedIn)
          PopupMenuButton(
            icon: Icon(
              FontAwesomeIcons.user,
            ),
            elevation: 2.2,
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem>[
                PopupMenuItem(
                  value: 0,
                  child: GestureDetector(
                    onTap: () {
                      AuthService().signOut();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0, left: 10.0),
                      child: Text(
                        'Sign out',
                        style: kAppBarMenuItemsTextStyle,
                      ),
                    ),
                  ),
                ),
              ];
            },
          ),
        if (!loggedIn)
          GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(SignInScreen.pageRoute);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 16.0),
              child: Text(
                'Sign in',
                style: kAppBarActionsTextStyle,
              ),
            ),
          ),
      ],
      backgroundColor: kNavBarBackground,
    );
  }
}
