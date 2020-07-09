import 'package:flutter/material.dart';
import 'package:booklogr/models/book.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:booklogr/services/db_service.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({
    Key key,
    @required this.book,
    this.onPressed,
    this.collection,
  }) : super(key: key);

  final Book book;
  final Function onPressed;
  final BooksCollection collection;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 17.0,
      ),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: UniqueKey(),
        onDismissed: (direction) async {
          await collection.deleteBook(book);
        },
        background: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            padding: EdgeInsets.only(right: 20.0),
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Remove from list',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SFPro',
                    fontWeight: FontWeight.w700,
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(width: 16.0),
                Icon(
                  FontAwesomeIcons.trashAlt,
                  color: Colors.white,
                  size: 26.0,
                ),
              ],
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (book.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: RaisedButton(
                  onPressed: onPressed,
                  elevation: 2.0,
                  padding: EdgeInsets.zero,
                  child: Hero(
                    tag: '${book.id}_image',
                    child: Image.network(
                      book.image,
                      width: 90.0,
                      height: 125,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            Flexible(
              child: RaisedButton(
                elevation: 2.0,
                onPressed: onPressed,
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 28.0,
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(
                        fontSize: 16.0,
                        height: 1.3,
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        book.author,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontFamily: 'SFPro',
                          fontWeight: FontWeight.w500,
                          color: Color(0xff5d5d5d),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
