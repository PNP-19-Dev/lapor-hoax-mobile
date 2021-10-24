import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/models/report_request.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/category.dart';
import 'package:laporhoax/presentation/pages/account/login_page.dart';
import 'package:laporhoax/presentation/provider/report_notifier.dart';
import 'package:laporhoax/presentation/provider/user_notifier.dart';
import 'package:laporhoax/presentation/widget/toast.dart';
import 'package:provider/provider.dart';

import 'history_page.dart';
import 'on_loading_report.dart';

class ReportPage extends StatefulWidget {
  static const ROUTE_NAME = '/lapor_page';

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  var _selectedCategory;
  bool _anonym = false;
  XFile? _image;
  List<Category> _categories = [];
  String filename = '';

  var _urlController = TextEditingController();
  var _descController = TextEditingController();

  // ignore : deprecation
  Future<Null> getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().getImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null) {
        cropImage(image.path);
      }
      // final imageTemporary = XFile(image.path);
      // setState(() => this._image = imageTemporary);
    } on PlatformException catch (e) {
      print('failed to pick image: $e');
    }
  }

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
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReportNotifier>(context, listen: false).fetchCategories();
      Provider.of<UserNotifier>(context, listen: false)
        ..isLogin()
        ..getSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<UserNotifier>(
          builder: (context, provider, child) {
            if (provider.isLoggedIn) {
              return lapor();
            } else
              return welcome();
          },
        ),
      ),
    );
  }

  FocusNode _linkFocusNode = new FocusNode();
  final _formKey = GlobalKey<FormState>();

  Widget lapor() => ProgressHUD(
        child: Builder(builder: (context) {
          _categories =
              Provider.of<ReportNotifier>(context, listen: false).category;

          return StreamBuilder(
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 11),
                        child: GestureDetector(
                          child: Icon(Icons.arrow_back, size: 32),
                          onTap: () => Navigation.back(),
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(top: 30, left: 15, right: 15),
                        child: Center(
                          child: Text(
                            'Buat Laporan',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: orangeBlaze,
                                  child: IconButton(
                                    onPressed: () async =>
                                        getImage(ImageSource.gallery),
                                    icon: Icon(Icons.image),
                                  ),
                                ),
                                SizedBox(width: 10),
                                CircleAvatar(
                                  backgroundColor: orangeBlaze,
                                  child: IconButton(
                                    onPressed: () async =>
                                        getImage(ImageSource.camera),
                                    icon: Icon(Icons.camera_alt),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    _image == null
                                        ? 'Sertakan Screenshoot'
                                        : filename,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            TextField(
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _urlController,
                              focusNode: _linkFocusNode,
                              decoration: InputDecoration(
                                  labelText: 'URL / Link (optional)',
                                  icon: SvgPicture.asset(
                                      'assets/icons/link_on.svg'),
                                  labelStyle: TextStyle(
                                    color: _linkFocusNode.hasFocus
                                        ? orangeBlaze
                                        : Colors.black,
                                  )),
                            ),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              iconSize: 0,
                              decoration: InputDecoration(
                                icon: SvgPicture.asset(
                                    'assets/icons/category_alt.svg'),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                              hint: Text('Category'),
                              value: _selectedCategory,
                              items: _categories.map((value) {
                                return DropdownMenuItem<String>(
                                  child: Text(value.name),
                                  value: value.name,
                                );
                              }).toList(),
                              onChanged: (v) {
                                setState(() {
                                  _selectedCategory = v!;
                                });
                              },
                              onTap: () {
                                if (_categories.isEmpty) {
                                  toast('Mengambil data kategori...');
                                }
                              },
                            ),
                            TextField(
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              controller: _descController,
                              minLines: 5,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: 'Deskripsi laporan ( Opsional )',
                                alignLabelWithHint: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: orangeBlaze),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(style: BorderStyle.solid),
                                ),
                              ),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Checkbox(
                                  activeColor: orangeBlaze,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _anonym = value!;
                                    });
                                  },
                                  value: _anonym,
                                ),
                                Text('Lapor Secara Anonim'),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  var data = Provider.of<UserNotifier>(context)
                                      .sessionData;

                                  if (data != null) {
                                    if (_formKey.currentState!.validate()) {
                                      int id = data.userid;
                                      String url =
                                          _urlController.text.toString();
                                      String desc =
                                          _descController.text.toString();
                                      XFile img = _image!;
                                      String category = _selectedCategory;
                                      bool isAnonym = _anonym;

                                      final progress = ProgressHUD.of(context);
                                      progress?.showWithText('Loading...');

                                      var report = ReportRequest(
                                        user: id,
                                        url: url,
                                        description: desc,
                                        category: category,
                                        isAnonym: isAnonym,
                                        img: img,
                                      );

                                      await Provider.of<ReportNotifier>(context,
                                              listen: false)
                                          .sendReport(data.token, report);

                                      final state = Provider.of<ReportNotifier>(
                                              context,
                                              listen: false)
                                          .postReportState;

                                      final message =
                                          Provider.of<ReportNotifier>(context,
                                                  listen: false)
                                              .postReportMessage;

                                      final result =
                                          Provider.of<ReportNotifier>(context,
                                                  listen: false)
                                              .report;

                                      if (state == RequestState.Loaded) {
                                        progress!.dismiss();
                                        Navigation.intentWithData(
                                            OnSuccessReport.ROUTE_NAME,
                                            result!);
                                      } else if (state == RequestState.Error) {
                                        progress!.dismiss();
                                        toast(message);
                                        Navigation.intent(
                                            OnFailureReport.ROUTE_NAME);
                                      }
                                    }
                                  }
                                },
                                child: Text('Lapor'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          var data =
                              Provider.of<UserNotifier>(context, listen: false)
                                  .sessionData;
                          if (data != null) {
                            return Navigation.intentWithData(
                                HistoryPage.ROUTE_NAME,
                                TokenId(data.userid, data.token));
                          }
                        },
                        child: Container(
                          child: Center(
                              child: Text(
                            'Lihat riwayat pelaporan',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      );

  Widget welcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 11, left: 15),
          child: GestureDetector(
            child: Icon(Icons.arrow_back, size: 32),
            onTap: () => Navigation.back(),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
          child: Center(
            child: Text(
              'Buat Laporan',
              style: GoogleFonts.inter(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 45,
        ),
        Container(
          child: Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/illustration/not_login.svg',
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 10),
                Text(
                  'Kamu belum login!',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'Silahkan login untuk melanjutkan pelaporan',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w200,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 25),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigation.intent(LoginPage.ROUTE_NAME);
              },
              child: Text('Login'),
            ),
          ),
        ),
      ],
    );
  }
}
