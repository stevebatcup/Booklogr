import 'package:flutter/material.dart';

import 'package:booklogr/components/action_button.dart';
import 'package:booklogr/utils/colours.dart';
import 'package:booklogr/utils/text_styles.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 5.0,
          ),
          child: TextField(
            style: kTextInputStyle,
            onChanged: (value) {},
            decoration: kSearchTextFieldDecoration,
          ),
        ),
        ActionButton(
          'Search',
          colour: kPrimaryColour,
          action: () {},
        ),
      ],
    );
  }
}
