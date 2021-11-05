import 'package:core/data/datasources/remote_data_source.dart';
import 'package:core/domain/entities/feed.dart';
import 'package:core/styles/colors.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../presentation/provider/news_detail_notifier.dart';

class NewsWebViewData {
  final id;

  NewsWebViewData(this.id);
}

class NewsWebView extends StatefulWidget {
  static const ROUTE_NAME = '/news_web_view';

  final int id;

  const NewsWebView({required this.id});

  _NewsWebViewState createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NewsDetailNotifier>(context, listen: false)
          .fetchFeedDetail(widget.id);
      Provider.of<NewsDetailNotifier>(context, listen: false)
          .loadFeedStatus(widget.id);
    });
  }

  final _key = UniqueKey();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Stack(
        children: [
          WebView(
            key: _key,
            initialUrl: '${RemoteDataSourceImpl.baseUrl}/news/${widget.id}',
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}

class CustomScaffold extends StatelessWidget {
  final Widget body;

  CustomScaffold({required this.body});

  Widget _buildShortAppBar(
      BuildContext context, Feed feed, bool isAddedToFeedlist) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(0),
      child: Container(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Text(
                'Berita',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    if (!isAddedToFeedlist) {
                      await Provider.of<NewsDetailNotifier>(
                        context,
                        listen: false,
                      ).storeFeed(feed);
                    } else {
                      await Provider.of<NewsDetailNotifier>(
                        context,
                        listen: false,
                      ).deleteFeed(feed);
                    }

                    final message =
                        Provider.of<NewsDetailNotifier>(context, listen: false)
                            .saveMessage;

                    if (message == NewsDetailNotifier.feedSavedMessage ||
                        message == NewsDetailNotifier.feedRemovedMessage) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message)));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(message),
                            );
                          });
                    }
                  },
                  icon: isAddedToFeedlist
                      ? Icon(Icons.bookmark, color: orangeBlaze)
                      : Icon(Icons.bookmark_outline, color: orangeBlaze),
                ),
                IconButton(
                  onPressed: () => Share.share(
                      'Ada berita di laporhoax ${RemoteDataSourceImpl.baseUrl}/pages/${feed.id}'),
                  icon: SvgPicture.asset('assets/icons/share.svg'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NewsDetailNotifier>(builder: (context, data, child) {
        if (data.feedState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.feedState == RequestState.Loaded) {
          return SafeArea(
            child: Stack(
              children: [
                body,
                _buildShortAppBar(context, data.feed, data.isAddedtoSavedFeed),
              ],
            ),
          );
        } else {
          return Center(child: Text(data.message));
        }
      }),
    );
  }
}
