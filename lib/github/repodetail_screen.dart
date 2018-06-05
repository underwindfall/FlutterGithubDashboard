import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/constant/Strings.dart';
import 'package:githubdashboard/github/model/repo_detail.dart';

class RepoScreen extends StatefulWidget {

  final GithubApi _githubApi;
  final String _username;
  final String _repo;

  RepoScreen(this._githubApi, this._username, this._repo);

  static const String routeName = '/github/repo_detail';

  @override
  RepoScreenState createState() =>
      new RepoScreenState(_githubApi, _username, _repo);

}


class RepoScreenState extends State<RepoScreen>
    with SingleTickerProviderStateMixin {
  final GithubApi _githubApi;
  final String _username;
  final String _repo;
  Future<RepoDetailModel> _future;
  Future<String> _readmeFuture;
  TabController _tabController;
  static const double _appBarHeight = 165.0;

  final List<Tab> myTabs = <Tab>[
    new Tab(text: Strings.REPO_TABS_1, icon: new Icon(Icons.question_answer)),
    new Tab(text: Strings.REPO_TABS_2, icon: new Icon(Icons.playlist_add))
  ];

  RepoScreenState(this._githubApi, this._username, this._repo);

  @override
  void initState() {
    super.initState();
    _future = _githubApi.getRepoDetail(_username, _repo);
    _readmeFuture = _githubApi.getReadme(_username, _repo);
    _tabController = new TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        bottom: new PreferredSize(
            child: new Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.white),
              child: new Container(
                height: _appBarHeight,
                alignment: Alignment.bottomCenter,
                child: new TabBar(
                  controller: _tabController,
                  tabs: myTabs,
                ),
              ),
            ),
            preferredSize: const Size.fromHeight(_appBarHeight)
        ),
        flexibleSpace: _buildRepoView(),
      ), //Appbar
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new TabBarView(
          children: _buildTabsView(), controller: _tabController,),
      ), //SafeArea
    ); //Scaffold
  }


  List<Widget> _buildTabsView() {
    var tabViews = <Widget>[];
    tabViews.add(
      new Container(
        padding: const EdgeInsets.all(12.0),
        child: new Card(
          child: new Center(
            child: new FutureBuilder<String>(
              future: _readmeFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return new Text(
                    Strings.ERROR_GENERAL,
                    textAlign: TextAlign.center,
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return new Text(Strings.EMPTY_STRING,
                        textAlign: TextAlign.center);
                  case ConnectionState.waiting:
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  default:
                    return _buildReadme(snapshot.data);
                }
              },
            ),
          ),
        ),
      ),
    );
    tabViews.add(
      new Container(
        padding: const EdgeInsets.all(12.0),
        child: new Card(
          child: new Center(
            child: new Text(
              "Working on it",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
    return tabViews;
  }

  Widget _buildRepoView() {
    return new FutureBuilder<RepoDetailModel>(

      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return new Center(
            child: new Text(snapshot.error),
          ); //Center
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Center(
              child: new CircularProgressIndicator(),
            );
          default:
            return new Column(
              children: <Widget>[
                _buildReopHeader(snapshot.data),
                const Divider()
              ],
            );
        }
      },
    ); //SliverAppBar
  }

  Widget _buildReopHeader(RepoDetailModel repoDetailModel) {
    var items = <Widget>[];
    //todo fork action....
    if (repoDetailModel.description != null) {
      items.add(
          new Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 29.0, 20.0, 10.0),
            child: new Text(
              repoDetailModel.description,
              maxLines: 1,
              style: new TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          )
      );
    }
    items.add(
        new Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildStatButton(
                  repoDetailModel.subscribersCount,
                  const Icon(
                    Icons.visibility, size: 14.0, color: Colors.white,), //Icon
                      () {
                    Navigator.pushNamed(
                        context, 'repo/$_username/$_repo/subscribers');
                  }), //buildStatButton
              _buildStatButton(
                  repoDetailModel.stargazersCount,
                  const Icon(Icons.star, size: 14.0, color: Colors.white),
                      () {
                    Navigator.pushNamed(
                        context, '/repos/$_username/$_repo/stargazers');
                  }),
              _buildStatButton(
                  repoDetailModel.forksCount,
                  const Icon(Icons.call_split, size: 14.0, color: Colors.white),
                      () {
                    Navigator.pushNamed(
                        context, 'repos/$_username/$_repo/forks');
                  })
            ],
          ),
        )
    );
    items.add(
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildStatButton(repoDetailModel.openIssues,
                const Text(Strings.ISSUES_TITLE,
                  style: const TextStyle(color: Colors.white),), () {}),
            _buildStatButton(repoDetailModel.openIssues,
                const Text(Strings.PULLREQUEST_TILE,
                    style: const TextStyle(color: Colors.white)), () {}),
          ],
        )
    );

    return new Container(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
      ),
    );
  }

  Widget _buildStatButton(int count, Widget bottom, VoidCallback onPressed) {
    return new FlatButton(
        onPressed: onPressed,
        child: new Column(
          children: <Widget>[
            new Text(
                count.toString(), style: const TextStyle(color: Colors.white)),
            new Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: bottom
            )
          ],
        )
    );
  }

  Widget _buildReadme(String data) {
    return new Markdown(data: data,);
  }


}
