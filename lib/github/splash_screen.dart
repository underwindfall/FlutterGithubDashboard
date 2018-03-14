import 'dart:async';

import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';

class SplashScreen extends StatefulWidget {
  final GithubApi _githubApi;

  SplashScreen(this._githubApi);

  @override
  State<StatefulWidget> createState() => new _SplashScreenState(_githubApi);

}

class _SplashScreenState extends State<SplashScreen> {
  final GithubApi _githubApi;

  _SplashScreenState(this._githubApi);

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new CircularProgressIndicator(),
      ),
    );
  }

  Future _init() async {
    await _githubApi.init();
    String routeName;
    if (_githubApi.loggedIn) {
      routeName = '/user/repos';
    } else {
      routeName = '/login';
    }
    Navigator.pushReplacementNamed(context, routeName);
  }

}