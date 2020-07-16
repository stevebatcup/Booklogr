import 'package:flutter/material.dart';

import 'colours.dart';

class WebModal extends PageRouteBuilder {
  final Widget page;
  final bool opaque;

  WebModal({this.opaque, this.page})
      : super(
          barrierColor: kBarrierColor,
          barrierDismissible: true,
          opaque: opaque,
          pageBuilder: (BuildContext context, animation, secondAnimation) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 550, maxHeight: 700),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: page, // FlatButton
                ),
              ),
            );
          },
        );
}
