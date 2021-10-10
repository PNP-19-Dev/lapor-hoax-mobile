import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/data/model/user_token.dart';
import 'package:laporhoax/provider/preferences_provider.dart';
import 'package:laporhoax/ui/account/account_profile.dart';
import 'package:laporhoax/ui/account/login_page.dart';
import 'package:laporhoax/ui/report/history_page.dart';
import 'package:laporhoax/ui/settings/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class AccountPage extends StatefulWidget {
  static const String pageName = 'Akun';

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late PreferencesProvider state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0),
        child: SingleChildScrollView(
          child: Consumer<PreferencesProvider>(
            builder: (context, provider, child) {
              if (provider.isLoggedIn) {
                return onLogin(provider.userData.username);
              } else {
                state = provider;
                return onWelcome();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget onLogin(String username) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/logo.svg',
                height: 80,
                width: 80,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  username,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
              GestureDetector(
                onTap: () {
                  var provider =
                      Provider.of<PreferencesProvider>(context, listen: false);
                  provider.setSessionData(UserToken.empty());
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
            onTap: () => Navigation.intent(AccountProfile.routeName),
          ),
        ),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.history),
            title: Text('Riwayat Pelaporan'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigation.intent(HistoryPage.routeName),
          ),
        ),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Pengaturan'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigation.intent(SettingsPage.routeName),
          ),
        ),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Tentang Laporhoax'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => showAboutDialog(
              context: context,
              applicationIcon: SvgPicture.asset('assets/logo.svg', width: 50),
              applicationName: 'LaporHoax',
              applicationVersion: 'v1.0-alpha',
              children: [
                Text(
                    'Aplikasi ini hasil kerjasama POLDA SUMBAR dengan beberapa stackholder terkait.'),
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.share_rounded),
            title: Text('Bagikan Laporhoax'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Share.share(
                'Ayo berantas hoaks bersama LaporHoax! di https://example.com'),
          ),
        ),
        SizedBox(height: 20),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Syarat Penggunaan',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Text(' | '),
            Text(
              'Kebijakan Pribadi',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
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
              SvgPicture.asset(
                'assets/logo.svg',
                height: 80,
                width: 80,
              ),
              SizedBox(height: 46),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Riwayat Pelaporan'),
                subtitle: Text(
                    'Menyimpan semua laporan yang telah kamu laporkan dan melacak hasilnya'),
                onTap: () {},
              ),
              SizedBox(height: 58),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 25),
          child: SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () => Navigation.intent(LoginPage.routeName),
              child: Text('Login Sekarang'),
            ),
          ),
        ),
        SizedBox(height: 30),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Tentang Laporhoax'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => showAboutDialog(
              context: context,
              applicationIcon: SvgPicture.asset('assets/logo.svg'),
              applicationName: 'LaporHoax',
              applicationVersion: 'v1.0-alpha',
              children: [
                Text(
                    'Aplikasi ini hasil kerjasama POLDA SUMBAR dengan beberapa stackholder terkait.'),
              ],
            ),
          ),
        ),
        Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.share_rounded),
            title: Text('Bagikan LaporHoax'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Share.share(
                'Ayo berantas hoaks bersama LaporHoax! di https://example.com'),
          ),
        ),
        SizedBox(height: 20),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Syarat Penggunaan',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Text(' | '),
            Text(
              'Kebijakan Privasi',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
