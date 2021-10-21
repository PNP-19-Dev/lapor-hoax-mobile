import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laporhoax/data/datasources/remote_data_source.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/presentation/pages/news/news_page.dart';
import 'package:laporhoax/presentation/provider/feed_notifier.dart';
import 'package:laporhoax/presentation/widget/custom_scaffold.dart';
import 'package:provider/provider.dart';
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
        initialUrl: '${RemoteDataSourceImpl.baseUrl}/news/${feed.id}',
        javascriptMode: JavascriptMode.unrestricted,
      ),
      children: [
        Consumer<FeedNotifier>(
            builder: (context, data, child) =>
                SaveButton(feed, data.isFeedSaved)),
        IconButton(
          onPressed: () => Share.share(
              'Ada berita di laporhoax ${RemoteDataSourceImpl.baseUrl}/news/${feed.id}'),
          icon: SvgPicture.asset('assets/icons/share.svg'),
        )
      ],
    );
  }
}
