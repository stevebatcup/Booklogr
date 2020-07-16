import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import 'package:booklogr/services/books_api_service.dart';
import 'package:booklogr/services/db_service.dart';
import 'package:booklogr/models/book.dart';
import 'package:booklogr/utils/utils.dart';
import 'package:booklogr/components/components.dart';
import 'package:booklogr/screens/sign_up_screen.dart';
import 'package:booklogr/screens/sign_in_screen.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookDetailScreenMobile extends StatefulWidget {
  final Book book;

  BookDetailScreenMobile(this.book);

  @override
  _BookDetailScreenMobileState createState() => _BookDetailScreenMobileState();
}

class _BookDetailScreenMobileState extends State<BookDetailScreenMobile>
    with TickerProviderStateMixin {
  bool showSpinner = true;
  bool loggedIn;
  ReadStatus readStatus = ReadStatus.none;
  AnimationController _animController;
  Animation _sizeAnimation;
  Animation _yPositionAnimation;
  Animation _xPositionAnimation;
  Tween _xTween;
  double _xMoveChunk;
  double screenHeight;
  double screenWidth;
  double midWidthPoint;
  double imageInitialWidth = 130.0;
  Map<ReadStatus, BooksCollection> bookCollections;

  @override
  void initState() {
    super.initState();
    getBookDescription();
  }

  void getBookDescription() async {
    await BooksApiService().getBookFullDescription(widget.book);
    setState(() {
      showSpinner = false;
    });
  }

  void setupBookAnimations() {
    _animController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1150,
      ),
    );

    screenHeight = MediaQuery.of(context).size.height;
    _yPositionAnimation =
        Tween(begin: 24.0, end: screenHeight - 50).animate(_animController)
          ..addListener(() {
            setState(() {});
          });

    screenWidth = MediaQuery.of(context).size.width;
    midWidthPoint = (screenWidth / 2) - (imageInitialWidth / 2);
    _xTween = Tween(begin: midWidthPoint, end: 100);
    _xMoveChunk = screenWidth / 8;
    _xPositionAnimation = _xTween.animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });

    _sizeAnimation = Tween(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  Future<void> animateBookAndUpdateState(double xPositionChunks) async {
    try {
      _xTween.end = midWidthPoint + (xPositionChunks * _xMoveChunk);
      await _animController.forward();
      setState(() {
        _animController.reset();
      });
    } on TickerCanceled {}
  }

  void toggleReadStatus(
      {ReadStatus newStatus,
      double xPositionChunks,
      BooksCollection collection}) async {
    if (readStatus != newStatus) {
      setState(() {
        readStatus = newStatus;
      });
      animateBookAndUpdateState(xPositionChunks);
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
    setupBookAnimations();

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

  void showSignInDialog() {
    String alertTitle = 'Sign In';
    List<Widget> alertButtons = <Widget>[
      FlatButton(
        child: Text('Sign Up'),
        onPressed: () {
          closeDialog();
          Navigator.of(context, rootNavigator: true)
              .pushNamed(SignUpScreen.pageRoute);
        },
      ),
      FlatButton(
        child: Text('Sign In'),
        onPressed: () {
          closeDialog();
          Navigator.of(context, rootNavigator: true)
              .pushNamed(SignInScreen.pageRoute);
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
    if (Platform.isAndroid) {
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
    } else if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text(alertTitle),
            actions: alertButtons,
            content: alertContent,
          );
        },
      );
    }
  }

  void closeDialog() {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: kNavBarBackground,
        title: Text(
          widget.book.title,
          style: kAppBarTextStyle,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 110.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Stack(
                children: [
                  Positioned(
                    left: _xPositionAnimation.value,
                    top: _yPositionAnimation.value,
                    child: Transform.scale(
                      scale: _sizeAnimation.value,
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.5)
                            .animate(_animController),
                        child: Image.network(
                          widget.book.image,
                          width: imageInitialWidth,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
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
                            Text(
                              widget.book.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 6.0),
                            Text(
                              widget.book.author,
                              style: TextStyle(
                                fontFamily: 'SFPro',
                                color: kLightText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 40.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ReadStatusButton(
                                    width:
                                        MediaQuery.of(context).size.width / 3.4,
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
                                        showSignInDialog();
                                      }
                                    },
                                  ),
                                  ReadStatusButton(
                                    width:
                                        MediaQuery.of(context).size.width / 3.4,
                                    label: 'I\'m currently reading this',
                                    currentReadStatus: readStatus,
                                    buttonReadStatus:
                                        ReadStatus.currentlyReading,
                                    onTap: () {
                                      if (loggedIn) {
                                        toggleReadStatus(
                                          newStatus:
                                              ReadStatus.currentlyReading,
                                          xPositionChunks: 1,
                                          collection: bookCollections[
                                              ReadStatus.currentlyReading],
                                        );
                                      } else {
                                        showSignInDialog();
                                      }
                                    },
                                  ),
                                  ReadStatusButton(
                                    width:
                                        MediaQuery.of(context).size.width / 3.4,
                                    label: 'I want to read this',
                                    currentReadStatus: readStatus,
                                    buttonReadStatus: ReadStatus.willRead,
                                    onTap: () {
                                      if (loggedIn) {
                                        toggleReadStatus(
                                          newStatus: ReadStatus.willRead,
                                          xPositionChunks: 3,
                                          collection: bookCollections[
                                              ReadStatus.willRead],
                                        );
                                      } else {
                                        showSignInDialog();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: showSpinner,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 100.0),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kPrimaryColour),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !showSpinner,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7.0),
                                    child: TextTitle('Description'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            if (widget.book.htmlDescription != null)
                              Html(
                                data: '${widget.book.htmlDescription}',
                                style: {
                                  "p": Style(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    padding: EdgeInsets.zero,
                                    fontFamily: 'SFPro',
                                  ),
                                },
                              ),
                            SizedBox(height: 15.0),
                            Visibility(
                              visible:
                                  widget.book.publisher != null && !showSpinner,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Published by ${widget.book.publisher}',
                                  style: TextStyle(
                                    fontFamily: 'SFPro',
                                    fontStyle: FontStyle.italic,
                                    color: kLightText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
}
