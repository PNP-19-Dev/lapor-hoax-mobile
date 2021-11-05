import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/domain/entities/feed.dart';
import 'package:core/styles/colors.dart';
import 'package:core/utils/datetime_helper.dart';
import 'package:core/utils/navigation.dart';
import 'package:core/utils/routes.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/feed_notifier.dart';
import 'news_web_view.dart';

class NewsPage extends StatefulWidget {
  static const String pageName = 'Berita';

  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<FeedNotifier>(context, listen: false).fetchFeeds()
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text('LAPOR HOAX',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              )),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/logo_new.png', width: 60),
          ),
          actions: const [
            /*TODO: ADDING NOTIFICATION
               IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none,
                color: orangeBlaze,
              ),
            ),*/
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Card(
              borderOnForeground: true,
              color: orange200,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Udah nemuin \nHoax?',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )),
                        ElevatedButton(
                          onPressed: () => Navigation.intent(reportRoute),
                          child: const Text('Lapor yuk!'),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/illustration/reporting_illust.svg',
                      width: 120,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Card(
              child: ListTile(
                onTap: () => Navigation.intent(tutorialRoute),
                leading: const Icon(Icons.menu_book_sharp),
                title: Text('Tutorial Penggunaan',
                    style: Theme.of(context).textTheme.subtitle2),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Berita',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        // _buildFeedItem(),
        Consumer<FeedNotifier>(
          builder: (context, data, child) {
            final state = data.feedState;
            if (state == RequestState.loading) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state == RequestState.loaded) {
              return FeedList(data.feeds);
            } else {
              return SliverList(
                delegate: SliverChildListDelegate([
                  const Icon(
                    Icons.error,
                    size: 30,
                    color: grey200,
                  ),
                  Text(
                    'Something Went wrong',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(data.message),
                ]),
              );
            }
          },
        ),
      ],
    );
  }
}

class FeedList extends StatelessWidget {
  final List<Feed> feeds;

  const FeedList(this.feeds, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          var feed = feeds[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () =>
                  Navigation.intentWithData(NewsWebView.ROUTE_NAME, feed.id),
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    fit: StackFit.passthrough,
                    children: [
                      CachedNetworkImage(
                        imageUrl: feed.thumbnail!,
                        placeholder: (_, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (_, url, error) => const Icon(Icons.error),
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black, Color(0x05000000)],
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              left: 10, right: 49, bottom: 8, top: 8),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        right: 0,
                        bottom: 35,
                        child: Text(
                          feed.title!,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 0,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateTimeHelper.formattedDate(feed.date!),
                              style: Theme.of(context).textTheme.overline!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: feeds.length,
      ),
    );
  }
}
