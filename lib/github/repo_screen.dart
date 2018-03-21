import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/constant/Strings.dart';
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

  Future<UserModel> _future;

  String get userName => widget.name;

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;


  bool _showDrawerContents = true;

  @override
  void initState() {
    super.initState();
    fetchData(userName);
    _scaffoldKey =
    new GlobalKey<ScaffoldState>(debugLabel: 'Search Name $userName');
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    _future = _githubApi.getUser(userName);
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(
            mUserModel == null ? 'Github Repo' : '${mUserModel
                .name} \'s Repo'),
        actions: <Widget>[
//          new IconButton(
//              icon: new CircleAvatar(
//                child: new Image.network(
//                  (mUserModel == null || mUserModel.avatarUrl.isEmpty)
//                      ? 'https://assets-cdn.github.com/images/modules/logos_page/Octocat.png'
//                      : mUserModel.avatarUrl,
//                  width: 20.0,
//                  height: 20.0,
//                ),
//              ),
//              onPressed: null), //IconButton
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
      drawer: _buildDrawer(),
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

  Widget _buildDrawer() {
    Drawer drawer = new Drawer(
      child: new Column(
        children: <Widget>[
          new FutureBuilder<UserModel>(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return new Center(
                  child: new Text(snapshot.error),
                );
              }
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(
                    child: new CircularProgressIndicator(),
                  );
                default:
                  return new UserAccountsDrawerHeader(
                    accountName: new Text(
                        snapshot.data.login),
                    accountEmail: new Text(snapshot.data.email),
                    currentAccountPicture: new CircleAvatar(
                      child: new Image.network(snapshot.data.avatarUrl,),
                    ),
                    margin: EdgeInsets.zero,
//            onDetailsPressed: () {
//              _showDrawerContents = !_showDrawerContents;
//              if (_showDrawerContents)
//                _controller.reverse();
//              else
//                _controller.forward();
//            },
                  );
              }
            },
          ),

          new MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: new Expanded(
              child: new ListView(
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      // The initial contents of the drawer.
                      new FadeTransition(
                        opacity: _drawerContentsOpacity,
                        child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: _buildDrawerOptions()
                        ),
                      ),
                      // The drawer's "details" view.
                      new SlideTransition(
                        position: _drawerDetailsPosition,
                        child: new FadeTransition(
                          opacity: new ReverseAnimation(_drawerContentsOpacity),
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              new ListTile(
                                leading: const Icon(Icons.add),
                                title: const Text('Add account'),
                                onTap: _showNotImplementedMessage,
                              ),
                              new ListTile(
                                  leading: const Icon(Icons.exit_to_app),
                                  title: const Text('Log out accounts'),
                                  onTap: () {
                                    _githubApi.logout()
                                        .then((_) =>
                                        Navigator.pushReplacementNamed(
                                            context, '/login'));
                                  }
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return drawer;
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

  _buildDrawerOptions() {
    var options = <Widget>[];
    var option1 = new ListTile(
      leading: const Icon(Icons.info),
      title: const Text('Legal Mentions'),
      onTap: _showNotImplementedMessage,
    );

    var option2 = new ListTile(
      leading: const Icon(Icons.settings),
      title: const Text('Settings'),
      onTap: _showNotImplementedMessage,
    );

    options.add(option1);
    options.add(option2);
    return options;
  }

  Widget _drawerOption(Icon icon, String name) {
    return new Container(
      padding: const EdgeInsets.only(top: 19.0),
      child: new Row(
        children: <Widget>[
          new Container(
              padding: const EdgeInsets.only(right: 28.0), child: icon),
          new Text(name, textScaleFactor: 1.1)
        ],
      ),
    );
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
  }

  String _validateSearch(String value) {
    if (value.isEmpty) {
      return 'Name is required';
    } else {
      return null;
    }
  }

  void _showNotImplementedMessage() {
    Navigator.of(context).pop(); // Dismiss the drawer.
    _scaffoldKey.currentState.showSnackBar(const SnackBar(
        content: const Text("The drawer's items don't do anything")
    ));
  }

}