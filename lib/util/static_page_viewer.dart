import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laporhoax/util/static_data_web.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StaticPageViewer extends StatefulWidget {
  static const String ROUTE_NAME = '/terms_of_service';

  final StaticDataWeb data;

  StaticPageViewer({required this.data});

  @override
  _StaticPageViewerState createState() => _StaticPageViewerState();
}

class _StaticPageViewerState extends State<StaticPageViewer> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(widget.data.title),
        ),
        body: WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets();
          },
        ));
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle
        .loadString('assets/document/${widget.data.fileName}.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
