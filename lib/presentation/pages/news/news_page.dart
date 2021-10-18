import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/presentation/pages/account/tutorial.dart';
import 'package:laporhoax/presentation/pages/report/report_page.dart';
import 'package:laporhoax/presentation/provider/feed_provider.dart';
import 'package:laporhoax/presentation/widget/item_feed.dart';
import 'package:laporhoax/presentation/widget/toast.dart';
import 'package:laporhoax/util/result_state.dart';
import 'package:provider/provider.dart';

class NewsPage extends StatefulWidget {
  static const String pageName = 'Berita';

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

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
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/logo_new.png', width: 60),
          ),
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
                          onPressed: () =>
                              Navigation.intent(ReportPage.routeName),
                          child: Text('Lapor yuk!'),
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
                onTap: () => Navigation.intent(Tutorial.routeName),
                leading: Icon(Icons.menu_book_sharp),
                title: Text('Tutorial Penggunaan',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    )),
                trailing: Icon(Icons.chevron_right),
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
