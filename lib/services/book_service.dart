import 'package:booklogr/screens/book_detail_screen_desktop_tablet.dart';
import 'package:booklogr/utils/web_modal.dart';
import 'package:flutter/material.dart';
import 'package:booklogr/models/book.dart';
import 'package:booklogr/screens/book_detail_screen_mobile.dart';

class BookService extends ChangeNotifier {
  String _query = '';
  bool firstSearchHasRun = false;
  List<Book> bookResults = <Book>[];

  void initSearch(String newQuery) {
    bookResults.clear();
    firstSearchHasRun = false;
    setQuery(newQuery);
  }

  void setQuery(String newQuery) {
    _query = newQuery;
    notifyListeners();
  }

  String get query {
    return _query;
  }

  bool hasResults() {
    return bookResults.isNotEmpty;
  }

  void showBook({BuildContext context, Book book, bool isMobile}) {
    isMobile
        ? Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return BookDetailScreenMobile(book);
            },
          ))
        : Navigator.of(context).push(
            WebModal(
              opaque: false,
              page: BookDetailScreenDesktopTablet(book),
            ),
          );
  }
}
