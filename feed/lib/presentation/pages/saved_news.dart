import 'dart:async';

import 'package:core/domain/entities/feed.dart';
import 'package:core/utils/route_observer.dart';
import 'package:core/utils/state_enum.dart';
import 'package:feed/presentation/widget/feed_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../presentation/provider/saved_news_notifier.dart';

class SavedNews extends StatefulWidget {
  static const String ROUTE_NAME = '/saved_news';

  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> with RouteAware {
  @override
  void initState() {
    Future.microtask(() =>
        Provider.of<SavedNewsNotifier>(context, listen: false)
            .fetchSavedFeeds());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<SavedNewsNotifier>(context, listen: false).fetchSavedFeeds();
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
            if (data.feedListState == RequestState.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.feedListState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  news = data.saveListFeeds;
                  return FeedCard(news[index]);
                },
                itemCount: data.saveListFeeds.length,
              );
            } else if (data.feedListState == RequestState.empty) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
