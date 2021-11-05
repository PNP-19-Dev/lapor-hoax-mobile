import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
              errorWidget: (context, url, eror) => Icon(Icons.error),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Status : ${report.status}'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Keputusan : ${report.verdict ?? "Menunggu"}',
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
                "${verdictDesc.isEmpty ? '--- Belum ada feedback, ditunggu ya ! ---' : verdictDesc}",
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
                    child: Text('${report.url}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: orangeBlaze,
                        )),
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
                ],
              ),
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
                      '${DateTimeHelper.formattedDate(report.dateReported.toString())}'),
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
                '${report.description}',
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
