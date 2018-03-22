import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:githubdashboard/github/constant/Strings.dart';

class CopyRightScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: const Text(Strings.COPYRIGHT_APPBAR_TITLE),
      ),
      body: new Markdown(data: Strings.COPYRIGHT_CONTENT,),
    );
  }

}