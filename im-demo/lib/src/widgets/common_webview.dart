import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../res/styles.dart';

///代码清单
class CommonWebViewPage extends StatefulWidget {
  final String htmlUrl;
  final String pageTitle;

  CommonWebViewPage({required this.htmlUrl, this.pageTitle = ""});

  @override
  _CommonWebViewPageState createState() => _CommonWebViewPageState();
}

class _CommonWebViewPageState extends State<CommonWebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PageStyle.c_008069,
        elevation: 0.5,
        title: Text("${widget.pageTitle}"),
      ),
      backgroundColor: Colors.white,
      body: WebView(
        initialUrl: widget.htmlUrl,
      ),
    );
  }
}
