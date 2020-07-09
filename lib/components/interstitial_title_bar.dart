import 'package:flutter/material.dart';

import 'package:booklogr/utils/text_styles.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InterstitialTitleBar extends StatelessWidget {
  const InterstitialTitleBar({Key key, this.bottomPadding, this.title})
      : super(key: key);

  final double bottomPadding;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 5.0,
        bottom: bottomPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(),
          Text(
            title,
            style: kAuthPageTitleTextStyle,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: Icon(
                FontAwesomeIcons.times,
                textDirection: TextDirection.rtl,
                color: Colors.grey,
                size: 29.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
