import 'package:flutter/material.dart';
import 'package:laporhoax/presentation/provider/database_provider.dart';
import 'package:laporhoax/presentation/widget/simple_item_feed.dart';
import 'package:laporhoax/util/result_state.dart';
import 'package:provider/provider.dart';

class SavedNews extends StatefulWidget {
  static const String routeName = 'saved_news';

  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {
  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildNewsItem() {
    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      if (provider.state == ResultState.HasData) {
        return Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
                itemCount: provider.news.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var news = provider.news[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: SimpleItemFeed(feed: news),
                  );
                }),
          ),
        );
      } else {
        return Expanded(child: Center(child: Text(provider.message)));
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
      body: Column(
        children: [
          _buildNewsItem(),
        ],
      ),
    );
  }
}
