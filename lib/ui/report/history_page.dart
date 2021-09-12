import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laporhoax/common/navigation.dart';

class HistoryPage extends StatelessWidget {
  static String routeName = '/history_name';

  @override
  Widget build(BuildContext context) {
    void showPrompt(BuildContext context) => showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Center(
                    child:
                        Text('Jenis Kategori', style: TextStyle(fontSize: 18))),
                Text('URL'),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Belum Ditindak',
                        style: TextStyle(
                          color: Color(0xFFFF3333),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.trash),
                    ),
                  ],
                ),
              ],
            );
          },
        );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigation.back(),
                    child: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Riwayat',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                GestureDetector(
                  onTap: () => showPrompt(context),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.link),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kategori Laporan'),
                                Text('12:15 WIB | 13 Agus 2021')
                              ],
                            ),
                          ),
                          Text(
                            'Belum Ditindak',
                            style: TextStyle(
                                color: Color(0xFFFF3333),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.image),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Kategori Laporan'),
                              Text('12:15 WIB | 13 Agus 2021')
                            ],
                          ),
                        ),
                        Text(
                          'Sudah Ditindak',
                          style: TextStyle(
                              color: Color(0xFF4BB543),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
