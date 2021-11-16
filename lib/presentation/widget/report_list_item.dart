/*
 * Created by andii on 14/11/21 14.07
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 12.22
 */

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
    var isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, DetailReportPage.ROUTE_NAME,
          arguments: report),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isDark ? darkCard : Colors.white,
        ),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/modified_date.svg',
                          height: 13,
                          color: isDark ? Colors.white : Colors.blueGrey,
                        ),
                        SizedBox(width: 2),
                        Text(
                          '${DateTimeHelper.formattedDate(report.dateReported.toString())}',
                          style: Theme.of(context).textTheme.overline!.copyWith(
                            color: isDark ? Colors.white : grey700,
                          ),
                        ),
                      ],
                    ),
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
