import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laporhoax/provider/laporhoax_provider.dart';
import 'package:laporhoax/util/result_state.dart';
import 'package:provider/provider.dart';

class NewsPage extends StatefulWidget {
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

  Widget buildCard(String jurusan, String imageUrl, String deskripsi) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 2, left: 8, right: 8, bottom: 2),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      jurusan,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Color(0xFFBABABA),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      deskripsi,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
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
    return Consumer<LaporhoaxProvider>(builder: (context, provider, widget) {
      if (provider.state == ResultState.Loading) {
        return Expanded(child: Center(child: CircularProgressIndicator()));
      } else if (provider.state == ResultState.HasData) {
        var feeds = provider.feed;
        return Expanded(
          child: ListView.builder(
            itemCount: provider.feed.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var feed = feeds[index];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    'https://laporhoaxpolda.herokuapp.com/${feed.thumbnail}',
                    width: 50,
                  ),
                  subtitle: Text(truncateWithEllipsis(10, feed.content)),
                  title: Text(feed.title),
                ),
              );
            },
          ),
        );
      } else if (provider.state == ResultState.NoData) {
        return Expanded(child: Center(child: Text('Empty List')));
      } else {
        toast('No Connection!');
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  size: 30,
                  color: Color(0xFFBDBDBD),
                ),
                Text(
                  'Something Went wrong',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(33)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFBABABA),
                        ),
                        height: 55,
                        width: 55,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Halo, user',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
                Icon(Icons.search),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Berita Utama',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                buildCard("Hello", "", "Apa itu hoax?"),
                buildCard("Hello", "", "Berita 2"),
                buildCard("Hello", "", "Berita 3"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Berita Terbaru',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}
