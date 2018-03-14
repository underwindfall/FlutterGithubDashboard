import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/constant/Strings.dart';

class ErrorScreen extends StatefulWidget {
  final GithubApi _githubApi;

  ErrorScreen(this._githubApi);

  @override
  State<StatefulWidget> createState() => new _ErrorScreenState(_githubApi);

}

class _ErrorScreenState extends State<ErrorScreen> {
  final GithubApi _githubApi;

  _ErrorScreenState(this._githubApi);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Strings.ERROR_APPBAR_TITLE),
        centerTitle: true,
      ), //appbar
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/unicorn.png',
                fit: BoxFit.cover,
                height: 200.0,
                width: 200.0,
              ), //Image
              new Text(
                Strings.ERROR_GENERAL,
                textAlign: TextAlign.center,
                style: new TextStyle(fontSize: 20.0, color: Colors.redAccent),
              ), //Text
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new RaisedButton.icon(
                    label: const Text(Strings.ERROR_RETRY),
                    icon: const Icon(Icons.refresh),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: _handleClick
                ),
              ) //RaisedButton
            ], //Widget
          ), //Column
        ),
      ), //container
    );
  }

  void _handleClick() {
    Navigator.pushReplacementNamed(context, '/login');
  }

}