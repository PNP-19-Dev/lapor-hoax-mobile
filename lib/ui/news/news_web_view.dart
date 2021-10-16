import 'package:flutter/material.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/util/widget/custom_scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatelessWidget {
  static const routeName = '/news_web_view';

  final String id;

  const NewsWebView({required this.id});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: WebView(
        initialUrl: '${LaporhoaxApi.baseUrl}/news/$id',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
