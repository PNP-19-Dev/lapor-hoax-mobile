import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/report.dart';
import '../../presentation/pages/report/detail_report_page.dart';
import '../../styles/colors.dart';
import '../../utils/datetime_helper.dart';

class ReportListItem extends StatelessWidget {
  final Report report;

  const ReportListItem({Key? key, required this.report}) : super(key: key);

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
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${report.category}',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/modified_date.svg',
                        height: 13,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        DateTimeHelper.formattedDate(report.dateReported.toString()),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
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
                  style: const TextStyle(
                      color: Color(0xFFFF3333), fontWeight: FontWeight.bold),
                ),
                Text(
                    'Tag : ${report.verdict ?? 'N/A'}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
