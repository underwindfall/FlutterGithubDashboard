import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'home.dart';

class GithubDashBoardApp extends StatefulWidget {


  @override
  GithubDashBoardAppState createState() => new GithubDashBoardAppState();

}

class GithubDashBoardAppState extends State<GithubDashBoardApp> {

  double _timeDilation = 1.0;

  Timer _timeDilationTimer;

  @override
  void initState() {
    _timeDilation = timeDilation;
    super.initState();
  }

  @override
  void dispose() {
    _timeDilationTimer?.cancel();
    _timeDilationTimer = null;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Github DashBoard',
      theme: new ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home: new GithubDashBoardHome(),
    );
  }

}