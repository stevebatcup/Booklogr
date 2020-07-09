import 'package:booklogr/components/components.dart';
import 'package:booklogr/screens/search_results_screen.dart';
import 'package:booklogr/services/book_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:booklogr/utils/text_styles.dart';
import 'package:booklogr/utils/colours.dart';
import 'package:booklogr/components/action_button.dart';
// import 'package:booklogr/screens/search_results_screen.dart';
// import 'package:booklogr/services/auth_service.dart';
import 'package:booklogr/services/tab_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SearchFormScreen extends StatefulWidget {
  @override
  _SearchFormScreenState createState() => _SearchFormScreenState();
}

class _SearchFormScreenState extends State<SearchFormScreen> {
  final searchController = TextEditingController();
  final String _welcomePrefsKey = 'seen_welcome';
  BookService searchService;
  TabService tabService;
  FirebaseUser user;
  bool hasSeenWelcome = true;
  String query = '';

  @override
  void initState() {
    getHasSeenWelcome();
    super.initState();
  }

  Future<void> getHasSeenWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    hasSeenWelcome = prefs.getBool(_welcomePrefsKey) ?? false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    searchService = Provider.of<BookService>(context);
    tabService = Provider.of<TabService>(context);
    user = Provider.of<FirebaseUser>(context);
  }

  @override
  Widget build(BuildContext context) {
    bool loggedIn = user != null;
    if (query.isNotEmpty) {
      searchController.text = query;
    }

    tabService.selectedTabName = "Search";

    return Scaffold(
      appBar: MainAppBar(
        loggedIn: loggedIn,
        selectedTabName: tabService.selectedTabName,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20.0),
          Flexible(
            child: Image.asset(
              'assets/images/search.png',
              width: 300.0,
            ),
          ),
          SizedBox(height: 30.0),
          Visibility(
            visible: !hasSeenWelcome,
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        'Welcome to Booklogr',
                        style: kTitleTextStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        'Begin by searching for the books that you have already read, are currently reading or want to read.',
                        style: kParaTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.0,
                    bottom: 5.0,
                  ),
                  child: TextField(
                    style: kTextInputStyle,
                    controller: searchController,
                    onChanged: (value) {
                      query = value;
                    },
                    decoration: kSearchTextFieldDecoration,
                  ),
                ),
                ActionButton(
                  'Search',
                  colour: kPrimaryColour,
                  action: () {
                    if (query != null && query.length > 0) {
                      searchService.initSearch(query);
                      SearchResultsScreen searchResultsScreen =
                          SearchResultsScreen();
                      Route route = CupertinoPageRoute(
                        builder: (context) => searchResultsScreen,
                        settings: RouteSettings(
                          name: searchResultsScreen.toStringShort(),
                        ),
                      );
                      Navigator.push(context, route);
                      tabService.selectedTabName = 'Search results';
                    }
                  },
                ),
                SizedBox(height: 25.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    setHasSeenWelcome();
    super.dispose();
  }

  Future<void> setHasSeenWelcome() async {
    if (!hasSeenWelcome) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(_welcomePrefsKey, true);
    }
  }
}
