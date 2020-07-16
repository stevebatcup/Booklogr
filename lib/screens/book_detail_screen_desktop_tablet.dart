import 'package:booklogr/components/interstitial_title_bar.dart';
import 'package:booklogr/components/read_status_button.dart';
import 'package:booklogr/components/text_title.dart';
import 'package:booklogr/models/book.dart';
import 'package:booklogr/screens/sign_in_screen.dart';
import 'package:booklogr/screens/sign_up_screen.dart';
import 'package:booklogr/services/db_service.dart';
import 'package:booklogr/utils/colours.dart';
import 'package:booklogr/utils/web_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDetailScreenDesktopTablet extends StatefulWidget {
  final Book book;

  BookDetailScreenDesktopTablet(this.book);

  @override
  _BookDetailScreenDesktopTabletState createState() =>
      _BookDetailScreenDesktopTabletState();
}

class _BookDetailScreenDesktopTabletState
    extends State<BookDetailScreenDesktopTablet> {
  bool loggedIn;
  ReadStatus readStatus = ReadStatus.none;
  Map<ReadStatus, BooksCollection> bookCollections;

  void toggleReadStatus(
      {ReadStatus newStatus,
      double xPositionChunks,
      BooksCollection collection}) async {
    if (readStatus != newStatus) {
      setState(() {
        readStatus = newStatus;
      });
      bookCollections.forEach(
          (key, collection) async => await collection.deleteBook(widget.book));
      await collection.addBook(widget.book);
    } else {
      collection.deleteBook(widget.book);
      setState(() {
        readStatus = ReadStatus.none;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    loggedIn = user != null;

    if (loggedIn) {
      bookCollections = <ReadStatus, BooksCollection>{
        ReadStatus.alreadyRead: BooksCollection<HaveReadBook>()
          ..initUserCollection(user),
        ReadStatus.currentlyReading: BooksCollection<ReadingBook>()
          ..initUserCollection(user),
        ReadStatus.willRead: BooksCollection<WillReadBook>()
          ..initUserCollection(user),
      };
    }
    setInitialReadStatus();
  }

  void setInitialReadStatus() {
    if (loggedIn) {
      bookCollections.forEach((key, collection) async {
        bool result = await collection.bookIsPresent(widget.book);
        if (result) readStatus = key;
      });
    } else {
      readStatus = ReadStatus.none;
    }
  }

  void showSignInDialog(Function onAuthSuccess) {
    String alertTitle = 'Sign In';
    List<Widget> alertButtons = <Widget>[
      FlatButton(
        child: Text('Sign Up'),
        onPressed: () {
          closeDialog();
          Navigator.of(context).push(
            WebModal(
              opaque: false,
              page: SignUpScreen(
                onAuthSuccess: onAuthSuccess,
              ),
            ),
          );
        },
      ),
      FlatButton(
        child: Text('Sign In'),
        onPressed: () {
          closeDialog();
          Navigator.of(context).push(
            WebModal(
              opaque: false,
              page: SignInScreen(),
            ),
          );
        },
      ),
      FlatButton(
        child: Text('Cancel'),
        onPressed: () {
          closeDialog();
        },
      ),
    ];
    Text alertContent =
        Text("You must be signed in to add books to your lists.");
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(alertTitle),
          actions: alertButtons,
          content: alertContent,
        );
      },
    );
  }

  void closeDialog() {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 110.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InterstitialTitleBar(
                        title: widget.book.title,
                        subTitle: widget.book.author,
                        bottomPadding: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25.0,
                          bottom: 20.0,
                        ),
                        child: Hero(
                          tag: '${widget.book.id}_image',
                          child: Image.network(
                            widget.book.image,
                            width: 130.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ReadStatusButton(
                                width: 140,
                                label: 'I\'ve read this',
                                currentReadStatus: readStatus,
                                buttonReadStatus: ReadStatus.alreadyRead,
                                onTap: () {
                                  if (loggedIn) {
                                    toggleReadStatus(
                                        newStatus: ReadStatus.alreadyRead,
                                        xPositionChunks: -1,
                                        collection: bookCollections[
                                            ReadStatus.alreadyRead]);
                                  } else {
                                    showSignInDialog(() {});
                                  }
                                },
                              ),
                              ReadStatusButton(
                                width: 140,
                                label: 'I\'m currently reading this',
                                currentReadStatus: readStatus,
                                buttonReadStatus: ReadStatus.currentlyReading,
                                onTap: () {
                                  if (loggedIn) {
                                    toggleReadStatus(
                                      newStatus: ReadStatus.currentlyReading,
                                      xPositionChunks: 1,
                                      collection: bookCollections[
                                          ReadStatus.currentlyReading],
                                    );
                                  } else {
                                    showSignInDialog(() {});
                                  }
                                },
                              ),
                              ReadStatusButton(
                                width: 140,
                                label: 'I want to read this',
                                currentReadStatus: readStatus,
                                buttonReadStatus: ReadStatus.willRead,
                                onTap: () {
                                  if (loggedIn) {
                                    toggleReadStatus(
                                      newStatus: ReadStatus.willRead,
                                      xPositionChunks: 3,
                                      collection:
                                          bookCollections[ReadStatus.willRead],
                                    );
                                  } else {
                                    showSignInDialog(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: TextTitle('Description'),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          widget.book.textDescription,
                          style: TextStyle(
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Visibility(
                          visible: widget.book.publisher != null,
                          child: Text(
                            'Published by ${widget.book.publisher}',
                            style: TextStyle(
                              fontFamily: 'SFPro',
                              fontStyle: FontStyle.italic,
                              color: kLightText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
