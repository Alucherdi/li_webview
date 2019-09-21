//
//  SwiftLiWebviewPlugin.swift
//  li_webview
//
//  Created by Cristian Gaviria on 21/09/19.
//

import Flutter
import UIKit
import WebKit

public class WebViewController: NSObject, FlutterPlatformView, FlutterStreamHandler {

    let I_URL = "initialUrl"
    let HEADER = "header"
    let CHANNEL_NAME = "li_webview_%d"
    let CHANNEL = "li_webview_events_%d"

    fileprivate var LiWebView: WKWebView!
    fileprivate var viewId:Int64!;
    fileprivate var channel: FlutterMethodChannel!
    fileprivate var refLiView: UIRefreshControl?

    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger: FlutterBinaryMessenger) {
        super.init()

        if let initWebView =  self.initWebView(frame: frame, args) {
            FlutterEventChannel.init(name: String(format: CHANNEL, viewId),
                                     binaryMessenger: binaryMessenger).setStreamHandler(self)

            self.refLiView = setReload(args, LiWebView: initWebView)
            self.LiWebView = initWebView
            let channelName = String(format: CHANNEL_NAME, viewId)
            self.channel = FlutterMethodChannel(name: channelName, binaryMessenger: binaryMessenger)

            self.channel.setMethodCallHandler({
                [weak self]
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if let this = self {
                    this.onMethodCall(call: call, result: result)
                }
            })
        }
    }

    private func initWebView (frame: CGRect, _ args: Any?) -> WKWebView? {
        if let params = args as? NSDictionary {
            let LiWebView = WKWebView(frame: frame)
            LiWebView.scrollView.bounces = false
            if let url = params[I_URL] as? String,
            let iUrl = URL(string: url) {
                var request = URLRequest(url: iUrl)
                if let header = params[HEADER] as? NSDictionary {
                    for (key, value) in header {
                        if let val = value as? String,
                            let field = key as? String {
                            request.addValue(val, forHTTPHeaderField: field)
                        }
                    }
                }
                LiWebView.load(request)
            }
            return LiWebView
        }
        return nil
    }

    private func setReload(_ args: Any?, LiWebView: WKWebView) -> UIRefreshControl?{
        if let params = args as? NSDictionary {
            let enableReload = params["pullToRefresh"] as? Int ?? 0
            if enableReload == 1 {
                let refLiView = UIRefreshControl()
                refLiView.addTarget(self, action:  #selector(reloadWebView), for: .valueChanged)
                LiWebView.scrollView.addSubview(refLiView)
                return refLiView
            }
        }
        return nil
    }

    private func configJavascript(params: NSDictionary) -> WKWebViewConfiguration{
        let enableJavascript =  1
        let preferences = WKPreferences()
        let configuration = WKWebViewConfiguration()
        preferences.javaScriptEnabled = enableJavascript == 1
        configuration.preferences = preferences
        return configuration
    }

    public func view() -> UIView {
        return LiWebView
    }

    @objc func reloadWebView(){
        refLiView?.endRefreshing()
        LiWebView.reload()
    }


    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let method = FlutterMethodName(rawValue: call.method) {
            if(method == .loadUrl) {
                onLoadURL(call, result)
            }
        }
    }

    func onLoadURL(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let url = call.arguments as? String  {
            if !load(url: url) {
                result(FlutterError(code: "loadURL_faild", message: "faild parsing url", details: "Your [URL] was: \(url)"))
            }else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    func load(url:String)-> Bool {
        if let urlRequest = URL(string: url) {
            LiWebView.load(URLRequest(url: urlRequest))
            return true
        }
        return false
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }

}
