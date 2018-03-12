import 'package:flutter/material.dart';

import 'repo.dart';

class GithubDashBoardHome extends StatefulWidget {
  const GithubDashBoardHome({
    Key key
  }) :super(key: key);

  @override
  GithubDashBoardHomeState createState() => new GithubDashBoardHomeState();

}

class SearchData {
  String name = '';
}

class GithubDashBoardHomeState extends State<GithubDashBoardHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  SearchData searchData = new SearchData();


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
//      showInSnackBar('Sucess input ${searchData.name} waiting for search ');
    }
  }

  String _validateSearch(String value) {
    if (value.isEmpty) {
      return 'Name is required';
    } else {
      Navigator.of(context).push(
          new MaterialPageRoute(
              settings: const RouteSettings(name: GithubRepo.routeName),
              builder: (context) {
                return new GithubRepo(name: value);
              })
      );
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Github DashBoard "),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          child: new ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 150.0),
            children: <Widget>[
              //Logo
              new Image.network(
                'https://image.flaticon.com/icons/png/512/25/25231.png',
                height: 150.0,
                width: 150.0,
              ),
              //input search field

              new Container(
                padding: const EdgeInsets.only(top: 100.0),
                alignment: Alignment.center,
                child: new TextFormField(
                  decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'What do you want to seach for ?',
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