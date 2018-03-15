import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/constant/Strings.dart';
import 'package:githubdashboard/github/model/repo.dart';
import 'package:githubdashboard/github/model/user.dart';
import 'package:githubdashboard/github/repodetail_screen.dart';

enum IndicatorType { overscroll, refresh }


class RepoListScreen extends StatefulWidget {
  const RepoListScreen({Key key, @required this.name})
      :assert(name != null),
        super(key: key);

  final String name;

  static const String routeName = '/github/repo';

  @override
  RepoListScreenState createState() => new RepoListScreenState();
}

class RepoListScreenState extends State<RepoListScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final TextEditingController _searchController = new TextEditingController();
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


  Future<Null> _handleRefresh() async {
    final userModel = await api.getUser(userName);
    final repos = await api.getRepos(userName);
    setState(() {
      mUserModel = userModel;
      mRepos = repos;
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
                .name} \'s Repo'),
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
              onPressed: null), //IconButton
          new IconButton(
            icon: const Icon(Icons.search),
            tooltip: Strings.REPO_SEARCH_TOOLIP,
            onPressed: () =>
                _showDialog<String>(
                  context: context,
                  child: new AlertDialog(
                    title: const Text(
                        Strings.REPO_DIALOG_TITLE
                    ),
                    content: new TextFormField(
                      decoration: const InputDecoration(
                        hintText: Strings.REPO_DIALOG_TITLE,
                      ),
                      validator: _validateSearch,
                      controller: _searchController,
                    ),
                    actions: <Widget>[
                      new FlatButton(
                          onPressed: () =>
                              Navigator.pop(context, _searchController.text),
                          child: const Text(Strings.REPO_SEARCH_TOOLIP
                          )),
                    ],
                  ), //SimpleDialog
                ),
          ), //IconButton
          new IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: Strings.REPO_REFRESH_TOOLIP,
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
                fetchData(userName);
              }), //IconButton

        ],
      ), //appbar
      body: new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: new ListView.builder(
          padding: kMaterialListPadding,
          itemCount: mRepos.length,
          itemBuilder: _buildReopItem,
        ),

      ),
    );
  }

  _buildReopItem(BuildContext context, int index) {
    final RepoModel repo = mRepos[index];
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
        repo.name,
        style: _biggerFont,
      ),
    );

    var repoItem = new GestureDetector(
      onTap: () => _navigateToRepoDetail(repo, index),
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

  _navigateToRepoDetail(RepoModel repo, int index) {
    Navigator.of(context).push(
        new MaterialPageRoute(
            settings: const RouteSettings(name: GithubRepoDetail.routeName),
            builder: (BuildContext context) {
              return new GithubRepoDetail(repo, index: index);
            })
    );
  }

  void _showDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(context: context, child: child)
        .then<Null>((T value) {
      if (value != null) {
        _handleSearch(value);
      }
    });
  }


  _handleSearch(value) {
    fetchData(value);
    // userName =value;
  }

  String _validateSearch(String value) {
    if (value.isEmpty) {
      return 'Name is required';
    } else {
      return null;
    }
  }
}