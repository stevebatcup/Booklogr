import 'package:booklogr/components/navigation/nav_bar_logo.dart';
import 'package:booklogr/screens/have_read_screen.dart';
import 'package:booklogr/screens/home_screen.dart';
import 'package:booklogr/screens/reading_screen.dart';
import 'package:booklogr/screens/will_read_screen.dart';
import 'package:booklogr/utils/web_page_route.dart';
import 'package:flutter/material.dart';

import 'nav_bar_item.dart';

enum NavBarSection {
  search,
  haveRead,
  reading,
  willRead,
}

class NavBar extends StatelessWidget {
  const NavBar({Key key, @required this.activeSection, this.showLogo = false})
      : super(key: key);

  final NavBarSection activeSection;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NavBarLogo(),
          // if (!showLogo) SizedBox(width: 120),
          Container(
            width: MediaQuery.of(context).size.width / 1.7,
            child: Container(
              padding: EdgeInsets.only(top: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  NavBarItem(
                    label: 'Search',
                    isActive: activeSection == NavBarSection.search,
                    onClick: () {
                      Navigator.of(context).pushReplacement(
                        WebPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                  ),
                  NavBarItem(
                    label: 'Have read',
                    isActive: activeSection == NavBarSection.haveRead,
                    onClick: () {
                      Navigator.of(context).pushReplacement(
                        WebPageRoute(
                          builder: (context) => HaveReadScreen(),
                        ),
                      );
                    },
                  ),
                  NavBarItem(
                    label: 'Currently reading',
                    isActive: activeSection == NavBarSection.reading,
                    onClick: () {
                      Navigator.of(context).pushReplacement(
                        WebPageRoute(
                          builder: (context) => ReadingScreen(),
                        ),
                      );
                    },
                  ),
                  NavBarItem(
                    label: 'Will read',
                    isActive: activeSection == NavBarSection.willRead,
                    onClick: () {
                      Navigator.of(context).pushReplacement(
                        WebPageRoute(
                          builder: (context) => WillReadScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 120)
        ],
      ),
    );
  }
}
