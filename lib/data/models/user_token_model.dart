/*
 * Created by andii on 12/11/21 22.48
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.48
 */

import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/user_token.dart';

class UserTokenModel extends Equatable {
  final String token;
  final String expiry;

  UserTokenModel({required this.token, required this.expiry});

  factory UserTokenModel.fromJson(Map<String, dynamic> json) => UserTokenModel(
    expiry: json["expiry"],
    token: json["token"],
  );

  UserToken toEntity() => UserToken(token: token, expiry: expiry);

  @override
  List<Object?> get props => [token, expiry];
}
