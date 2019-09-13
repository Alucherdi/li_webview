import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:li_webview/li_webview.dart';

void main() {
  const MethodChannel channel = MethodChannel('li_webview');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await LiWebview.platformVersion, '42');
  });
}
