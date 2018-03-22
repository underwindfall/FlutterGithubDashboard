import 'dart:async';

import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/constant/Strings.dart';
import 'package:githubdashboard/github/model/user.dart';
import 'package:githubdashboard/github/repo_screen.dart';
import 'package:githubdashboard/github/widget/navigation.dart';


class HomeScreen extends StatefulWidget {

  final GithubApi _githubApi;

  HomeScreen(this._githubApi);

  @override
  State createState() => new _HomeScreenState(_githubApi);
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<HomeScreenItem> _homeScreenItems;
  final GithubApi _githubApi;
  Future<UserModel> _future;

  bool _showDrawerContents = true;
  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _HomeScreenState(this._githubApi);


  @override
  void initState() {
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>(debugLabel: 'HomeScreen');
    _future = _githubApi.getUser(_githubApi.username);
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
    _homeScreenItems = [
      new HomeScreenItem(
          icon: const Icon(Icons.rss_feed),
          title: const Text(Strings.NAV_ITEM_FEED),
          content: new RepoListScreen(
            name: _githubApi.username,
          )
      ),
      new HomeScreenItem(
        icon: const Icon(Icons.person),
        title: const Text(Strings.NAV_ITEM_REPO),
        content: new RepoListScreen(
          name: _githubApi.username,
        ),
      )
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: _buildDrawer(),
      body: _homeScreenItems[_currentIndex].content,
      bottomNavigationBar: new BottomNavigationBar(
        items: _homeScreenItems.map((HomeScreenItem item) => item.item)
            .toList(),
        onTap: _navBarItemSelected,
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
                    onDetailsPressed: () {
                      _showDrawerContents = !_showDrawerContents;
                      if (_showDrawerContents)
                        _controller.reverse();
                      else
                        _controller.forward();
                    },
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

  _buildDrawerOptions() {
    var options = <Widget>[];
    var option1 = new ListTile(
        leading: const Icon(Icons.info),
        title: const Text(Strings.OPTIONS_COPY_RIGHT),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/copyright');
        }
    );

    var option2 = new ListTile(
      leading: const Icon(Icons.settings),
      title: const Text(Strings.OPTIONS_SETTINGS),
      onTap: _showNotImplementedMessage,
    );

    options.add(option1);
    options.add(option2);
    return options;
  }

  void _showNotImplementedMessage() {
    Navigator.of(context).pop(); // Dismiss the drawer.
    _scaffoldKey.currentState.showSnackBar(const SnackBar(
        content: const Text("The drawer's items don't do anything")
    ));
  }

  void _navBarItemSelected(int selected) {
    setState(() {
      _currentIndex = selected;
    });
  }
}



