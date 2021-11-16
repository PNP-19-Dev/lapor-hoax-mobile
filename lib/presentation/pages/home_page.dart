/*
 * Created by andii on 16/11/21 01.03
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 00.12
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laporhoax/presentation/pages/account/account_page.dart';
import 'package:laporhoax/presentation/pages/news/news_page.dart';
import 'package:laporhoax/presentation/pages/report/report_page.dart';
import 'package:laporhoax/utils/navigation.dart';

class HomePage extends StatefulWidget {
  static const ROUTE_NAME = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.newspaper), label: NewsPage.pageName),
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.user), label: AccountPage.pageName),
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
    return Scaffold(
      key: Key("home_page_scaffold"),
      body: SafeArea(child: _listWidget[_bottomNavIndex]),
      bottomNavigationBar: BottomNavigationBar(
        key: Key('bottom_bar'),
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        key: Key('fab_add_report'),
        child: Icon(Icons.add),
        tooltip: 'Tambah Laporan',
        onPressed: () => Navigation.intent(ReportPage.ROUTE_NAME),
      ),
    );
  }
}
