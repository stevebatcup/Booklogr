import 'package:flutter/material.dart';
import 'package:booklogr/utils/text_styles.dart';

class ActionButton extends StatelessWidget {
  ActionButton(
    this.label, {
    this.colour,
    @required this.action,
  });

  final Color colour;
  final Function action;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        color: colour,
        borderRadius: BorderRadius.circular(10.0),
        elevation: 2.0,
        child: MaterialButton(
          onPressed: action,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            label,
            style: kActionButtonTextstyle,
          ),
        ),
      ),
    );
  }
}
