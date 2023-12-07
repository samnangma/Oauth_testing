import 'package:flutter/material.dart';
import 'package:pkce/pkce.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class WebViewExample extends StatefulWidget {
  final String currentUrl;
  final PkcePair pkcePair;

  WebViewExample(this.currentUrl, this.pkcePair);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Webview"),
      ),
      body: WebView(
        initialUrl: widget.currentUrl,
        onWebViewCreated: (WebViewController controller) {
          webViewController = controller;
        },
        onPageStarted: onPageStarted,
        onPageFinished: onPageFinished,
      ),
    );
  }

  Future<void> requestAccessToken(String code, String codeVerifier) async {
    var headers = {
      'Authorization': 'Basic d2ViOnF3ZXJxd2Vy',
    };

    var body = {
      'code': code,
      'grant_type': 'authorization_code',
      'redirect_uri': 'http://127.0.0.1:9090/login/oauth2/code/web',
      'code_verifier': codeVerifier,
    };

    print("Request Body: $body");

    try {
      var response = await http.post(
        Uri.parse('http://139.59.252.233:8080/oauth2/token'),
        headers: headers,
        body: body,
      );

      print("Access Token Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        print("Access Token: ${response.body}");
        // Perform any actions with the access token
      } else {
        print("Error requesting access token: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error requesting access token: ${e.toString()}");
    }
  }

  void onPageStarted(String url) {
    print("Page started loading: $url");
  }

  void onPageFinished(String url) async {
    print("Page finished loading: $url");

    try {
      Uri uri = Uri.parse(url);
      String code = uri.queryParameters['code'] ?? '';

      if (code.isNotEmpty) {
        print("Authorization Code: $code");

        // Use the authorization code to request an access token
        await requestAccessToken(code, widget.pkcePair.codeVerifier);

        // Perform any other actions with the access token or user information
      } else {
        print("Error: Authorization code not found in the URL");
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    }

    // Check if the current URL is the return URL you expect after login
    if (url.startsWith('http://127.0.0.1:9090/login/oauth2/code')) {
      webViewController.clearCache();
      Navigator.pop(context);
    }
  }
}
