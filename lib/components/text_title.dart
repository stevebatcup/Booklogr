import 'package:flutter/material.dart';
import 'package:booklogr/utils/utils.dart';

class TextTitle extends StatelessWidget {
  TextTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: kPrimaryColour,
            width: 4.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'SFPro',
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
