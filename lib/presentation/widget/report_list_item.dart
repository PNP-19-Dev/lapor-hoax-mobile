import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/presentation/pages/report/detail_report_page.dart';
import 'package:laporhoax/styles/colors.dart';
import 'package:laporhoax/utils/datetime_helper.dart';

class ReportListItem extends StatelessWidget {
  final Report report;

  ReportListItem({required this.report});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, DetailReportPage.ROUTE_NAME,
          arguments: report),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${report.category}',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/modified_date.svg',
                        height: 13,
                      ),
                      SizedBox(width: 2),
                      Text(
                        '${DateTimeHelper.formattedDate(report.dateReported.toString())}',
                        style: Theme.of(context).textTheme.overline!.copyWith(
                              color: grey700,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status : ${report.status}',
                  style: TextStyle(
                      color: Color(0xFFFF3333), fontWeight: FontWeight.bold),
                ),
                Text(
                    'Tag : ${report.verdict == null ? 'N/A' : report.verdict}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
