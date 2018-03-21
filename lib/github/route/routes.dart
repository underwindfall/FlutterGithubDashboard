import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/copyright_screen.dart';
import 'package:githubdashboard/github/error_screen.dart';
import 'package:githubdashboard/github/login_screen.dart';
import 'package:githubdashboard/github/repo_screen.dart';
import 'package:githubdashboard/github/repodetail_screen.dart';

typedef Widget HandlerFunc(BuildContext context, Map<String, dynamic> params);

HandlerFunc buildLoginHandler(GithubApi api) {
  return (BuildContext context, Map<String, dynamic> params) =>
  new LoginScreen(api);
}

HandlerFunc buildRepoListHandler(GithubApi api) {
  return (BuildContext context,
      Map<String, dynamic> params) => new RepoListScreen(name: api.username);
}

HandlerFunc buildErrorHandler(GithubApi api) {
  return (BuildContext context,
      Map<String, dynamic> params) => new ErrorScreen(api);
}

HandlerFunc buildCopyRightHandler() {
  return (BuildContext context,
      Map<String, dynamic> params) => new CopyRightScreen();
}

HandlerFunc buildRepoHandler(GithubApi api) {
  return (BuildContext context,
      Map<String, dynamic> params) =>
  new RepoScreen(
      api,
//       new RepoManager(api),
      params['owner'][0],
      params['repo'][0]
//      "Android_MVP_Sport"
  );
}


void configureRouter(Router router, GithubApi api) {
  router.define(
      '/login',
      handler: new Handler(handlerFunc: buildLoginHandler(api))
  );

  router.define(
      '/error',
      handler: new Handler(handlerFunc: buildErrorHandler(api))
  );

  router.define(
      '/user/repos',
      handler: new Handler(handlerFunc: buildRepoListHandler(api))
  );

  router.define(
      '/repos/:owner/:repo',
      handler: new Handler(handlerFunc: buildRepoHandler(api))
  );

  router.define(
      '/copyright', handler: new Handler(handlerFunc: buildCopyRightHandler())
  );
}