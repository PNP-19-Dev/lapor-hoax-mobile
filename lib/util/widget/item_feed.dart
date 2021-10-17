import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/model/feed.dart';
import 'package:laporhoax/provider/database_provider.dart';
import 'package:laporhoax/ui/news/news_web_view.dart';
import 'package:laporhoax/util/datetime_helper.dart';
import 'package:provider/provider.dart';

class ItemFeed extends StatelessWidget {
  const ItemFeed({required this.feed});

  final Feed feed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigation.intentWithData(NewsWebView.routeName, feed),
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
                  feed.title,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                      DateTimeHelper.formattedDate(feed.date),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Ink.image(
                width: double.infinity,
                image: NetworkImage(feed.thumbnail),
                fit: BoxFit.fill,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SaveButton(feed: feed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SaveButton extends StatefulWidget {
  final Feed feed;

  SaveButton({required this.feed});

  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) => FutureBuilder<bool>(
          future: provider.isSaved(widget.feed.id.toString()),
          builder: (context, snapshot) {
            var isSave = snapshot.data ?? false;
            return GestureDetector(
              onTap: () => setState(() {
                isSave = !isSave;
                if (isSave) {
                  provider.saveFeed(widget.feed);
                  toast('Berita disimpan!');
                } else {
                  provider.removeFeed(widget.feed.id.toString());
                  toast('Berita telah dihapus');
                }
              }),
              child: Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Icon(
                  isSave ? Icons.bookmark : Icons.bookmark_outline,
                  color: orangeBlaze,
                ),
              ),
            );
          }),
    );
  }

  toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
