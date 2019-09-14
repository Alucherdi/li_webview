import 'dart:async';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


typedef void WebViewCreatedCallback(WebController controller);

class LiWebView extends StatefulWidget {
  final WebViewCreatedCallback onWebCreated;

  LiWebView({
    Key key,
    @required this.onWebCreated
  });

  @override
  _LiWebView createState() => _LiWebView();
}

class _LiWebView extends State<LiWebView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: "li_webview",
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec()
      );
    } // TODO: Aquí va el código del UiKitView (iOS)

    return Text("Not supported device");
  }

  Future<void> onPlatformViewCreated(id) async {
    if (widget.onWebCreated == null) {
      return;
    }

    widget.onWebCreated(new WebController.init(id));
  }


}

class WebController {
  MethodChannel _channel;

  WebController.init(int id) {
    _channel =  new MethodChannel('li_webview_$id');
  }

  Future<void> loadUrl(String url) async {
    assert(url != null);
    return _channel.invokeMethod('loadUrl', url);
  }
}
