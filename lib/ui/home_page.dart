import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/ui/account/account_page.dart';
import 'package:laporhoax/ui/news/news_page.dart';
import 'package:laporhoax/ui/report/lapor_page.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  int _bottomNavIndex = 0;

  _HomePageState() {
    messaging.getToken().then((value) => print('token: $value'));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: 'logo_new_mini',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      //
    });
  }

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
