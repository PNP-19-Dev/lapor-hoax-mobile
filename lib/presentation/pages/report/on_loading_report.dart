/*
 * Created by andii on 22/11/21 14.56
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 17/11/21 19.12
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/presentation/pages/report/report_page.dart';
import 'package:laporhoax/styles/colors.dart';
import 'package:laporhoax/styles/theme.dart';
import 'package:laporhoax/utils/navigation.dart';

import 'detail_report_page.dart';

class OnSuccessReport extends StatelessWidget {
  static const String ROUTE_NAME = '/success';

  final Report reportItem;

  OnSuccessReport({required this.reportItem, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/success.svg', width: 100),
              SizedBox(height: 30),
              Text(
                'Selamat !',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: success),
              ),
              SizedBox(height: 10),
              Text(
                'Laporan berhasil dikirimkan',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: success),
              ),
              SizedBox(height: 15),
              Text(
                'Laporanmu akan segera diproses oleh ahli yang bersangkutan, jadi tunggu ya !',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => Navigation.intent(ReportPage.ROUTE_NAME),
                child: Text('Lapor lagi yuk !'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigation.intentWithData(
                    DetailReportPage.ROUTE_NAME, reportItem),
                child: Text('Lihat laporan yang barusan',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: orangeBlaze)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnFailureReport extends StatelessWidget {
  static const String ROUTE_NAME = '/error';

  OnFailureReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/fail.svg', width: 100),
            SizedBox(height: 25),
            Text(
              'Oops...!',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: failure),
            ),
            SizedBox(height: 10),
            Text(
              'Sepertinya Ada Kesalahan',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: failure),
            ),
            SizedBox(height: 15),
            Text(
              'Hmmm, sepertinya ada kesalahan. Ayo laporkan ulang !',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => Navigation.intent(ReportPage.ROUTE_NAME),
              style: redElevatedButton,
              child: Text('Ulang Pelaporan'),
            ),
          ],
        ),
      ),
    );
  }
}
