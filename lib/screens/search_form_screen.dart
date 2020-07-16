import 'package:booklogr/components/centred_view.dart';
import 'package:booklogr/components/components.dart';
import 'package:booklogr/components/navigation/app_bar_desktop_tablet.dart';
import 'package:booklogr/components/navigation/nav_bar.dart';
import 'package:booklogr/screens/search_results_screen.dart';
import 'package:booklogr/services/book_service.dart';
import 'package:booklogr/utils/web_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:booklogr/utils/text_styles.dart';
import 'package:booklogr/utils/colours.dart';
import 'package:booklogr/components/action_button.dart';
import 'package:booklogr/services/tab_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SearchFormScreen extends StatefulWidget {
  static String pageRoute = '/search';

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

  void submitSearch(bool isMobile) {
    if (query != null && query.length > 0) {
      searchService.initSearch(query);
      SearchResultsScreen searchResultsScreen = SearchResultsScreen();
      if (isMobile) {
        Route route = CupertinoPageRoute(
          builder: (context) => searchResultsScreen,
          settings: RouteSettings(
            name: searchResultsScreen.toStringShort(),
          ),
        );
        Navigator.push(context, route);
        tabService.selectedTabName = 'Search results';
      } else {
        Navigator.of(context).push(
          WebPageRoute(
            builder: (context) => searchResultsScreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool loggedIn = user != null;
    if (query.isNotEmpty) {
      searchController.text = query;
    }
    tabService.selectedTabName = "Search";

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: sizingInformation.isMobile
              ? AppBarMobile(
                  loggedIn: loggedIn,
                  selectedTabName: tabService.selectedTabName,
                )
              : AppBarDesktopTablet(
                  activeSection: NavBarSection.search,
                ),
          body: CentredView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0),
                    Flexible(
                      child: Image.asset(
                        'assets/images/search.png',
                        width: sizingInformation.isMobile ? 320.0 : 500,
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
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.8),
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 30.0),
                                  child: Text(
                                    'Begin by searching for the books that you have already read, are currently reading or want to read.',
                                    style: kParaTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: sizingInformation.isMobile ? 320.0 : 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10.0,
                              bottom: 5.0,
                            ),
                            child: TextFormField(
                              textInputAction: TextInputAction.search,
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
                              submitSearch(sizingInformation.isMobile);
                            },
                          ),
                          SizedBox(height: 25.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    setHasSeenWelcome();
    super.dispose();
  }

  Future<void> setHasSeenWelcome() async {
    if (hasSeenWelcome == false) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(_welcomePrefsKey, true);
    }
  }
}
