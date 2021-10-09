import 'package:image_picker/image_picker.dart';

class Report {
  Report({
    required this.user,
    required this.url,
    required this.category,
    required this.isAnonym,
    required this.description,
    required this.img,
  });

  int user;
  String url;
  String category;
  bool isAnonym;
  String description;
  XFile img;

  Map<String, dynamic> toJson() => {
        "user": user,
        "url": url,
        "category": category,
        "isAnonym": isAnonym,
        "report": description,
        "img": img,
      };
}
