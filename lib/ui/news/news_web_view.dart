import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/feed.dart';
import 'package:laporhoax/util/widget/custom_scaffold.dart';
import 'package:laporhoax/util/widget/item_feed.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatelessWidget {
  static const routeName = '/news_web_view';

  final Feed feed;

  const NewsWebView({required this.feed});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: WebView(
        initialUrl: '${LaporhoaxApi.baseUrl}/news/${feed.id}',
        javascriptMode: JavascriptMode.unrestricted,
      ),
      children: [
        SaveButton(feed: feed),
        IconButton(
          onPressed: () => Share.share(
              'Ada berita di laporhoax ${LaporhoaxApi.baseUrl}/news/${feed.id}'),
          icon: SvgPicture.asset('assets/icons/share.svg'),
        )
      ],
    );
  }
}
