/*
 * Created by andii on 14/11/21 14.07
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 11.20
 */

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/domain/entities/category.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/usecases/get_categories.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/post_report.dart';
import 'package:permission_handler/permission_handler.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final GetCategories _category;
  final PostReport _send;

  ReportCubit(this._category, this._send) : super(ReportInitial());

  Future<XFile> getImage(ImageSource source) async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
      XFile? image;
      try {
        image = await ImagePicker().pickImage(
          source: source,
          imageQuality: 85,
        );

        if (image == null) {
          // cropImage(image.path);
          throw ('Upload Gambar Dibatalkan!');
        }
      } on PlatformException {
        throw ('Terjadi Masalah Saat Mengupload Gambar!');
      }
      return image;
    } else if (status == PermissionStatus.denied) {
      print(
          'Permission denied. Show a dialog and again ask for the permission');
      throw ('Kamera tidak diizinkan');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
    throw ('Kamera tidak diizinkan');
  }

  /* TODO SOON ADDING CROP
 Future<Null> cropImage(String path) async {
    try {
      File? fileImage = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: orangeBlaze,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        compressQuality: 80,
      );
      print('path : ${fileImage!.path}');
      setState(() {
        filename = fileImage.path.trim().split('/').last;
        this._image = XFile(fileImage.path, name: filename);
      });
    } on IOException catch (e) {
      print('Pick error $e');
    }
  }*/

  Future<void> fetchCategory() async {
    emit(CategoryInitial('mendapatkan data'));
    final result = await _category.execute();

    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (data) => emit(CategoryFetched(data)),
    );
  }

  Future<void> sendReport(
    String token,
    int id,
    String url,
    String desc,
    XFile img,
    String category,
    bool isAnonym,
  ) async {
    final report = ReportRequest(
      user: id,
      url: url,
      description: desc.isEmpty ? 'tidak ada deskripsi' : desc,
      category: category,
      isAnonym: isAnonym,
      img: img,
    );

    emit(ReportUploading());
    final result = await _send.execute(token, report);

    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (report) => emit(ReportUploaded(report)),
    );
  }
}
