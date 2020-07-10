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

class HaveReadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TabService tabService = Provider.of<TabService>(context);
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    BooksCollection<HaveReadBook> collection =
        BooksCollection<HaveReadBook>(userId: user.uid);

    if (loggedIn) {
      return Scaffold(
        appBar: MainAppBar(
          loggedIn: loggedIn,
          selectedTabName: 'Already read',
        ),
        body: Consumer<List<HaveReadBook>>(
          builder: (context, bookList, child) {
            if (bookList == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (bookList.length == 0) {
              return EmptyListAction(
                icon: Icon(
                  FontAwesomeIcons.book,
                  size: 35.0,
                  color: kGrey,
                ),
                label: "Run a search to add books your ALREADY READ list",
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
                        .showBook(book: book, context: context);
                  },
                );
              },
              itemCount: bookList.length,
            );
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: MainAppBar(
          loggedIn: loggedIn,
          selectedTabName: 'Already read',
        ),
        body: EmptyListAction(
          icon: Icon(
            FontAwesomeIcons.book,
            size: 35.0,
            color: kGrey,
          ),
          label: "Sign up to Booklogr to add books to your ALREADY READ list",
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(SignUpScreen.pageRoute);
          },
        ),
      );
    }
  }
}
