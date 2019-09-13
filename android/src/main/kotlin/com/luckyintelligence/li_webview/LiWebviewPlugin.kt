package com.luckyintelligence.li_webview

import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class LiWebviewPlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "li_webview")
      channel.setMethodCallHandler(LiWebviewPlugin())
    }
  }

  fun getWebView(registrar: Registrar): WebView {
    val webView = WebView(registrar.context())
    webView.setWebViewClient(WebViewClient());
    webView.getSettings().javaScriptEnabled = true

    return webView
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "testMethod" -> result.success("Test method confirmed")
      "webView" -> {
        val url = call.arguments.toString()
      }
      else -> result.notImplemented()
    }
  }
}