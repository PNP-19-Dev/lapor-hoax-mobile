import 'package:flutter/material.dart';
import 'package:laporhoax/data/model/user_report.dart';
import 'package:laporhoax/ui/report/detail_report_page.dart';
import 'package:laporhoax/util/datetime_helper.dart';

class ItemList extends StatelessWidget {
  final ReportItem report;

  ItemList({required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${report.category}'),
        subtitle: Text(
            '${DateTimeHelper.formattedDate(report.dateReported.toString())}'),
        trailing: Text('${report.status}'),
        onTap: () {
          print('tapped!');
          Navigator.pushNamed(context, DetailReportPage.routeName,
              arguments: report);
        },
      ),
    );
  }
}
