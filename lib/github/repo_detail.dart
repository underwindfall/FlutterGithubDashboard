import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/model/repo.dart';
import 'package:githubdashboard/github/model/repo_detail.dart';

class GithubRepoDetail extends StatefulWidget {
  final RepoModel repoModel;
  final int index;

  GithubRepoDetail(this.repoModel, {@required this.index});

  static const String routeName = '/github/repo_detail';

  @override
  GithubRepoDetailState createState() => new GithubRepoDetailState();

}

class GithubRepoDetailState extends State<GithubRepoDetail> {
  RepoDetailModel model;
  RepoModel repoModel;
  final GithubApi api = new GithubApi();

  @override
  void initState() {
    super.initState();
    _loadData(widget.repoModel);
    repoModel = widget.repoModel;
  }

  @override
  Widget build(BuildContext context) {
    var content;
    if (model == null) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = _setData(model, repoModel);
    }
    return content;
  }

  void _loadData(RepoModel repoModel) async {
    var repoOwner = repoModel.ownerModel.login;
    var repoName = repoModel.name;
    api.getRepoDetail(repoOwner, repoName)
        .then((repoDetailModel) {
      setState(() {
        model = repoDetailModel;
      });
    });
  }

  _setData(RepoDetailModel repoDetailModel, RepoModel repoModel) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('Github Repo Detail'),
        ), //appbar
        body: new ListView(
          itemExtent: 366.0,
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: new RepoItem(
                  repoDetail: repoDetailModel, repo: repoModel,)
            )
          ],
        ) //ListView
    ); //Scaffold
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
                  height: 184.0,
                  child: new Stack(
                    children: <Widget>[
                      new Positioned.fill(
                        child: new Image.network(
                          'https://dn-sdkcnssl.qbox.me/article/fyuBUISCkmddVNC0t2Iu.png',
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
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: new Text(
                                repoDetail == null ? "login" : repoDetail
                                    .ownerModel.login,
                                style: descriptionStyle.copyWith(
                                    color: Colors.black54),
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
                new ButtonTheme.bar(
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
                          repoDetail == null ? "0" : repo.starCount.toString()
                      )
                    ],
                  ),
                ),
              ]), //Colum
        ), //Card
      ), //Container
    ); //SafeArea
  }


}
