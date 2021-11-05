import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/feed.dart';
import 'package:core/utils/datetime_helper.dart';
import 'package:feed/presentation/pages/news_web_view.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatelessWidget {
  final Feed feed;

  const FeedCard(this.feed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, NewsWebView.ROUTE_NAME,
            arguments: feed.id),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: const [
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
                      placeholder: (_, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (_, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: _Description(
                  title: feed.title!,
                  date: feed.date!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    Key? key,
    required this.title,
    required this.date,
  }) : super(key: key);

  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: Color(0xFFBABABA),
              ),
              Text(
                DateTimeHelper.formattedDate(date),
                style: Theme.of(context).textTheme.overline,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
