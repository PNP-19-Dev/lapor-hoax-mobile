import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/presentation/provider/saved_news_notifier.dart';
import 'package:laporhoax/presentation/widget/feed_card.dart';
import 'package:laporhoax/util/datetime_helper.dart';
import 'package:provider/provider.dart';

import 'news_web_view.dart';

class SavedNews extends StatefulWidget {
  static const String ROUTE_NAME = 'saved_news';

  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {
  @override
  void initState() {
    Provider.of<SavedNewsNotifier>(context, listen: false).fetchSavedFeeds();
    super.initState();
  }

  List<Feed> news = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: Text('Berita yang tersimpan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<SavedNewsNotifier>(
          builder: (context, data, child) {
            if (data.feedListState == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.feedListState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  news = data.saveListFeeds;
                  return FeedCard(news[index]);
                },
                itemCount: data.saveListFeeds.length,
              );
            } else if (data.feedListState == RequestState.Empty) {
              return Center(
                  key: Key('error_message'), child: Text(data.message));
            } else {
              return Center(
                  key: Key('error_message'), child: Text(data.message));
            }
          },
        ),
      ),
    );
  }
}
