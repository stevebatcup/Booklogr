import 'package:flutter/material.dart';
import 'package:booklogr/utils/text_styles.dart';

class EmptyListAction extends StatelessWidget {
  const EmptyListAction({
    Key key,
    this.icon,
    this.label,
    this.onTap,
  }) : super(key: key);

  final String label;
  final Icon icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 370),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              SizedBox(height: 10.0),
              Text(
                label,
                style: kEmptyListTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
