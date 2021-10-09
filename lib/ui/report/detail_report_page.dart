import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:laporhoax/data/model/user_report.dart';

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
            onPressed: () {},
            icon: SvgPicture.asset('assets/share.svg'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.memory(base64Decode(reportItem.imgB64.toString())),
            Center(
              child: Text('${reportItem.category}'),
            ),
          ],
        ),
      ),
    );
  }
}
