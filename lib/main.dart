import 'package:booklogr/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:booklogr/screens/screens.dart';

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
ColorScheme colorScheme = ColorScheme(
  primary: kPrimaryColour,
  primaryVariant: kPrimaryVariantColour,
  secondary: kSecondaryColour,
  secondaryVariant: kSecondaryVariantColour,
  surface: kSurfaceColor,
  background: Colors.white,
  error: kErrorColor,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: kBlack,
  onBackground: kBlack,
  onError: Colors.white,
  brightness: Brightness.light,
);

void main() {
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(DevicePreview(
    enabled: false,
    builder: (context) => BookLogr(),
  ));
}

class BookLogr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, Widget Function(BuildContext)> pageRoutes = {
      SignUpScreen.pageRoute: (context) => SignUpScreen(),
      SignInScreen.pageRoute: (context) => SignInScreen(),
      HomeScreen.pageRoute: (context) => HomeScreen(),
      SearchResultsScreen.pageRoute: (context) => SearchResultsScreen(),
      HaveReadScreen.pageRoute: (context) => HaveReadScreen(),
      ReadingScreen.pageRoute: (context) => ReadingScreen(),
      WillReadScreen.pageRoute: (context) => WillReadScreen(),
    };

    return MultiProvider(
      providers: [
        StreamProvider.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
        StreamProvider<List<HaveReadBook>>.value(
          value: BooksCollection<HaveReadBook>().streamData(),
        ),
        StreamProvider<List<ReadingBook>>.value(
          value: BooksCollection<ReadingBook>().streamData(),
        ),
        StreamProvider<List<WillReadBook>>.value(
          value: BooksCollection<WillReadBook>().streamData(),
        ),
        ChangeNotifierProvider(
          create: (_) => TabService(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookService(),
        )
      ],
      child: MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        ],
        title: 'Booklogr',
        locale: DevicePreview.of(context).locale,
        builder: DevicePreview.appBuilder,
        theme: ThemeData(
          fontFamily: 'SFPro',
          colorScheme: colorScheme,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: HomeScreen.pageRoute,
        routes: pageRoutes,
      ),
    );
  }
}
