/*
 * Created by andii on 16/11/21 09.46
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 09.43
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/category_model.dart';
import 'package:laporhoax/domain/entities/category.dart';

void main() {
  final tCategoryModel = CategoryModel(
    id: 1,
    name: "name",
  );

  final tCategory = Category(
      id: 1,
      name: "name"
  );

  final categoryMap = {
    "id": 1,
    "name": "name"
  };

  group('Category Table', () {
    test('should be a subclass of Category from Model', () async {
      final result = tCategoryModel.toEntity();
      expect(result, tCategory);
    });

    test('should be a valid Model from JSON', () async {
      final result = CategoryModel.fromJson(categoryMap);
      expect(result, tCategoryModel);
    });
  });
}
