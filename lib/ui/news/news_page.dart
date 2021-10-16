import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/provider/feed_provider.dart';
import 'package:laporhoax/ui/report/lapor_page.dart';
import 'package:laporhoax/util/result_state.dart';
import 'package:laporhoax/util/widget/item_feed.dart';
import 'package:provider/provider.dart';

class NewsPage extends StatefulWidget {
  static const String pageName = 'Berita';

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  Widget _buildFeedItem() {
    return Consumer<FeedProvider>(builder: (context, provider, widget) {
      if (provider.state == ResultState.Loading) {
        return SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()));
      } else if (provider.state == ResultState.HasData) {
        var feeds = provider.feeds;
        return SliverGrid(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              var feed = feeds.results[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ItemFeed(feed: feed),
              );
            },
            childCount: provider.count,
          ),
        );
      } else if (provider.state == ResultState.NoData) {
        return SliverToBoxAdapter(child: Text('Empty List'));
      } else {
        toast('No Connection!');
        return SliverList(
          delegate: SliverChildListDelegate([
            Icon(
              Icons.error,
              size: 30,
              color: grey200,
            ),
            Text(
              'Something Went wrong',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text('${provider.message}'),
          ]),
        );
      }
    });
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
          leading: Image.asset('assets/icons/logo_new.png', width: 60),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none,
                color: orangeBlaze,
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              borderOnForeground: true,
              color: orange200,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Udah nemuin \nHoax?',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )),
                        Text(
                          'Kalo kamu nemuin hoax, kasi tau \nkami lewat tombol di bawah ini ya!',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: grey600,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  Navigation.intent(LaporPage.routeName),
                              child: Text('Lapor yuk!'),
                            ),
                            SizedBox(width: 5),
                            OutlinedButton(
                              onPressed: () {},
                              child: Text('Tutorial'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/reporting_illust.svg',
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Berita',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        _buildFeedItem(),
      ],
    );
  }
}
