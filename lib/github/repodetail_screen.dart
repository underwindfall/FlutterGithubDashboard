import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/constant/Strings.dart';
import 'package:githubdashboard/github/model/repo.dart';
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
  TabController _tabController;
  static const double _appBarHeight = 160.0;

  final List<Tab> myTabs = <Tab>[
    new Tab(text: Strings.REPO_TABS_1, icon: new Icon(Icons.question_answer)),
    new Tab(text: Strings.REPO_TABS_2, icon: new Icon(Icons.playlist_add))
  ];

  RepoScreenState(this._githubApi, this._username, this._repo);

  @override
  void initState() {
    super.initState();
    _future = _githubApi.getRepoDetail(_username, _repo);
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
            child: new Text(
              "Working on it",
              textAlign: TextAlign.center,
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
            padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 10.0),
            child: new Text(
              repoDetailModel.description,
              maxLines: 3,
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
                const Text(Strings.ISSUES_TITLE), () {}),
            _buildStatButton(repoDetailModel.openIssues,
                const Text(Strings.PULLREQUEST_TILE), () {}),
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
            new Text(count.toString()),
            new Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: bottom
            )
          ],
        )
    );
  }


}


class RepoItem extends StatelessWidget {
  RepoItem({Key key, @required this.repoDetail, @required this.repo})
      :assert(repoDetail != null),
        super(key: key);
  final RepoDetailModel repoDetail;
  final RepoModel repo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle = theme.textTheme.headline.copyWith(
        color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    return new SafeArea(
      top: false,
      bottom: false,
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        height: 366.0,
        child: new Card(
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //profile Image and title
                new SizedBox(
                  height: 175.0,
                  child: new Stack(
                    children: <Widget>[
                      new Positioned.fill(
                        child: new Image.network(
                          'http://hd.wallpaperswide.com/thumbs/code_rain_dark-t2.jpg',
                          fit: BoxFit.cover,
                        ), //image Network
                      ), //Positioned.fill
                      new Positioned(
                          bottom: 16.0,
                          left: 16.0,
                          right: 16.0,
                          child: new FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: new Text(
                              repoDetail == null ? "name" : repoDetail.name,
                              style: titleStyle,
                            ), //text
                          ) //FittedBox
                      ), //Positioned
                    ], //widget
                  ), //stack
                ), //sizedBox
                //descrption and star language profile
                new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: new DefaultTextStyle(
                        softWrap: false,
                        style: descriptionStyle,
                        overflow: TextOverflow.ellipsis,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //three line description
                            new Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: new Chip(
                                avatar: new CircleAvatar(
                                  child: new Image.network(
                                    (repoDetail == null ||
                                        repoDetail.ownerModel.avatarUrl.isEmpty)
                                        ? 'https://assets-cdn.github.com/images/modules/logos_page/Octocat.png'
                                        : repoDetail.ownerModel.avatarUrl,

                                  ),
                                ),
                                label: new Text(
                                  repoDetail == null ? "login" : repoDetail
                                      .ownerModel.login,
                                  style: descriptionStyle.copyWith(
                                      color: Colors.black54),
                                ),


                              ), //Text
                            ), //padding
                            new Text(
                                repoDetail == null ? "language" : repoDetail
                                    .language),
                            new Text(
                                repoDetail == null ? "Description" : repoDetail
                                    .description)

                          ],
                        ), //Column
                      ),
                    )
                ), //Expanded
                //Star
                new IconTheme(
                    data: new IconThemeData(color: Colors.yellowAccent),
                    child: new ButtonTheme.bar(
                      child: new ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new IconButton(
                            icon: const Icon(Icons.star),
                            onPressed: () {
                              print("clicked Star");
                            },
                          ),
                          new Text(
                              repoDetail == null ? "0" : repo.starCount
                                  .toString()
                          )
                        ],
                      ),
                    )),
              ]), //Colum
        ), //Card
      ), //Container
    ); //SafeArea
  }


}
