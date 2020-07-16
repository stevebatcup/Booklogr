import 'package:booklogr/utils/utils.dart';
import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final String label;
  final Function onClick;
  final bool isActive;

  NavBarItem({this.label, this.onClick, this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? kPrimaryColour : Colors.transparent,
              width: 3.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5.0, top: 6.0),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? kPrimaryColour : kPrimaryVariantColour,
              fontSize: 19.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      onTap: onClick,
    );
  }
}
