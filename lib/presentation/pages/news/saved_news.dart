import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/presentation/pages/news/news_web_view.dart';
import 'package:laporhoax/presentation/provider/saved_news_notifier.dart';
import 'package:laporhoax/util/datetime_helper.dart';
import 'package:provider/provider.dart';

class SavedNews extends StatefulWidget {
  static const String ROUTE_NAME = 'saved_news';

  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {
  @override
  void initState() {
    Future.microtask(() =>
        Provider.of<SavedNewsNotifier>(context, listen: false)
            .fetchSavedFeeds());
    super.initState();
  }

  void refreshData() {
    Future.microtask(() =>
        Provider.of<SavedNewsNotifier>(context, listen: false)
            .fetchSavedFeeds());
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  List<Feed> news = [];

  Widget _feedCard(Feed feed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.pushNamed(
              context, NewsWebView.ROUTE_NAME,
              arguments: feed.id).then(onGoBack);
          setState(() {
            print('PrintResult ${result.runtimeType}');
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFBABABA),
                blurRadius: 2.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 2.0),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Hero(
                  tag: feed.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: CachedNetworkImage(
                      imageUrl: feed.thumbnail!,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 100,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: _description(
                  feed.title!,
                  feed.date!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _description(String title, String date) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Color(0xFFBABABA),
              ),
              Text(
                DateTimeHelper.formattedDate(date),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Color(0xFFBABABA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
                  return _feedCard(news[index]);
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
