/*
 * Created by andii on 14/11/21 01.40
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 13/11/21 21.53
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/presentation/pages/report/report_page.dart';
import 'package:laporhoax/presentation/pages/static/tutorial_page.dart';
import 'package:laporhoax/presentation/provider/feed_cubit.dart';
import 'package:laporhoax/styles/colors.dart';
import 'package:laporhoax/utils/datetime_helper.dart';
import 'package:laporhoax/utils/navigation.dart';
import 'package:provider/provider.dart';

import 'news_web_view.dart';

class NewsPage extends StatefulWidget {
  static const String pageName = 'Berita';

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<FeedCubit>().fetchFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text(
            'LAPOR HOAX',
            style: Theme.of(context).textTheme.headline5!,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/logo_new.png', width: 60),
          ),
/*          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none,
                color: orangeBlaze,
              ),
            ),
          ],*/
        ),
        SliverToBoxAdapter(
          child: _BannerCard(),
        ),
        BlocBuilder<FeedCubit, FeedState>(
          builder: (context, state) {
            if (state is FeedLoading) {
              return SliverToBoxAdapter(
                key: Key('loading_widget'),
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            } else if (state is FeedHasData) {
              return _FeedList(
                state.data,
                key: Key('home_feed_items'),
              );
            } else if (state is FeedError) {
              return SliverList(
                key: Key('home_feed_error'),
                delegate: SliverChildListDelegate([
                  SizedBox(height: 100),
                  Icon(
                    Icons.error,
                    size: 30,
                    color: grey200,
                  ),
                  Text(
                    '${state.message}',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                ]),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}

class _FeedList extends StatelessWidget {
  final List<Feed> feeds;

  _FeedList(this.feeds, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    fit: StackFit.passthrough,
                    children: [
                      CachedNetworkImage(
                        imageUrl: feed.thumbnail!,
                        placeholder: (_, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (_, url, error) => Icon(Icons.error),
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
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
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
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
                            Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              DateTimeHelper.formattedDate(feed.date!),
                              style: Theme.of(context)
                                  .textTheme
                                  .overline!
                                  .copyWith(
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

class _BannerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Card(
            borderOnForeground: true,
            color: orange200,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Udah nemuin \nHoax?',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigation.intent(ReportPage.ROUTE_NAME),
                        child: Text(
                          'Lapor yuk!',
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: Colors.white),
                        ),
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
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Card(
            elevation: 4,
            clipBehavior: Clip.hardEdge,
            child: ListTile(
              onTap: () => Navigation.intent(TutorialPage.ROUTE_NAME),
              leading: Icon(Icons.menu_book_sharp),
              title: Text(
                'Tutorial Penggunaan',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Berita',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }
}
