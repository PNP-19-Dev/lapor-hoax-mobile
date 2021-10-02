import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/ui/account/account_page.dart';
import 'package:laporhoax/ui/news/news_page.dart';
import 'package:laporhoax/ui/report/lapor_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.newspaper), label: 'Berita'),
    BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user), label: 'Akun'),
  ];

  List<Widget> _listWidget = [
    NewsPage(),
    AccountPage(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: Key("home_page_scaffold"),
        body: _listWidget[_bottomNavIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _bottomNavIndex,
          items: _bottomNavBarItems,
          onTap: _onBottomNavTapped,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Tambah Laporan',
          onPressed: () {
            Navigation.intent(LaporPage.routeName);
          },
        ),
      ),
    );
  }
}
