import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:booklogr/utils/colours.dart';

const TextStyle kTabBarText = TextStyle(
  color: Color(0xFF9C9C9C),
  fontSize: 14.0,
  fontFamily: 'SFPro',
  fontWeight: FontWeight.w500,
);

const TextStyle kAppBarTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'SFPro',
  letterSpacing: 1.3,
);

const TextStyle kActionButtonTextstyle = TextStyle(
  color: Colors.white,
  fontFamily: 'SFPro',
  fontWeight: FontWeight.w500,
  fontSize: 18.0,
  letterSpacing: 1.3,
);

const TextStyle kTitleTextStyle = TextStyle(
  color: kBlack,
  fontFamily: 'SFPro',
  fontWeight: FontWeight.w700,
  fontSize: 19.0,
  height: 2.0,
);

const TextStyle kAuthPageTitleTextStyle = TextStyle(
  color: kBlack,
  fontFamily: 'SFPro',
  fontWeight: FontWeight.w700,
  fontSize: 24.0,
  height: 2.0,
  letterSpacing: 1.1,
);

const TextStyle kParaTextStyle = TextStyle(
  color: kBlack,
  fontFamily: 'SFPro',
  fontWeight: FontWeight.w300,
  fontSize: 18.0,
  height: 1.5,
);

const TextStyle kLinkTextStyle = TextStyle(
  color: kPrimaryColour,
  fontFamily: 'SFPro',
  fontWeight: FontWeight.w500,
  fontSize: 18.0,
  height: 1.5,
);

const TextStyle kTextInputStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  fontFamily: 'SFPro',
  color: kGrey,
);

const kSearchTextFieldDecoration = InputDecoration(
  hintStyle: kTextInputStyle,
  suffixIcon: Icon(
    FontAwesomeIcons.search,
    color: kPrimaryColour,
    size: 21.0,
  ),
  contentPadding: EdgeInsets.symmetric(
    vertical: 14.0,
    horizontal: 9.0,
  ),
  hintText: 'Enter a book title, author or ISBN...',
  focusedBorder: UnderlineInputBorder(
    // width: 0.0 produces a thin "hairline" border
    borderSide: BorderSide(color: kPrimaryColour, width: 1.0),
  ),
  enabledBorder: UnderlineInputBorder(
    // width: 0.0 produces a thin "hairline" border
    borderSide: BorderSide(color: kGrey, width: 1.0),
  ),
  border: UnderlineInputBorder(),
  errorBorder: UnderlineInputBorder(
    // width: 0.0 produces a thin "hairline" border
    borderSide: BorderSide(color: kPrimaryColour, width: 1.0),
  ),
);

const TextStyle kEmptyListTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.w500,
  fontFamily: 'SFPro',
  color: kGrey,
);

const TextStyle kAppBarActionsTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
  fontFamily: 'SFPro',
);

const TextStyle kAppBarMenuItemsTextStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w500,
  fontFamily: 'SFPro',
  color: Colors.black45,
);
