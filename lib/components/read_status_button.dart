import 'package:flutter/material.dart';
import 'package:booklogr/models/book.dart';
import 'package:booklogr/utils/utils.dart';

class ReadStatusButton extends StatelessWidget {
  const ReadStatusButton({
    Key key,
    @required this.label,
    @required this.currentReadStatus,
    @required this.buttonReadStatus,
    @required this.onTap,
  }) : super(key: key);

  final String label;
  final ReadStatus currentReadStatus;
  final ReadStatus buttonReadStatus;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: currentReadStatus == buttonReadStatus
                ? Colors.transparent
                : kPrimaryColour,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10.0),
          color: currentReadStatus == buttonReadStatus
              ? kPrimaryColour
              : Color(0XFFFFF4E7),
        ),
        height: 80.0,
        width: MediaQuery.of(context).size.width / 3.4,
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: currentReadStatus == buttonReadStatus
                  ? Colors.white
                  : kPrimaryColour,
            ),
          ),
        ),
      ),
    );
  }
}
