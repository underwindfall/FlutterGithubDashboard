import 'package:flutter/material.dart';

import 'homeScreen.dart';

class GithubDashBoardApp extends StatefulWidget {


  @override
  GithubDashBoardAppState createState() => new GithubDashBoardAppState();

}

class GithubDashBoardAppState extends State<GithubDashBoardApp> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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