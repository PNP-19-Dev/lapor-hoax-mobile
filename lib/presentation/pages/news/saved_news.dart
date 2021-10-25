import 'package:flutter/material.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/presentation/provider/saved_news_notifier.dart';
import 'package:laporhoax/presentation/widget/feed_card.dart';
import 'package:provider/provider.dart';

class SavedNews extends StatefulWidget {
  static const String ROUTE_NAME = 'saved_news';

  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SavedNewsNotifier>(context, listen: false)
            .fetchSavedFeeds());
  }

  Widget _buildNewsItem() {
    return Consumer<SavedNewsNotifier>(builder: (context, data, child) {
      if (data.feedListState == RequestState.Loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (data.feedListState == RequestState.Loaded) {
        return ListView.builder(
          itemBuilder: (context, index) {
            var news = data.saveListFeeds[index];
            return FeedCard(news);
          },
          itemCount: data.saveListFeeds.length,
        );
      } else if (data.feedListState == RequestState.Empty) {
        return Center(key: Key('error_message'), child: Text(data.message));
      } else {
        return Center(key: Key('error_message'), child: Text(data.message));
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
