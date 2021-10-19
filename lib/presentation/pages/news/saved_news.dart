import 'package:flutter/material.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/presentation/provider/saved_feed_notifier.dart';
import 'package:laporhoax/presentation/widget/simple_item_feed.dart';
import 'package:provider/provider.dart';

class SavedNews extends StatefulWidget {
  static const String routeName = 'saved_news';

  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SavedFeedNotifier>(context, listen: false).fetchFeeds());
  }

  Widget _buildNewsItem() {
    return Consumer<SavedFeedNotifier>(builder: (context, provider, child) {
      if (provider.feedState == RequestState.Loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.feedState == RequestState.Loaded) {
        return Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
                itemCount: provider.feeds.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var news = provider.feeds[index];
                  return SimpleItemFeed(feed: news);
                }),
          ),
        );
      } else {
        return Center(child: Text(provider.message));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Berita yang tersimpan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildNewsItem(),
      ),
    );
  }
}
