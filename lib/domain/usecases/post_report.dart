/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.47
 */

import 'package:dartz/dartz.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/repositories/repository.dart';
import 'package:laporhoax/utils/failure.dart';

class PostReport {
  final Repository repository;

  PostReport(this.repository);

  Future<Either<Failure, Report>> execute(String token, ReportRequest report) {
    return repository.postReport(token, report);
  }
}
