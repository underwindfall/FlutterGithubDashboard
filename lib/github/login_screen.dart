import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:githubdashboard/github/api/githubApi.dart';
import 'package:githubdashboard/github/constant/Strings.dart';


class LoginScreen extends StatefulWidget {
  final GithubApi _githubApi;

  LoginScreen(this._githubApi);

  @override
  State createState() => new _LoginScreenState(_githubApi);

}

class _LoginScreenState extends State<LoginScreen> {
  final GithubApi _githubApi;
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  _LoginScreenState(this._githubApi);

  @override
  void initState() {
    super.initState();
    //dart analytics 从什么地方开始追踪代码
    Timeline.instantSync('Start Transition', arguments: <String, String>{
      'from': '/',
      'to': 'Home'
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(Strings.LOGIN_APPBAR_TITLE),
        ), //AppBar
        body: new SafeArea(
          top: false,
          bottom: false,
          child: new Container(
              margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              padding: const EdgeInsets.all(10.0),
              child: new Form(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      margin: const EdgeInsets.only(bottom: 40.0),
                      child: new Image.network(
                        'https://image.flaticon.com/icons/png/512/25/25231.png',
                        height: 124.0,
                        width: 124.0,
                      ),
                    ), //Image
                    new TextFormField(
                      key: new Key('username'),
                      decoration: new InputDecoration(
                          icon: const Icon(Icons.account_circle),
                          hintText: Strings.LOGIN_USER_NAME
                      ),
                      autofocus: true,
                      controller: _usernameController,
                    ), //TextFormField
                    new TextFormField(
                      decoration: new InputDecoration(
                          icon: const Icon(Icons.https),
                          hintText: Strings.PASSWORD_USER_NAME
                      ),
                      controller: _passwordController,
                      obscureText: true,
                    ), //TextFormField
                    new Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      child: new RaisedButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: new Text(Strings.LOGIN_BUTTON),
                          onPressed: _handleSubmit
                      ),
                    ) //RaisedButton
                  ], //Widget
                ), //Container
              ) //Form
          ),
        ) //Container
    ); //Scaffold
  }

  void _handleSubmit() {
    _githubApi.login(_usernameController.text, _passwordController.text)
        .then((success) {
      if (success) {
        Navigator.pushReplacementNamed(context, "/user/repos");
      } else {
        Navigator.pushReplacementNamed(context, "/error");
      }
    });
  }
}



