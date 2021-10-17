import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/model/user_report.dart';
import 'package:laporhoax/util/datetime_helper.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

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
                'Ini klarifikasi oleh pihak ahli: ${reportItem.verdictDesc}'),
            icon: SvgPicture.asset('assets/icons/share.svg'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              reportItem.img,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Status : ${reportItem.status}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('Keputusan : ${reportItem.verdict ?? "Menunggu"}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Umpan Balik : ',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: grey100,
              ),
              width: double.infinity,
              child: Text(
                "${reportItem.verdictDesc!.isEmpty ? '--- Belum ada feedback, ditunggu ya ! ---' : reportItem.verdictDesc}",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text('Informasi Laporanmu',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Url',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.link),
                    SizedBox(width: 5),
                    InkWell(
                      child: Text('${reportItem.url}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: orangeBlaze,
                          )),
                      onTap: () => launch('${reportItem.url}'),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text('Tanggal Pelaporan'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 5),
                  Text(
                      '${DateTimeHelper.formattedDate(reportItem.dateReported.toString())}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text('Deskripsi',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  )),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: grey100,
              ),
              width: double.infinity,
              child: Text(
                '${reportItem.description}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: grey700,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
