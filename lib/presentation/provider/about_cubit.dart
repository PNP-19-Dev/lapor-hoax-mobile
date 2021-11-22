/*
 * Created by andii on 22/11/21 14.56
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 22/11/21 14.56
 */

import 'package:bloc/bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutCubit extends Cubit<AboutState> {
  AboutCubit() : super(AboutState('...'));

  Future<void> getVersion() async {
    final info = await PackageInfo.fromPlatform();
    emit(AboutState(info.version));
  }
}

class AboutState {
  final String data;

  AboutState(this.data);
}

