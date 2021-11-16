/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.40
 */

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
