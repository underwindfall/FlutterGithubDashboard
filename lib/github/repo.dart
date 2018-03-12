import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/model/github_types.dart';

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

  UserModel mUserModel;

  final _biggerFont = const TextStyle(fontSize: 18.0);


//  String get currentAuthor=>

  //todo 动态话数组
  static final List<String> _items = <String>[
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'
  ];


  @override
  void initState() {
    super.initState();
    _scaffoldKey =
    new GlobalKey<ScaffoldState>(debugLabel: 'Search Name ${widget.name}');
//    getUserData(widget.name);
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
        title: new Text('Github Repo'),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
//                _refreshIndicatorKey.currentState.show();
                getUserData('underwindfall');
              })
        ],
      ), //appbar
      body: new RefreshIndicator(
        key: _refreshIndicatorKey,
//        onRefresh: _handleRefresh,
        onRefresh: _handleRefresh,
        child: new ListView.builder(
            padding: kMaterialListPadding,
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              final String item = _items[index];
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
                  generateWordPairs()
                      .take(1)
                      .toSet()
                      .first
                      .asPascalCase,
                  style: _biggerFont,
                ),
              );
            }
        ),

      ),
    );
  }


  void getUserData(String name) {
//    var httpClient = new HttpClient();
//    var url ='$BASE_URL/users/underwindfall?access_token=$TOKEN';
//    var request = await httpClient.getUrl(Uri.parse(url));
//    var response = await request.close();
//    var responseBody = await response.transform(UTF8.decoder).join();
//    var data = JSON.decode(responseBody);
//    var result = data['id'];
//    await GithubApi.getUser(name).then((value) {
//      debugPrint(value.name);
//      setUserModel(value);
//      debugPrint(value.name);
//    });

    new GithubApi().getUser('underwindfall').then((model) {
      setState(() {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text(model.name)
        ));
      });
    });
  }

  void setUserModel(UserModel model) {
    setState(() {
      debugPrint(model.name);
      mUserModel = model;
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text(mUserModel.name)
      ));
    });
  }

}