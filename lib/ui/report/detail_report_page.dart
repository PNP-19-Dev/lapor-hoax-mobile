import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:laporhoax/data/model/user_report.dart';
import 'package:laporhoax/util/datetime_helper.dart';
import 'package:share/share.dart';

class DetailReportPage extends StatelessWidget {
  static const routeName = '/detail_report';

  final ReportItem reportItem;

  DetailReportPage({required this.reportItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('${reportItem.category}'),
        actions: [
          IconButton(
            onPressed: () => Share.share(
                'Ayo berantas hoaks bersama LaporHoax! di https://example.com'),
            icon: SvgPicture.asset('assets/share.svg'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.memory(base64Decode(reportItem.imgB64.toString())),
            Container(
              decoration: BoxDecoration(color: Colors.grey),
              height: 200,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Status : ${reportItem.status}'),
            ),
            Text('Keputusan : ${reportItem.verdictJudge ?? "Menunggu"}'),
            Text('Umpan Balik : '),
            Text('${reportItem.verdictDesc ?? "Menunggu Admin"}'),
            Divider(),
            Text('Informasi Laporanmu'),
            Text('Url'),
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              Icon(Icons.link),
              Text('${reportItem.url}'),
            ]),
            Text('Tanggal Pelaporan'),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.calendar_today),
                Text(
                    '${DateTimeHelper.formattedDate(reportItem.dateReported.toString())}'),
              ],
            ),
            Text('Deskripsi'),
            Text('${reportItem.description}'),
          ],
        ),
      ),
    );
  }
}
