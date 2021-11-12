/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.43
 */

import 'package:equatable/equatable.dart';

class UserToken extends Equatable {
  final String? token;
  final String? expiry;

  UserToken({required this.token, required this.expiry});

  @override
  List<Object?> get props => [token, expiry];
}
