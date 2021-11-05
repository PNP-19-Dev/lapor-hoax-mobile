import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../../data/models/token_id.dart';
import '../../../domain/entities/session_data.dart';
import '../../../utils/navigation.dart';
import '../../../utils/static_data_web.dart';
import '../../provider/user_notifier.dart';
import '../../widget/static_page_viewer.dart';
import '../../widget/toast.dart';
import '../report/history_page.dart';
import 'login_page.dart';
import 'profile_page.dart';

class AccountPage extends StatefulWidget {

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<UserNotifier>(context, listen: false)
      ..getSession()
      ..isLogin());
    getPlatformVersion();
  }

  String _version = '';

  void getPlatformVersion() async {
    final info = await PackageInfo.fromPlatform();
    _version = info.version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0),
        child: SingleChildScrollView(
          child: Consumer<UserNotifier>(
            builder: (context, provider, child) {
              if (provider.sessionData != null) {
                if (provider.isLoggedIn) {
                  return onLogin(provider.sessionData!);
                } else
                  return onWelcome();
              } else {
                return onWelcome();
              }
            },
          ),
        ),
      ),
    );
  }

  void about() {
    showAboutDialog(
      context: context,
      applicationIcon: Image.asset('assets/icons/logo_new.png', width: 50),
      applicationName: 'LAPOR HOAX',
      applicationVersion: _version,
      children: [
        Text(
            'Aplikasi pelaporan hoax yang ditangani langsung oleh pihak yang berwewenang'),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/pnp_logo.png',
              width: 50,
            ),
            Image.asset(
              'assets/icons/polda_sumbar_logo.png',
              width: 50,
            ),
          ],
        ),
      ],
    );
  }

  Widget onLogin(SessionData sessionData) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/logo_new.png',
                height: 80,
                width: 80,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  sessionData.username,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Provider.of<UserNotifier>(context, listen: false)
                      .logout(sessionData);

                  var message =
                      Provider.of<UserNotifier>(context, listen: false)
                          .sessionMessage;

                  if (message == UserNotifier.messageLogout) {
                    Navigation.intent(HOME_ROUTE);
                  } else {
                    toast('ada masalah');
                  }
                },
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 70),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.person_outline_rounded),
            title: Text('Profil'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigation.intentWithData(
                ProfilePage.ROUTE_NAME, sessionData.email),
          ),
        ),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.history),
            title: Text('Riwayat Pelaporan'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigation.intentWithData(
              HistoryPage.ROUTE_NAME,
              TokenId(
                sessionData.userid,
                sessionData.token,
              ),
            ),
          ),
        ),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.bookmark_outline),
            title: Text('Berita Tersimpan'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigation.intent(SAVED_NEWS_ROUTE),
          ),
        ),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Tentang Laporhoax'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => about(),
          ),
        ),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.share_rounded),
            title: Text('Bagikan Laporhoax'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Share.share(
                'Ayo berantas hoaks bersama LaporHoax! di https://s.id/LAPORHOAX'),
          ),
        ),
        SizedBox(height: 20),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigation.intentWithData(
                StaticPageViewer.ROUTE_NAME,
                StaticDataWeb(
                  fileName: 'terms_of_service',
                  title: 'Syarat Penggunaan',
                ),
              ),
              child: Container(
                child: Text(
                  'Syarat Penggunaan',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Text(' | '),
            GestureDetector(
              onTap: () => Navigation.intentWithData(
                StaticPageViewer.ROUTE_NAME,
                StaticDataWeb(
                  fileName: 'privacy_policy',
                  title: 'Kebijakan Privasi',
                ),
              ),
              child: Container(
                child: Text(
                  'Kebijakan Privasi',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget onWelcome() {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Image.asset(
                'assets/icons/logo_new.png',
                height: 80,
                width: 80,
              ),
              SizedBox(height: 46),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 25),
          child: SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () => Navigation.intent(LoginPage.ROUTE_NAME),
              child: Text('Login Sekarang'),
            ),
          ),
        ),
        SizedBox(height: 20),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Tentang Laporhoax'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => about(),
          ),
        ),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.bookmark_outline),
            title: Text('Berita Tersimpan'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigation.intent(SAVED_NEWS_ROUTE),
          ),
        ),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.share_rounded),
            title: Text('Bagikan LaporHoax'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Share.share(
                'Ayo berantas hoaks bersama LaporHoax! di https://s.id/LAPORHOAX'),
          ),
        ),
        SizedBox(height: 20),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigation.intentWithData(
                StaticPageViewer.ROUTE_NAME,
                StaticDataWeb(
                  fileName: 'terms_of_service',
                  title: 'Syarat Penggunaan',
                ),
              ),
              child: Container(
                child: Text(
                  'Syarat Penggunaan',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Text(' | '),
            GestureDetector(
              onTap: () => Navigation.intentWithData(
                StaticPageViewer.ROUTE_NAME,
                StaticDataWeb(
                  fileName: 'privacy_policy',
                  title: 'Kebijakan Privasi',
                ),
              ),
              child: Container(
                child: Text(
                  'Kebijakan Privasi',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
