import 'package:booklogr/components/centred_view.dart';
import 'package:booklogr/components/navigation/app_bar_desktop_tablet.dart';
import 'package:booklogr/components/navigation/nav_bar.dart';
import 'package:booklogr/services/book_service.dart';
import 'package:flutter/material.dart';

import 'package:booklogr/utils/utils.dart';
import 'package:booklogr/services/books_api_service.dart';
import 'package:booklogr/services/tab_service.dart';
import 'package:booklogr/models/book.dart';
import 'package:booklogr/components/components.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SearchResultsScreen extends StatefulWidget {
  static String pageRoute = '/search-results';
  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final BooksApiService apiService = BooksApiService();
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  bool showSpinner;
  TabService tabService;
  BookService searchService;
  FirebaseUser user;

  void setupScrollistener() {
    _scrollController.addListener(() {
      var triggerFetchMoreSize =
          0.9 * _scrollController.position.maxScrollExtent;
      if (_scrollController.position.pixels > triggerFetchMoreSize) {
        page++;
        runSearch();
      }
    });
  }

  void runSearch() async {
    List<Book> results =
        await apiService.runSearch(query: searchService.query, page: page);
    setState(() {
      if (results != null) {
        results.forEach((book) => searchService.bookResults.add(book));
      }
      showSpinner = false;
      searchService.firstSearchHasRun = true;
    });
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

    if (!searchService.firstSearchHasRun) {
      showSpinner = true;
      runSearch();
      setupScrollistener();
    } else {
      showSpinner = false;
    }

    tabService.selectedTabName = "Search results";

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
            child: ModalProgressHUD(
              color: Theme.of(context).colorScheme.background,
              progressIndicator: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColour),
              ),
              inAsyncCall: showSpinner,
              child: (searchService.bookResults.length == 0) &&
                      (showSpinner == false)
                  ? EmptyListAction(
                      label:
                          "Sorry we can't find any books matching your search term, try again",
                      icon: Icon(
                        FontAwesomeIcons.sadCry,
                        size: 35.0,
                        color: kGrey,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  : Container(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: searchService.bookResults.length,
                        itemBuilder: (context, index) {
                          Book book = searchService.bookResults[index];
                          return BookListItem(
                            book: book,
                            onPressed: () {
                              Provider.of<BookService>(context, listen: false)
                                  .showBook(
                                      book: book,
                                      context: context,
                                      isMobile: sizingInformation.isMobile);
                            },
                          );
                        },
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
