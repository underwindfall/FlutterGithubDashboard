import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/model/event.dart';
import 'package:githubdashboard/github/tiles/event_tile.dart';


enum IndicatorType { overscroll, refresh }

class FeedListScreen extends StatefulWidget {

  final String name;
  final GithubApi githubApi;


  const FeedListScreen({Key key, @required this.name, @required this.githubApi})
      :assert(name != null && githubApi != null),
        super(key: key);

  @override
  State createState() => new _FeedListScreenState(githubApi, name);
}


class _FeedListScreenState extends State<FeedListScreen> {
  final GithubApi _githubApi;
  final String _username;
  int pageIndex = 1;
  Future<List<EventModel>> _future;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState>();

  _FeedListScreenState(this._githubApi, this._username);


  @override
  void initState() {
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>(debugLabel: 'Feeds');
    _future = _githubApi.getFeeds(_username);
    pageIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      child: new FutureBuilder<List<EventModel>>(
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
                return new ListView.builder(
                    padding: kMaterialListPadding,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      if (index.isOdd) return new Divider();
                      final currentIndex = index ~/ 2;
                      if (currentIndex >= snapshot.data.length) {
                        pageIndex ++;
                      }
                      return _buildFeedsItem(snapshot.data, index);
                    }
                );
            }
          }
      ),
    );
  }

  Widget _buildFeedsItem(List<EventModel> models, int index) {
    return new EventTile(models[index]);
  }

  Future<Null> _handleRefresh() async {
//    _future =  _githubApi.getFeeds(_username);
    setState(() {
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
}