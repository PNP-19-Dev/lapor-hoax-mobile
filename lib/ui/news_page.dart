import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
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
/*
                  Hero(
                    tag: jurusan,
                    child: Ink.image(
                      height: 200,
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
*/
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
                    Text('Halo, user',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                Icon(Icons.search),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Berita Utama',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
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
            child: Text('Berita Terbaru',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                )),
          ),
          Card(
            child: ListTile(
              leading: Container(color: Color(0xFFBABABA), width: 50),
              subtitle: Text('Hello'),
              title: Text('Hello'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Container(color: Color(0xFFBABABA), width: 50),
              subtitle: Text('Hello'),
              title: Text('Hello'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Container(color: Color(0xFFBABABA), width: 50),
              subtitle: Text('Hello'),
              title: Text('Hello'),
            ),
          ),
        ],
      ),
    );
  }
}
