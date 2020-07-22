import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

class AuthService {
  String errorMsg;
  String blankErrorMsg = 'Please enter both your email and password';
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final Firestore _db = Firestore.instance;

  Future<FirebaseUser> get getUser => _auth.currentUser();

  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<void> emailSignUp(
      {String email,
      String password,
      String confirmPassword,
      Function successCallback,
      Function errorCallback}) async {
    if (email.length == 0 || password.length == 0) {
      errorCallback(blankErrorMsg);
    } else if (password != confirmPassword) {
      errorCallback('Make sure your password and confirmation match');
    } else {
      try {
        final result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (result != null) {
          successCallback();
        }
      } catch (e) {
        _getFirebaseValidationError(e);
        errorCallback(errorMsg);
      }
    }
  }

  Future<FirebaseUser> emailSignIn(
      {String email,
      String password,
      Function successCallback,
      Function errorCallback}) async {
    if (email.length == 0 || password.length == 0) {
      errorCallback(blankErrorMsg);
      return null;
    } else {
      try {
        AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (result != null) {
          successCallback();
        }

        FirebaseUser user = result.user;
        return user;
      } catch (e) {
        _getFirebaseValidationError(e);
        errorCallback(errorMsg);
        return null;
      }
    }
  }

  Future<void> signOut() async {
    final FirebaseUser user = await getUser;
    if (user.providerData[0].providerId == 'google.com') {
      await _googleSignIn.signOut();
    }
    FirebaseAuth.instance.signOut();
  }

  Future<FirebaseUser> googleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  void _getFirebaseValidationError(e) {
    // print(e.toString());
    if (e.code == 'ERROR_WRONG_PASSWORD') {
      errorMsg = 'You entered the wrong password';
    } else if (e.code == 'ERROR_INVALID_EMAIL') {
      errorMsg = 'You entered a badly formed email address';
    } else if (e.code == 'ERROR_USER_NOT_FOUND') {
      errorMsg = 'You do not have an account, try registering first';
    } else {
      errorMsg = e.message;
    }
  }

  // Determine if Apple SignIn is available
  Future<bool> get appleSignInAvailable => AppleSignIn.isAvailable();

  /// Sign in with Apple
  Future<FirebaseUser> appleSignIn() async {
    try {
      final AuthorizationResult appleResult =
          await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (appleResult.error != null) {
        // handle errors from Apple here
      }

      final AuthCredential credential =
          OAuthProvider(providerId: 'apple.com').getCredential(
        accessToken:
            String.fromCharCodes(appleResult.credential.authorizationCode),
        idToken: String.fromCharCodes(appleResult.credential.identityToken),
      );

      AuthResult firebaseResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = firebaseResult.user;

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  void closeWelcomeDialog(context) {}

  void showWelcomeDialog({GlobalKey scaffoldKey, bool firstWelcome}) {
    String alertTitle = 'Success';
    Text alertContent = Text("Thanks for signing in.");
    showDialog(
      context: scaffoldKey.currentContext,
      builder: (_) {
        return AlertDialog(
          title: Text(alertTitle),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(_).pop('dialog');
              },
            ),
          ],
          content: alertContent,
        );
      },
    );
  }
}
