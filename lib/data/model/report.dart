import 'package:image_picker/image_picker.dart';

class Report {
  Report({
    required this.id,
    required this.url,
    required this.category,
    required this.isAnonym,
    required this.email,
    required this.description,
    required this.img,
  });

  int id;
  String url;
  String category;
  bool isAnonym;
  String email;
  String description;
  XFile img;

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "category": category,
        "isAnonym": isAnonym,
        "email": email,
        "report": description,
        "img": img,
      };
}
