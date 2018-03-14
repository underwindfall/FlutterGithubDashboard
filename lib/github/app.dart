import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/route/routes.dart';
import 'package:githubdashboard/github/splash_screen.dart';

class GithubDashBoardApp extends StatelessWidget {

  final Router router = new Router();
  final GithubApi _githubApi = new GithubApi();

  GithubDashBoardApp() {
    configureRouter(router, _githubApi);
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Github DashBoard',
      theme: new ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home: new SplashScreen(_githubApi),
      onGenerateRoute: router.generator,
    );
  }
}
