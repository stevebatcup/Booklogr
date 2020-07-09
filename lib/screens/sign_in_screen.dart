import 'package:booklogr/components/third_party_auth_buttons.dart';
import 'package:flutter/material.dart';

import 'package:booklogr/utils/text_styles.dart';
import 'package:booklogr/utils/colours.dart';
import 'package:booklogr/components/action_button.dart';
import 'package:booklogr/components/auth_form_field.dart';
import 'package:booklogr/components/interstitial_title_bar.dart';
import 'package:booklogr/screens/sign_up_screen.dart';
import 'package:booklogr/services/auth_service.dart';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignInScreen extends StatefulWidget {
  static const pageRoute = '/sign-in';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();
  bool keyboardIsOpen = false;
  bool showSpinner = false;
  String email = '';
  String password = '';
  String errorMsg = '';

  @override
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          keyboardIsOpen = visible;
        });
      },
    );
  }

  void onFormError(msg) {
    setState(() {
      errorMsg = msg;
      showSpinner = false;
    });
  }

  void onFormSuccess() {
    _authService.showWelcomeDialog(
      context: context,
      firstWelcome: false,
    );
    // Navigator.of(context).pop();
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          color: kPrimaryColour,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColour),
          ),
          inAsyncCall: showSpinner,
          child: Column(
            children: <Widget>[
              InterstitialTitleBar(
                title: 'Sign In',
                bottomPadding: 30.0,
              ),
              Flexible(
                child: Image.asset(
                  'assets/images/sign_in.png',
                  width: 260.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Visibility(
                      visible: !keyboardIsOpen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: ThirdPartyAuthButtons(),
                          ),
                          Text(
                            'OR',
                            style: kTitleTextStyle,
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        AuthFormField(
                          hintLabel: 'email',
                          onChanged: (value) {
                            email = value;
                          },
                          inputType: TextInputType.emailAddress,
                          obscureText: false,
                        ),
                        AuthFormField(
                          hintLabel: 'password',
                          onChanged: (value) {
                            password = value;
                          },
                          inputType: TextInputType.visiblePassword,
                          obscureText: true,
                        ),
                        Visibility(
                          visible: errorMsg.length > 0,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Text(
                                errorMsg,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ActionButton(
                          'Sign in',
                          colour: kPrimaryColour,
                          action: () {
                            setState(() {
                              showSpinner = true;
                            });
                            _authService.emailSignIn(
                              email: email,
                              password: password,
                              successCallback: onFormSuccess,
                              errorCallback: onFormError,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(SignUpScreen.pageRoute);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    children: [
                      Text(
                        'Not yet registered? ',
                        style: kParaTextStyle,
                      ),
                      Text(
                        'Sign Up',
                        style: kLinkTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }
}
