import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/pages/views/search.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:ProjectFlow/pages/views/account/account.dart';
import 'package:ProjectFlow/pages/views/watches.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'home.dart';

class MainSkeleton extends StatefulWidget {
  @override
  State<MainSkeleton> createState() => _MainSkeletonState();
}

class _MainSkeletonState extends State<MainSkeleton> {
  var _currentIndex = 0;

  final data = [
    [
      "Projects",
      project_icon,
      FluentIcons.dock_panel_left_24_filled,
      Projects(),
      "Manage your projects here"
    ],
    [
      "Search",
      FluentIcons.search_24_regular,
      FluentIcons.search_24_filled,
      Search(),
      "Search through all your task here"
    ],
    [
      "Watches",
      FluentIcons.eye_show_24_regular,
      FluentIcons.eye_show_24_filled,
      Watches(),
      "View all your watches here"
    ],
    [
      "Account",
      FluentIcons.person_24_regular,
      FluentIcons.person_24_filled,
      Account(),
      "Manage your information here"
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      layout: 2,
      title: data[_currentIndex][0],
      subtitle: data[_currentIndex][4],
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: data[_currentIndex][3],
      ),
      bottomNavigationBar: SalomonBottomBar(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        selectedColorOpacity: 0.15,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: data.map((data) {
          return SalomonBottomBarItem(
            title: Text(data[0]),
            icon: Icon(data[1]),
            activeIcon: Icon(data[2]),
          );
        }).toList(),
      ),
    );
  }
}
