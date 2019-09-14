import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:li_webview/li_webview.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  WebController webController;

  void onWebCreated(webController) {
    this.webController = webController;
    this.webController.loadUrl("http://www.google.com");
  }

  @override Widget build(BuildContext context) {
    LiWebView liWebView = new LiWebView(
      onWebCreated: onWebCreated
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hi")
        ),

        body: Container(
          child: liWebView,
          height: 300
        )
      )
    );
  }
}