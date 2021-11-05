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
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<UserNotifier>(context, listen: false)
      ..isLogin()
      ..getSession());
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
            builder: (context, data, child) {
              if (data.isLoggedIn) {
                if (data.sessionData != null) {
                  return _OnLogin(data.sessionData!, _version);
                }
                return _OnWelcome(_version);
              } else {
                return _OnWelcome(_version);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final IconData leading;
  final String name;
  final Function() navigate;

  const _Card({
    required this.leading,
    required this.name,
    required this.navigate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(leading),
        title: Text(name),
        trailing: const Icon(Icons.chevron_right),
        onTap: navigate,
      ),
    );
  }
}

class _OnLogin extends StatelessWidget {
  final SessionData sessionData;
  final String version;

  const _OnLogin(this.sessionData, this.version);

  @override
  Widget build(BuildContext context) {
    void about() {
      showAboutDialog(
        context: context,
        applicationIcon: Image.asset('assets/icons/logo_new.png', width: 50),
        applicationName: 'LAPOR HOAX',
        applicationVersion: version,
        children: [
          const Text(
              'Aplikasi pelaporan hoax yang ditangani langsung oleh pihak yang berwewenang'),
          const SizedBox(height: 10),
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
              const SizedBox(width: 16),
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
                    Navigation.intent(homeRoute);
                  } else {
                    toast('ada masalah');
                  }
                },
                child: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 70),
        _Card(
          leading: Icons.person_outline_rounded,
          name: 'Profil',
          navigate: () => Navigation.intentWithData(
              ProfilePage.ROUTE_NAME, sessionData.email),
        ),
        _Card(
          leading: Icons.history,
          name: 'Riwayat Pelaporan',
          navigate: () => Navigation.intentWithData(
            HistoryPage.ROUTE_NAME,
            TokenId(
              sessionData.userid,
              sessionData.token,
            ),
          ),
        ),
        _Card(
          leading: Icons.bookmark_outline,
          name: 'Berita Tersimpan',
          navigate: () => Navigation.intent(savedNewsRoute),
        ),
        _Card(
          leading: Icons.info_outline,
          name: 'Tentang Laporhoax',
          navigate: () => about(),
        ),
        _Card(
          leading: Icons.share_rounded,
          name: 'Bagikan Laporhoax',
          navigate: () => Share.share(
              'Ayo berantas hoaks bersama LaporHoax! di https://s.id/LAPORHOAX'),
        ),
        const SizedBox(height: 20),
        _FooterStatement(),
      ],
    );
  }
}

class _OnWelcome extends StatelessWidget {
  final String version;

  const _OnWelcome(this.version);

  @override
  Widget build(BuildContext context) {
    void about() {
      showAboutDialog(
        context: context,
        applicationIcon: Image.asset('assets/icons/logo_new.png', width: 50),
        applicationName: 'LAPOR HOAX',
        applicationVersion: version,
        children: [
          const Text(
              'Aplikasi pelaporan hoax yang ditangani langsung oleh pihak yang berwewenang'),
          const SizedBox(height: 10),
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
              const SizedBox(height: 46),
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
              child: const Text('Login Sekarang'),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _Card(
          leading: Icons.info_outline,
          name: 'Tentang Laporhoax',
          navigate: () => about(),
        ),
        _Card(
          leading: Icons.bookmark_outline,
          name: 'Berita Tersimpan',
          navigate: () => Navigation.intent(savedNewsRoute),
        ),
        _Card(
          leading: Icons.share_rounded,
          name: 'Bagikan Laporhoax',
          navigate: () => Share.share(
              'Ayo berantas hoaks bersama LaporHoax! di https://s.id/LAPORHOAX'),
        ),
        const SizedBox(height: 20),
        _FooterStatement(),
      ],
    );
  }
}

class _FooterStatement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
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
          child: Text(
            'Syarat Penggunaan',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        const Text(' | '),
        GestureDetector(
          onTap: () => Navigation.intentWithData(
            StaticPageViewer.ROUTE_NAME,
            StaticDataWeb(
              fileName: 'privacy_policy',
              title: 'Kebijakan Privasi',
            ),
          ),
          child: Text(
            'Kebijakan Privasi',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

