import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/report.dart';
import 'package:laporhoax/data/model/user_report.dart';
import 'package:laporhoax/provider/preferences_provider.dart';
import 'package:provider/provider.dart';

class OnLoadingReport extends StatelessWidget {
  static var routeName = '/report_loading';

  final Report report;

  OnLoadingReport({required this.report});

  @override
  Widget build(BuildContext context) {
    var dio = Dio();
    var api = LaporhoaxApi(dio);
    var provider = Provider.of<PreferencesProvider>(context, listen: false);

    Future<UserReport> postData(Report report) async {
      return await api.postReport(provider.loginData.token!, report);
    }

    var uploadData = postData(report);

    uploadData.then((value) {
      print('Report Status : ${value.results[0].status}');
      Navigation.intent(OnSuccessReport.routeName);
    }).onError((error, stackTrace) {
      print(error);
      Navigation.intent(OnFailureReport.routeName);
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}

class OnSuccessReport extends StatelessWidget {
  static String routeName = '/success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/success.svg', width: 100),
            SizedBox(height: 30),
            Text('Selamat !',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 30, color: success)),
            SizedBox(height: 10),
            Text('Laporan berhasil dikirimkan',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600, fontSize: 20, color: success)),
            SizedBox(height: 15),
            Text(
                'Laporanmu akan segera diproses oleh ahli yang bersangkutan, jadi tunggu ya !',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400, fontSize: 20)),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {},
              child: Text('Lapor lagi yuk !'),
            ),
            SizedBox(height: 20),
            Text('Lihat laporan yang barusan',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: orangeBlaze)),
          ],
        ),
      ),
    );
  }
}

class OnFailureReport extends StatelessWidget {
  static String routeName = '/error';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/fail.svg', width: 100),
            SizedBox(height: 25),
            Text('Oops...!',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: Colors.red)),
            SizedBox(height: 10),
            Text('Sepertinya Ada Kesalahan',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.red)),
            SizedBox(height: 15),
            Text('Hmmm, sepertinya ada kesalahan. Ayo laporkan ulang !',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400, fontSize: 12)),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {},
              child: Text('Lapor lagi yuk !'),
            ),
            SizedBox(height: 20),
            Text('Lihat laporan yang barusan',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: orangeBlaze)),
          ],
        ),
      ),
    );
  }
}
