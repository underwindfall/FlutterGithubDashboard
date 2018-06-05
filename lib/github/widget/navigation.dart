import 'package:flutter/material.dart';

class HomeScreenItem {

  final BottomNavigationBarItem item;
  final Widget content;

  HomeScreenItem({Widget icon, Widget title, Widget content})
      : item = new BottomNavigationBarItem(icon: icon, title: title),
        content = content;
}

