import 'package:booklogr/components/centred_view.dart';
import 'package:booklogr/components/navigation/app_bar_desktop_tablet.dart';
import 'package:booklogr/components/navigation/nav_bar.dart';
import 'package:booklogr/utils/web_modal.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:booklogr/components/components.dart';
import 'package:booklogr/services/book_service.dart';
import 'package:booklogr/services/tab_service.dart';
import 'package:booklogr/services/db_service.dart';
import 'package:booklogr/utils/colours.dart';
import 'package:booklogr/screens/sign_up_screen.dart';
import 'package:booklogr/models/book.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ReadingScreen extends StatelessWidget {
  static String pageRoute = '/reading';

  @override
  Widget build(BuildContext context) {
    TabService tabService = Provider.of<TabService>(context);
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    var deviceType = getDeviceType(MediaQuery.of(context).size);
    bool isMobile = (deviceType == DeviceScreenType.mobile);
    Widget appBar = isMobile
        ? AppBarMobile(
            loggedIn: loggedIn,
            selectedTabName: 'Currently reading',
          )
        : AppBarDesktopTablet(
            activeSection: NavBarSection.reading,
          );

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (loggedIn) {
          BooksCollection<ReadingBook> collection =
              BooksCollection<ReadingBook>()..initUserCollection(user);
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: appBar,
            body: CentredView(
              child: Consumer<List<ReadingBook>>(
                builder: (context, bookList, child) {
                  if (bookList == null) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kPrimaryColour),
                      ),
                    );
                  }

                  if (bookList.length == 0) {
                    return EmptyListAction(
                      icon: Icon(
                        FontAwesomeIcons.book,
                        size: 35.0,
                        color: kGrey,
                      ),
                      label:
                          "Run a search to add books your CURRENTLY READING list",
                      onTap: () {
                        tabService.showSearchTab();
                      },
                    );
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      Book book = bookList[index];
                      return BookListItem(
                        book: book,
                        collection: collection,
                        onPressed: () {
                          Provider.of<BookService>(context, listen: false)
                              .showBook(
                                  book: book,
                                  context: context,
                                  isMobile: sizingInformation.isMobile);
                        },
                      );
                    },
                    itemCount: bookList.length,
                  );
                },
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: appBar,
            body: CentredView(
              child: EmptyListAction(
                icon: Icon(
                  FontAwesomeIcons.book,
                  size: 35.0,
                  color: kGrey,
                ),
                label:
                    "Sign up to Booklogr to add books to your CURRENTLY READING list",
                onTap: () {
                  isMobile
                      ? Navigator.of(context, rootNavigator: true)
                          .pushNamed(SignUpScreen.pageRoute)
                      : Navigator.of(context).push(
                          WebModal(
                            opaque: false,
                            page: SignUpScreen(),
                          ),
                        );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
