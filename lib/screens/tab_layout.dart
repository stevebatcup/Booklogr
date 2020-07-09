import 'package:booklogr/services/tab_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:booklogr/utils/colours.dart';

import 'package:provider/provider.dart';

class TabLayout extends StatefulWidget {
  static final String pageRoute = "/search";

  @override
  _TabLayoutState createState() => _TabLayoutState();
}

class _TabLayoutState extends State<TabLayout> {
  final List<GlobalKey<NavigatorState>> tabKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    TabService tabService = Provider.of<TabService>(context);
    tabService.updateAppbar();

    return WillPopScope(
      onWillPop: () async {
        return !await tabKeys[tabService.tabController.index]
            .currentState
            .maybePop();
      },
      child: CupertinoTabScaffold(
        controller: tabService.tabController,
        tabBar: CupertinoTabBar(
          iconSize: 26,
          inactiveColor: kGrey,
          activeColor: kPrimaryColour,
          currentIndex: tabService.tabController.index,
          onTap: (int index) {
            if (tabService.previousIndex == index) {
              tabKeys[index].currentState.popUntil((route) => route.isFirst);
            }
            tabService.previousIndex = index;
          },
          items: tabService.tabs(),
        ),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            navigatorKey: tabKeys[index],
            builder: (BuildContext context) =>
                tabService.getSelectedPageWidget(),
          );
        },
      ),
    );
  }
}
