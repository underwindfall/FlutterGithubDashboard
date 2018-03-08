import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class GithubDashBoardApp extends StatefulWidget {


  @override
  _GithubDashBoardAppState createState() => new _GithubDashBoardAppState();

}

class _GithubDashBoardAppState extends State<GithubDashBoardApp> {

  double _timeDilation = 1.0;

  Timer _timeDilationTimer;

  @override
  void initState() {
    _timeDilation = timeDilation;
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }

}