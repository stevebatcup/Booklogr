import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:booklogr/screens/sign_up_screen.dart';
import 'package:booklogr/screens/sign_in_screen.dart';
import 'package:booklogr/screens/tab_layout.dart';
import 'package:booklogr/services/tab_service.dart';
import 'package:booklogr/services/book_service.dart';
import 'package:booklogr/services/db_service.dart';
import 'package:booklogr/models/book.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

const String appTitle = "Booklogr";

void main() {
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(DevicePreview(
    enabled: false,
    builder: (context) => App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: FirebaseAuth.instance.onAuthStateChanged,
      child: BookLogr(),
    );
  }
}

class BookLogr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, Widget Function(BuildContext)> pageRoutes = {
      SignUpScreen.pageRoute: (context) => SignUpScreen(),
      SignInScreen.pageRoute: (context) => SignInScreen(),
      TabLayout.pageRoute: (context) => TabLayout(),
    };

    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    print(loggedIn);

    return MultiProvider(
      providers: [
        if (loggedIn)
          StreamProvider<List<HaveReadBook>>.value(
            value: BooksCollection<HaveReadBook>(userId: user.uid).streamData(),
          ),
        if (loggedIn)
          StreamProvider<List<ReadingBook>>.value(
            value: BooksCollection<ReadingBook>(userId: user.uid).streamData(),
          ),
        if (loggedIn)
          StreamProvider<List<WillReadBook>>.value(
            value: BooksCollection<WillReadBook>(userId: user.uid).streamData(),
          ),
        ChangeNotifierProvider(
          create: (_) => TabService(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookService(),
        )
      ],
      child: MaterialApp(
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        ],
        title: 'Booklogr',
        locale: DevicePreview.of(context).locale,
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          fontFamily: 'SFPro',
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: TabLayout.pageRoute,
        routes: pageRoutes,
      ),
    );
  }
}
