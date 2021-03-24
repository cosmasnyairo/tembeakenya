import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tembea_kenya/widgets/error.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebview extends StatefulWidget {
  final String url;
  final String title;

  const MyWebview({Key key, this.url, this.title}) : super(key: key);

  @override
  MyWebviewState createState() => MyWebviewState();
}

class MyWebviewState extends State<MyWebview> {
  bool _erroroccurred = false;
  bool _isloading = false;
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _erroroccurred
          ? ErrorPage(
              ontap: () async {
                setState(() => _erroroccurred = false);
                showwebview();
              },
              devicespecs: MediaQuery.of(context).size,
            )
          : Stack(children: [
              showwebview(),
              _isloading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox()
            ]),
    );
  }

  WebView showwebview() {
    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (val) => setState(() => _isloading = true),
      onPageFinished: (val) => setState(() => _isloading = false),
    );
  }
}
