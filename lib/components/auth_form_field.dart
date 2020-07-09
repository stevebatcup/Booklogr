import 'package:flutter/material.dart';

import 'package:booklogr/utils/colours.dart';
import 'package:booklogr/utils/text_styles.dart';

class AuthFormField extends StatelessWidget {
  AuthFormField({
    this.onChanged,
    this.hintLabel,
    this.inputType,
    this.obscureText,
  });

  final Function onChanged;
  final String hintLabel;
  final TextInputType inputType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: 5.0,
      ),
      child: TextField(
        keyboardType: inputType,
        style: kTextInputStyle,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintStyle: kTextInputStyle,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 9.0,
          ),
          hintText: hintLabel,
          focusedBorder: UnderlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: kPrimaryColour, width: 1.0),
          ),
          enabledBorder: UnderlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: kGrey, width: 1.0),
          ),
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }
}
