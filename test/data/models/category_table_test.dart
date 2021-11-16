/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/category_model.dart';
import 'package:laporhoax/data/models/category_table.dart';
import 'package:laporhoax/domain/entities/category.dart';

void main() {
  final tCategoryTable = CategoryTable(id: 1, name: "name");

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
    test('should be a subclass of FeedTable from Entity', () async {
      final result = CategoryTable.fromEntity(tCategory);
      expect(result, tCategoryTable);
    });

    test('should be a subclass of FeedTable from Map', () async {
      final result = CategoryTable.fromMap(categoryMap);
      expect(result, tCategoryTable);
    });

    test('should be a subclass of FeedTable from Entity', () async {
      final result = CategoryTable.fromDTO(tCategoryModel);
      expect(result, tCategoryTable);
    });

    test('should be a valid JSON', () async {
      final result = tCategoryTable.toJson();
      expect(result, categoryMap);
    });

    test('should be a valid Category', () async {
      final result = tCategoryTable.toEntity();
      expect(result, tCategory);
    });
  });
}
