import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/error_screen.dart';
import 'package:githubdashboard/github/home_screen.dart';
import 'package:githubdashboard/github/login_screen.dart';
import 'package:githubdashboard/github/repo_screen.dart';

typedef Widget HandlerFunc(BuildContext context, Map<String, dynamic> params);

HandlerFunc buildLoginHandler(GithubApi api) {
  return (BuildContext context, Map<String, dynamic> params) =>
  new LoginScreen(api);
}

HandlerFunc buildHomeHandler(GithubApi api) {
  return (BuildContext context, Map<String, dynamic> params) =>
//  new GithubDashBoardHome();
  new LoginScreen(api);
}

HandlerFunc buildRepoListHandler(GithubApi api) {
  return (BuildContext context,
      Map<String, dynamic> params) => new RepoListScreen(name: api.username,);
}

HandlerFunc buildErrorHandler(GithubApi api) {
  return (BuildContext context,
      Map<String, dynamic> params) => new ErrorScreen(api);
}


void configureRouter(Router router, GithubApi api) {
  router.define(
      '/login',
      handler: new Handler(handlerFunc: buildLoginHandler(api))
  );

  router.define(
      '/home',
      handler: new Handler(handlerFunc: buildHomeHandler(api))
  );

  router.define(
      '/error',
      handler: new Handler(handlerFunc: buildErrorHandler(api))
  );

  router.define(
      '/user/repos',
      handler: new Handler(handlerFunc: buildRepoListHandler(api))
  );
}