import 'dart:async';

import 'package:booklogr/utils/web_modal.dart';
import 'package:flutter/material.dart';

import 'package:booklogr/utils/text_styles.dart';
import 'package:booklogr/utils/colours.dart';
import 'package:booklogr/components/action_button.dart';
import 'package:booklogr/components/auth_form_field.dart';
import 'package:booklogr/components/interstitial_title_bar.dart';
import 'package:booklogr/components/third_party_auth_buttons.dart';
import 'package:booklogr/screens/sign_in_screen.dart';
import 'package:booklogr/services/auth_service.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUpScreen extends StatefulWidget {
  static const pageRoute = '/sign-up';
  final Function onAuthSuccess;

  SignUpScreen({this.onAuthSuccess});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  bool keyboardIsOpen = false;
  bool showForm = false;
  bool showSpinner = false;
  String email = '';
  String password = '';
  String confirmPassword = '';
  String errorMsg = '';
  StreamSubscription<bool> keyboardSub;

  @override
  void initState() {
    super.initState();

    keyboardSub = KeyboardVisibility.onChange.listen(
      (bool visible) {
        if (!showSpinner) {
          setState(() {
            keyboardIsOpen = visible;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    keyboardSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceType = getDeviceType(MediaQuery.of(context).size);
    bool isMobile = (deviceType == DeviceScreenType.mobile);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: ModalProgressHUD(
          color: kPrimaryColour,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColour),
          ),
          inAsyncCall: showSpinner,
          child: Column(
            children: <Widget>[
              InterstitialTitleBar(
                title: 'Sign Up',
                bottomPadding: 5.0,
              ),
              Flexible(
                child: Image.asset(
                  'assets/images/sign_up.png',
                  width: 260.0,
                ),
              ),
              Visibility(
                maintainSize: false,
                visible: !keyboardIsOpen,
                child: SizedBox(height: 15.0),
              ),
              Visibility(
                maintainSize: false,
                visible: !showForm,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: Text(
                        'Sign up to Booklogr to start adding books to your lists.',
                        style: kParaTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ActionButton(
                            'Sign up with Email',
                            colour: kPrimaryColour,
                            action: () {
                              setState(() {
                                showForm = true;
                              });
                            },
                          ),
                          Text(
                            'OR',
                            style: kTitleTextStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: ThirdPartyAuthButtons(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showForm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
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
                      AuthFormField(
                        hintLabel: 'confirm password',
                        onChanged: (value) {
                          confirmPassword = value;
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
                      Visibility(
                        maintainSize: false,
                        visible: !keyboardIsOpen,
                        child: SizedBox(height: 30.0),
                      ),
                      ActionButton(
                        'Sign up',
                        colour: kPrimaryColour,
                        action: () {
                          setState(() {
                            showSpinner = true;
                          });
                          _authService.emailSignUp(
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword,
                            successCallback: () {
                              print("foo");
                              Navigator.of(context).pop();
                              _authService.showWelcomeDialog(
                                context: context,
                                firstWelcome: true,
                              );
                            },
                            errorCallback: (msg) {
                              setState(() {
                                errorMsg = msg;
                                showSpinner = false;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                  maintainSize: false,
                  visible: !keyboardIsOpen,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: GestureDetector(
                          onTap: () {
                            isMobile
                                ? Navigator.of(context, rootNavigator: true)
                                    .pushReplacementNamed(
                                        SignInScreen.pageRoute)
                                : Navigator.of(context).pushReplacement(
                                    WebModal(
                                      opaque: false,
                                      page: SignInScreen(),
                                    ),
                                  );
                          },
                          child: Row(
                            children: [
                              Text(
                                'Already a member? ',
                                style: kParaTextStyle,
                              ),
                              Text(
                                'Sign In',
                                style: kLinkTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
