import 'package:flutter/material.dart';

import 'package:booklogr/utils/colours.dart';
import 'package:booklogr/services/auth_service.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThirdPartyAuthButtons extends StatelessWidget {
  final AuthService _authService = AuthService();
  final GlobalKey scaffoldKey;

  ThirdPartyAuthButtons({this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          child: RaisedButton.icon(
            icon: Icon(
              FontAwesomeIcons.google,
              size: 16.0,
              color: kBlack,
            ),
            label: Text(
              'Sign in with Google',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: kBlack,
                fontSize: 20.0,
              ),
            ),
            padding: EdgeInsets.only(
              top: 15.0,
              bottom: 15.0,
            ),
            color: Colors.white,
            onPressed: () async {
              FirebaseUser user = await _authService.googleSignIn();
              if (user != null) {
                Navigator.of(scaffoldKey.currentContext).pop();
                _authService.showWelcomeDialog(
                  scaffoldKey: scaffoldKey,
                  firstWelcome: true,
                );
              }
            },
            elevation: 0.8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(
                color: kBlack,
              ),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        FutureBuilder(
          future: _authService.appleSignInAvailable,
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return AppleSignInButton(
                style: ButtonStyle.black,
                onPressed: () async {
                  FirebaseUser user = await _authService.appleSignIn();
                  if (user != null) {
                    Navigator.of(context).pop();
                    _authService.showWelcomeDialog(
                      scaffoldKey: scaffoldKey,
                      firstWelcome: true,
                    );
                  }
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
