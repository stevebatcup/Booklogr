import 'package:booklogr/screens/sign_in_screen.dart';
import 'package:booklogr/utils/text_styles.dart';
import 'package:booklogr/utils/web_modal.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NavBarSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceType = getDeviceType(MediaQuery.of(context).size);
    bool isMobile = (deviceType == DeviceScreenType.mobile);
    return GestureDetector(
      onTap: () {
        isMobile
            ? Navigator.of(context, rootNavigator: true)
                .pushNamed(SignInScreen.pageRoute)
            : Navigator.of(context).push(
                WebModal(
                  opaque: false,
                  page: SignInScreen(),
                ),
              );
      },
      child: Padding(
        padding: isMobile
            ? EdgeInsets.only(right: 25.0, top: 18.0)
            : EdgeInsets.only(top: 22.0, right: 20.0),
        child: Text(
          'Sign in',
          style: kAppBarActionsTextStyle.copyWith(
            color: isMobile ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}
