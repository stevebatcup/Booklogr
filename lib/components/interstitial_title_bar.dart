import 'package:booklogr/utils/colours.dart';
import 'package:flutter/material.dart';

import 'package:booklogr/utils/text_styles.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InterstitialTitleBar extends StatelessWidget {
  const InterstitialTitleBar(
      {Key key, this.bottomPadding, this.title, this.subTitle});

  final double bottomPadding;
  final String title;
  final String subTitle;

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
          Column(
            children: <Widget>[
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 350),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: kAuthPageTitleTextStyle.copyWith(
                      height: 1.3,
                    ),
                  ),
                ),
              ),
              if (subTitle != null)
                Text(
                  subTitle,
                  style: TextStyle(
                    fontFamily: 'SFPro',
                    color: kLightText,
                  ),
                ),
            ],
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
