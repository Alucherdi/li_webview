import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class LiWebview {
  static const MethodChannel _channel =
      const MethodChannel('li_webview');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Widget> testMethod() async {
    String text = await _channel.invokeMethod("testMethod");

    return Text(text);
  }
}
