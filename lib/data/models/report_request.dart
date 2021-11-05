import 'package:image_picker/image_picker.dart';

class ReportRequest {
  ReportRequest({
    required this.user,
    required this.url,
    required this.category,
    required this.isAnonym,
    required this.description,
    required this.img,
  });

  final int user;
  final String url;
  final String category;
  final bool isAnonym;
  final String description;
  final XFile img;
}
