import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';

import 'repo_screen.dart';

class GithubDashBoardHome extends StatefulWidget {
  final GithubApi _githubApi;


  GithubDashBoardHome(this._githubApi);

  @override
  GithubDashBoardHomeState createState() =>
      new GithubDashBoardHomeState(_githubApi);

}

class SearchData {
  String name = '';
}

class GithubDashBoardHomeState extends State<GithubDashBoardHome>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GithubApi _githubApi;
  SearchData searchData = new SearchData();

  GithubDashBoardHomeState(this._githubApi);


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      Navigator.of(context).push(
          new MaterialPageRoute(
              settings: const RouteSettings(name: RepoListScreen.routeName),
              builder: (context) {
                return new RepoListScreen(name: searchData.name);
              })
      );
    }
  }

  String _validateSearch(String value) {
    if (value.isEmpty) {
      return 'Name is required';
    } else {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Github DashBoard"),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          child: new ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 80.0),
            children: <Widget>[
              //Logo
              new Image.network(
                'https://image.flaticon.com/icons/png/512/25/25231.png',
                height: 150.0,
                width: 150.0,
              ),
              //input search field
              new Container(
                padding: const EdgeInsets.only(top: 80.0),
                alignment: Alignment.center,
                child: new TextFormField(
                  decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'What do you want to seach for?',
                      labelText: 'Search *'
                  ),
                  onSaved: (String value) {
                    searchData.name = value;
                  },
                  validator: _validateSearch,
                ),

              ),
              //
              new Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: new RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 30.0),
                  child: const Text('Search'),
                  onPressed: _handleSubmitted,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}