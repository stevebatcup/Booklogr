import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CentredView extends StatelessWidget {
  final Widget child;

  CentredView({this.child});

  @override
  Widget build(BuildContext context) {
    var deviceType = getDeviceType(MediaQuery.of(context).size);

    if (deviceType == DeviceScreenType.mobile) {
      return child;
    } else {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          left: 30.0,
          top: 40.0,
          right: 30,
        ),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1050),
          child: child,
        ),
      );
    }
  }
}
