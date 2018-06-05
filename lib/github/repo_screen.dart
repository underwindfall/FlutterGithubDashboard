import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/model/repo.dart';
import 'package:githubdashboard/github/model/user.dart';

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

class RepoListScreenState extends State<RepoListScreen>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final TextEditingController _searchController = new TextEditingController();
  final GithubApi _githubApi = new GithubApi();
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
    final userModel = await _githubApi.getUser(userName);
    final repos = await _githubApi.getRepos(userName);
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
    return new RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      child: new ListView.builder(
        padding: kMaterialListPadding,
        itemCount: mRepos.length,
        itemBuilder: _buildReopItem,
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
    _githubApi.getUser(name).then((model) {
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
    _githubApi.getRepos(name).then((repoList) {
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
    Navigator.pushNamed(
        context, '/repos/${repo.ownerModel.login}/${repo.name}');
  }


}