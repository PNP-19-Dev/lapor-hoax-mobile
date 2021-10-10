import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/provider/feed_provider.dart';
import 'package:laporhoax/ui/news/news_web_view.dart';
import 'package:laporhoax/ui/report/lapor_page.dart';
import 'package:laporhoax/util/datetime_helper.dart';
import 'package:laporhoax/util/result_state.dart';
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

  Widget buildCard(String title, String imageUrl, String timeStamp, String id) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: GestureDetector(
        onTap: () => Navigation.intentWithData(NewsWebView.routeName, id),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Stack(
              alignment: Alignment.bottomLeft,
              fit: StackFit.passthrough,
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          softWrap: true,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              timeStamp + ' WIB',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Ink.image(
                  width: double.infinity,
                  image: NetworkImage('${LaporhoaxApi.baseUrl}$imageUrl'),
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: IconButton(
                          icon: Icon(
                            Icons.bookmark_outline,
                            color: orangeBlaze,
                          ),
                          onPressed: () {}),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  Widget _buildFeedItem() {
    return Consumer<FeedProvider>(builder: (context, provider, widget) {
      if (provider.state == ResultState.Loading) {
        return Center(child: CircularProgressIndicator());
      } else if (provider.state == ResultState.HasData) {
        var feeds = provider.feeds;
        return ListView.builder(
          itemCount: provider.count,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var feed = feeds.results[index];
            return buildCard(
              feed.title,
              feed.thumbnail,
              DateTimeHelper.formattedDateTime(feed.date),
              feed.id.toString(),
            );
          },
        );
      } else if (provider.state == ResultState.NoData) {
        return Center(child: Text('Empty List'));
      } else {
        toast('No Connection!');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              children: [
                SvgPicture.asset('assets/logo.svg', width: 46),
                SizedBox(width: 7),
                Expanded(
                  child: Text('Anti - Hoax',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.notifications_none,
                    color: orangeBlaze,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              borderOnForeground: true,
              color: orange200,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
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
                    ElevatedButton(
                      onPressed: () => Navigation.intent(LaporPage.routeName),
                      child: Text('Lapor yuk!'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Berita',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            height: 250,
            child: _buildFeedItem(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Edukasi',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            height: 250,
            child: _buildFeedItem(),
          ),
        ],
      ),
    );
  }
}
