import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laporhoax/common/theme.dart';

class TutorialPage extends StatefulWidget {
  static const String ROUTE_NAME = '/tutorial_page';

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Tutorial Penggunaan'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: itemData.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionPanelList(
              animationDuration: Duration(milliseconds: 1000),
              dividerColor: Colors.red,
              elevation: 1,
              children: [
                ExpansionPanel(
                  body: Container(
                    padding: EdgeInsets.all(10),
                    child: itemData[index].child,
                  ),
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        itemData[index].headerItem,
                        style: TextStyle(
                          color: itemData[index].colorsItem,
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                  isExpanded: itemData[index].expanded,
                )
              ],
              expansionCallback: (int item, bool status) {
                setState(() {
                  itemData[index].expanded = !itemData[index].expanded;
                });
              },
            );
          },
        ),
      ),
    );
  }

  static const String _localPath = 'assets/tutorial_assets';

  List<_ItemModel> itemData = <_ItemModel>[
    _ItemModel(
      headerItem: 'Cara Memberikan Laporan',
      colorsItem: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bagi Bagi kamu yang telah mendapatkan laporan dan masih bingung apa yang harus dilakukan, bisa dengan mengikuti langkah di bawah ini :',
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 5),
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
            Text('a. Klik tombol '),
            SvgPicture.asset('$_localPath/btn_lapor.svg'),
            Text(' pada halaman home'),
          ]),
          Image.asset('$_localPath/tutorial1.png'),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'atau bisa juga dengan klik icon ',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                WidgetSpan(
                  child: SvgPicture.asset('$_localPath/btn_add_report.svg'),
                ),
                TextSpan(
                  text: ' pada navbar di bawah',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'b. Sebelum melakukan pelaporan, kamu diharapkan untuk login terlebih dahulu',
            textAlign: TextAlign.justify,
          ),
          Image.asset('$_localPath/tutorial2.png'),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text:
                      'c. Setelah login, maka kamu dapat melakukan pelaporan sesuai dengan form yang telah tersedia. Tekan tombol ',
                ),
                WidgetSpan(
                  child: SvgPicture.asset('$_localPath/btn_lapor_form.svg',
                      width: 50),
                ),
                TextSpan(
                  text: ' untuk mengirimkan laporan.',
                ),
              ],
            ),
          ),
          Image.asset('$_localPath/tutorial3.png'),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text:
                      'd. Laporanmu berhasil dikirimkan! Kamu dapat melihat laporan yang telah terkirim di',
                ),
                TextSpan(
                  text: ' Lihat laporan yang barusan',
                  style: TextStyle(
                    color: orangeBlaze,
                  ),
                ),
              ],
            ),
          ),
          Image.asset('$_localPath/report_success.png'),
          SizedBox(height: 10),
        ],
      ),
    ),
    _ItemModel(
      headerItem: 'Cara ResetPassword',
      colorsItem: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apabila kamu lupa password dan masih bingung bagaimana cara mengatasinya, bisa dengan melakukan beberapa langkah, sebagai berikut.',
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 5),
          RichText(
            text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'a. Tekan tombol ',
                  ),
                  TextSpan(
                    text: 'Lupa password',
                    style: TextStyle(
                      color: orangeBlaze,
                    ),
                  ),
                  TextSpan(text: ' yang ada di halaman login.'),
                ]),
          ),
          Image.asset('$_localPath/forgot_psw1.png'),
          RichText(
            text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                      text:
                          'b. Isilah jawaban dari pertanyaan rahasia yang telah ditentukan sewaktu mendaftarkan akun. Apabila kamu lupa akan jawabannya, masih bisa diganti kok dengan pertanyaan lain dengan menekan tombol '),
                  TextSpan(
                    text: 'Ganti Pertanyaan',
                    style: TextStyle(
                      color: orangeBlaze,
                    ),
                  ),
                ]),
          ),
          Image.asset('$_localPath/forgot_psw2.png'),
          RichText(
            text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                      text:
                          'c. Setelah menjawab pertanyaan rahasia, maka kamu akan dikirimkan kata sandi acak yang akan digunakan pada form '),
                  TextSpan(
                    text: 'Kata Sandi dari Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
          ),
          Image.asset('$_localPath/forgot_psw3.png'),
          RichText(
            text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'd. Selamat! ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                      text:
                          'passwordmu berhasil diganti, silakan login dengan password yang telah diganti.'),
                ]),
          ),
        ],
      ),
    ),
  ];
}

class _ItemModel {
  bool expanded;
  String headerItem;
  Widget child;
  Color colorsItem;

  _ItemModel({
    this.expanded: false,
    required this.headerItem,
    required this.child,
    required this.colorsItem,
  });
}
