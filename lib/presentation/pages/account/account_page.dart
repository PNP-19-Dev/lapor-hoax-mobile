/*
 * Created by andii on 15/11/21 13.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 15/11/21 12.55
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/presentation/pages/home_page.dart';
import 'package:laporhoax/presentation/pages/news/saved_news.dart';
import 'package:laporhoax/presentation/pages/report/history_page.dart';
import 'package:laporhoax/presentation/pages/static/about_page.dart';
import 'package:laporhoax/presentation/pages/static/static_page_viewer.dart';
import 'package:laporhoax/presentation/provider/account_cubit.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/presentation/widget/toast.dart';
import 'package:laporhoax/styles/theme.dart';
import 'package:laporhoax/utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'login_page.dart';
import 'profile_page.dart';

class AccountPage extends StatefulWidget {
  static const String pageName = 'Akun';

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccountCubit>().fetchSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0),
        child: BlocBuilder<AccountCubit, AccountState>(
          builder: (_, state) {
            if (state is AccountLogin) {
              return _OnAccountLogin(
                state.data,
                key: Key('account_page_login'),
              );
            } else if (state is AccountNotLogin) {
              return _OnWelCome(
                key: Key('account_page_logout'),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class BuildCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final Function() onTap;

  BuildCard(this.icon, this.name, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          name,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _OnAccountLogin extends StatelessWidget {
  final SessionData sessionData;

  _OnAccountLogin(this.sessionData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Hi, \n${sessionData.username}',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          BuildCard(
            Icons.person_outline_rounded,
            'Profil',
            () => Navigation.intentWithData(
                ProfilePage.ROUTE_NAME, sessionData.email),
          ),
          BuildCard(
            Icons.history,
            'Riwayat Pelaporan',
            () => Navigation.intentWithData(
              HistoryPage.ROUTE_NAME,
              TokenId(
                sessionData.userid,
                sessionData.token,
              ),
            ),
          ),
          BuildCard(
            Icons.bookmark_outline,
            'Berita Tersimpan',
            () => Navigation.intent(SavedNews.ROUTE_NAME),
          ),
          const Divider(thickness: 2, indent: 30, endIndent: 30),
          const SizedBox(height: 10),
          BuildCard(
            Icons.info_outline,
            'Tentang Laporhoax',
            () => Navigation.intent(About.routeName),
          ),
          BuildCard(
            Icons.share_rounded,
            'Bagikan Laporhoax',
            () => Share.share(
                'Ayo berantas hoaks bersama LaporHoax! di https://s.id/LAPORHOAX'),
          ),
          SizedBox(height: 20),
          _Footer(),
          BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginEnded) {
                Navigation.intent(HomePage.ROUTE_NAME);
              } else if (state is LoginFailure) {
                toast('ada masalah');
              }
            },
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0),
                      ),
                    ),
                    builder: (context) {
                      return Container(
                        padding:
                            const EdgeInsets.only(top: 50, left: 20, right: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Apakah yakin mau keluar ? ',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => context
                                    .read<LoginCubit>()
                                    .logout(sessionData),
                                child: Text('Ya'),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () => Navigation.back(),
                                child: Text('Tidak'),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                style: redElevatedButton,
                child: Text('Logout'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnWelCome extends StatelessWidget {
  _OnWelCome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 20),
              Text(
                'Kamu Belum Login !',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Silahkan login untuk mengakses semua fitur dari aplikasi LAPOR HOAX ',
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
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
        Divider(thickness: 2, indent: 30, endIndent: 30),
        SizedBox(height: 20),
        BuildCard(
          Icons.info_outline,
          'Tentang LaporHoax',
          () => Navigation.intent(About.routeName),
        ),
        BuildCard(
          Icons.share_rounded,
          'Bagikan LaporHoax',
          () => Share.share(
              'Ayo berantas hoaks bersama LaporHoax! di https://s.id/LAPORHOAX'),
        ),
        SizedBox(height: 30),
        _Footer(),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        InkWell(
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
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ),
        Text(' | ', style: Theme.of(context).textTheme.bodyText1),
        InkWell(
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
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ),
      ],
    );
  }
}

class StaticDataWeb {
  final String fileName;
  final String title;

  StaticDataWeb({required this.fileName, required this.title});
}
