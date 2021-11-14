/*
 * Created by andii on 14/11/21 14.07
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 12.11
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/styles/colors.dart';
import 'package:laporhoax/utils/datetime_helper.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailReportPage extends StatelessWidget {
  static const ROUTE_NAME = '/detail_report';

  final Report report;

  DetailReportPage({required this.report});

  @override
  Widget build(BuildContext context) {
    var verdictDesc = report.verdictDesc ?? "";
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('${report.category}'),
        actions: [
          IconButton(
            onPressed: () => Share.share(
                'Ini klarifikasi oleh pihak ahli: ${report.verdictDesc}'),
            icon: SvgPicture.asset('assets/icons/share.svg'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: report.img!,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (_, url, error) => Icon(Icons.error),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Status : ${report.status}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Keputusan : ${report.verdict ?? "Menunggu"}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Umpan Balik : ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: grey200,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: grey100,
                    ),
                    width: double.infinity,
                    child: Text(
                      "${verdictDesc.isEmpty ? '--- Belum ada feedback, ditunggu ya ! ---' : verdictDesc}",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: isDark ? Colors.white : Colors.grey,
                          ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const Divider(height: 50, indent: 25.0, endIndent: 25.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 16.0),
                    child: Text(
                      'Informasi Laporanmu',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                    child: Text(
                      'Url / Link Pelaporan',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: grey200,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: grey100,
                    ),
                    width: double.infinity,
                    child: InkWell(
                      child: Text(
                        '${report.url!.replaceAll('"', '')}',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: grey500,
                            ),
                      ),
                      onTap: () {
                        final url = report.url!.replaceAll('"', '');
                        if (url.contains('://')) {
                          launch(url);
                        } else {
                          if (url.contains('.')) {
                            launch('http://$url');
                          }
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                    child: Text(
                      'Tanggal Pelaporan',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: grey200,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: grey100,
                    ),
                    width: double.infinity,
                    child: Text(
                        '${DateTimeHelper.formattedDate(report.dateReported.toString())}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                    child: Text(
                      'Deskripsi',
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: grey200,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: grey100,
                    ),
                    width: double.infinity,
                    child: Text(
                      '${report.description}',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: grey700,
                          ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
