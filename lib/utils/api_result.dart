/*
 * Created by andii on 14/11/21 01.40
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 13/11/21 21.28
 */
import 'package:freezed_annotation/freezed_annotation.dart';

import 'network_exceptions.dart';

part 'api_result.freezed.dart';

@freezed
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success({required T data}) = Success<T>;
  const factory ApiResult.failure({required NetworkExceptions error}) =
      Failure<T>;
}
