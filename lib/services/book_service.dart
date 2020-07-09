import 'package:flutter/material.dart';
import 'package:booklogr/models/book.dart';
import 'package:booklogr/screens/book_detail_screen.dart';

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

  void showBook({BuildContext context, Book book}) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return BookDetailScreen(book);
      },
    ));
  }
}
