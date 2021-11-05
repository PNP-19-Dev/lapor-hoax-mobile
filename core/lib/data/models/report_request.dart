import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class ReportRequest extends Equatable {
  const ReportRequest({
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

  Map<String, dynamic> toJson() => {
        "user": user,
        "url": url,
        "category": category,
        "isAnonym": isAnonym,
        "report": description,
        "img": img,
      };

  @override
  List<Object?> get props => [
        user,
        url,
        category,
        isAnonym,
        description,
        img,
      ];
}
