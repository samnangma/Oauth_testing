import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {

  String _currentUrl;

  WebViewExample(this._currentUrl);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController _webViewController;
  String _currentUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Webview"),
      ),
      body: WebView(
        initialUrl: widget._currentUrl, // Replace with your initial URL
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        onPageStarted: (String url) {
          // This callback is called when the WebView starts loading a new page
          print("Page started loading: $url");
        },
        onPageFinished: (String url) {
          // This callback is called when the WebView finishes loading a page
          print("Page finished loading: $url");

          // Check if the current URL is the return URL you expect after login
          if (url.startsWith('http://127.0.0.1:9090/login/oauth2/code')) {
            setState(() {
              _currentUrl = url;
            });

            _webViewController.clearCache();

            Navigator.pop(context);
          }
        },
      )
    );
  }
}