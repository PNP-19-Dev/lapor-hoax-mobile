import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/data/model/user_report.dart';

class DetailReportPage extends StatelessWidget {
  static String routeName = '/detail_report';

  final ReportItem report;

  DetailReportPage({required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(report.category),
          leading: IconButton(
            onPressed: Navigation.back(),
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/share.svg'),
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(),
      ),
    );
  }
}
