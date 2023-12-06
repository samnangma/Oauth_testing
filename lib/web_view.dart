import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String _currentUrl;

  WebViewExample(this._currentUrl);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController _webViewController;

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

          // Check if the current URL contains the authorization code
          try {
            Uri uri = Uri.parse(url);
            String code = uri.queryParameters['code'] ?? '';

            // Handling the extracted authorization code
            if (code.isNotEmpty) {
              print("Authorization Code: $code");

              // Perform actions with the authorization code (e.g., send it to the server)
            } else {
              print("Error: Authorization code not found in the URL");
            }
          } catch (e) {
            print("Error: ${e.toString()}");
          }

          // Check if the current URL is the return URL you expect after login
          if (url.startsWith('http://127.0.0.1:9090/login/oauth2/code')) {
            _webViewController.clearCache();

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
