import 'package:laporhoax/domain/usecases/delete_report.dart';
import 'package:laporhoax/domain/usecases/get_categories.dart';
import 'package:laporhoax/domain/usecases/get_reports.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  GetReports,
  PostReport,
  DeleteReport,
  GetCategories,
])
void main() {}
