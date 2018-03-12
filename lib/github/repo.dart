import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/model/repo.dart';
import 'package:githubdashboard/github/model/user.dart';

enum IndicatorType { overscroll, refresh }


class GithubRepo extends StatefulWidget {
  const GithubRepo({Key key, @required this.name})
      :assert(name != null),
        super(key: key);

  final String name;

  static const String routeName = '/github/repo';

  @override
  GithubRepoState createState() => new GithubRepoState();
}

class GithubRepoState extends State<GithubRepo> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final GithubApi api = new GithubApi();
  UserModel mUserModel;
  List<RepoModel> mRepos = [];

  String get userName => widget.name;


  @override
  void initState() {
    super.initState();
    fetchData(userName);
    _scaffoldKey =
    new GlobalKey<ScaffoldState>(debugLabel: 'Search Name $userName');
  }


  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(seconds: 3), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      _scaffoldKey.currentState?.showSnackBar(new SnackBar(
          content: const Text('Refresh complete'),
          action: new SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              }
          )
      ));
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(
            mUserModel == null ? 'Github Repo' : '${mUserModel
                .name} \'s Github Repo'),
        actions: <Widget>[
          new IconButton(
              icon: new CircleAvatar(
                child: new Image.network(
                  (mUserModel == null || mUserModel.avatarUrl.isEmpty)
                      ? 'https://assets-cdn.github.com/images/modules/logos_page/Octocat.png'
                      : mUserModel.avatarUrl,
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              onPressed: null),
          new IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
                fetchData(mUserModel.name);
              }),

        ],
      ), //appbar
      body: new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: new ListView.builder(
            padding: kMaterialListPadding,
            itemCount: mRepos.length,
          itemBuilder: _buildReopItem,
          /*itemBuilder: (BuildContext context, int index) {
              final String item = mRepos[index].name;
              return new ListTile(
                isThreeLine: false,
                leading: new CircleAvatar(
                  child: new Image.network(
                    'https://assets-cdn.github.com/images/modules/logos_page/Octocat.png',
                    width: 20.0,
                    height: 20.0,
                  ),
                ),
                title: new Text(
                  item,
                  style: _biggerFont,
                ),
              );
            }*/
        ),

      ),
    );
  }

  _buildReopItem(BuildContext context, int index) {
    final String item = mRepos[index].name;
    var repoContent = new ListTile(
      isThreeLine: false,
      leading: new CircleAvatar(
        child: new Image.network(
          'https://assets-cdn.github.com/images/modules/logos_page/Octocat.png',
          width: 20.0,
          height: 20.0,
        ),
      ),
      title: new Text(
        item,
        style: _biggerFont,
      ),
    );

    var repoItem = new GestureDetector(
      onTap: () => print('test $index'),
      child: repoContent,
    );
    return repoItem;
  }


  fetchData(String name) {
    api.getUser(name).then((model) {
      setState(() {
        if (model != null) {
          mUserModel = model;
        } else {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text('fetch user error')
          ));
        }
      });
    });
    api.getRepos(name).then((repoList) {
      setState(() {
        if (repoList != null) {
          mRepos = repoList;
        } else {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content: new Text('fetch repos error')
          ));
        }
      });
    });
  }


}