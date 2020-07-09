import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:booklogr/screens/search_form_screen.dart';
import 'package:booklogr/screens/have_read_screen.dart';
import 'package:booklogr/screens/reading_screen.dart';
import 'package:booklogr/screens/will_read_screen.dart';

class TabService extends ChangeNotifier {
  String selectedTabName = "Search";
  int previousIndex = 0;
  final SearchFormScreen _searchForm = SearchFormScreen();
  final HaveReadScreen _haveReadScreen = HaveReadScreen();
  final ReadingScreen _readingScreen = ReadingScreen();
  final WillReadScreen _willReadScreen = WillReadScreen();
  final CupertinoTabController tabController = CupertinoTabController();

  Map<String, Icon> _tabItems = {
    'Search': Icon(FontAwesomeIcons.search),
    'Have read': Icon(FontAwesomeIcons.book),
    'Reading': Icon(FontAwesomeIcons.bookReader),
    'Will read': Icon(FontAwesomeIcons.bookMedical),
  };

  void showSearchTab() {
    tabController.index = 0;
    notifyListeners();
  }

  Widget getSelectedPageWidget() {
    Widget screen;
    switch (tabController.index) {
      case 0:
        screen = _searchForm;
        break;
      case 1:
        screen = _haveReadScreen;
        break;
      case 2:
        screen = _readingScreen;
        break;
      case 3:
        screen = _willReadScreen;
        break;
    }
    return screen;
  }

  List<BottomNavigationBarItem> tabs() {
    List<BottomNavigationBarItem> tabs = [];
    _tabItems.forEach((label, icon) {
      tabs.add(
        BottomNavigationBarItem(
          icon: icon,
        ),
      );
    });
    return tabs;
  }

  void updateAppbar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
  }
}
