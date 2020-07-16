import 'package:booklogr/services/auth_service.dart';
import 'package:booklogr/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        FontAwesomeIcons.user,
      ),
      onSelected: (selection) {
        print(selection);
        AuthService().signOut();
      },
      elevation: 2.2,
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem>[
          PopupMenuItem(
            value: 0,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0, left: 10.0),
              child: Text(
                'Sign out',
                style: kAppBarMenuItemsTextStyle,
              ),
            ),
          ),
        ];
      },
    );
  }
}
