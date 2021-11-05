import 'dart:async';

import 'package:core/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../data/models/report_request.dart';
import '../../../data/models/token_id.dart';
import '../../../domain/entities/category.dart';
import '../../../styles/colors.dart';
import '../../../utils/navigation.dart';
import '../../../utils/route_observer.dart';
import '../../../utils/state_enum.dart';
import '../../provider/report_notifier.dart';
import '../../provider/user_notifier.dart';
import '../../widget/toast.dart';
import '../account/login_page.dart';
import 'history_page.dart';
import 'on_loading_report.dart';

class ReportPage extends StatefulWidget {
  static const ROUTE_NAME = '/lapor_page';

  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with RouteAware {
  var _selectedCategory;
  bool _anonym = false;
  XFile? _image;
  List<Category> _categories = [];
  String filename = '';

  final _urlController = TextEditingController();
  final _descController = TextEditingController();

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<UserNotifier>(context, listen: false).isLogin();
  }

  // ignore : deprecation
  Future<void> getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null) {
        // cropImage(image.path);
        setState(() {
          filename = image.path.trim().split('/').last;
          _image = image;
        });
      }
    } on PlatformException catch (e) {
      toast('Gagal Mengambil Gambar');
      print('failed to pick image: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<UserNotifier>(
          builder: (context, provider, child) {
            if (provider.isLoggedIn) {
              return lapor();
            } else {
              return _Welcome();
            }
          },
        ),
      ),
    );
  }

  final FocusNode _linkFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  Stream<List<Category>> _data() async* {
    var data = Provider.of<ReportNotifier>(context, listen: false).category;
    setState(() {
      _categories = data;
    });
    yield data;
  }

  Widget lapor() {
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                          const EdgeInsets.only(top: 30, left: 15, right: 15),
                          child: const Center(
                            child: Text(
                              'Buat Laporan',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 45),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () async =>
                                  getImage(ImageSource.gallery),
                              child: const Text('Gambar'),
                            ),
                            /* TODO FITUR TAMBAHAN
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
                                ),*/
                            const SizedBox(width: 8),
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
                              icon:
                                  SvgPicture.asset('assets/icons/link_on.svg'),
                              labelStyle: TextStyle(
                                color: _linkFocusNode.hasFocus
                                    ? orangeBlaze
                                    : Colors.black,
                              )),
                        ),
                        StreamBuilder(
                          initialData: 'mendapatkan data',
                          stream: _data(),
                          builder: (context, snapshot) {
                            return DropdownButtonFormField<String>(
                              isExpanded: true,
                              iconSize: 0,
                              decoration: InputDecoration(
                                icon: SvgPicture.asset(
                                    'assets/icons/category_alt.svg'),
                                suffixIcon: const Icon(Icons.arrow_drop_down),
                              ),
                              hint: Consumer<ReportNotifier>(
                                  builder: (_, data, child) {
                                if (data.category.isEmpty) {
                                  return const Text('Mengambil data');
                                } else {
                                  return const Text('Category');
                                }
                              }),
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
                            );
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
                              borderSide: const BorderSide(
                                  style: BorderStyle.solid, color: orangeBlaze),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  const BorderSide(style: BorderStyle.solid),
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
                            const Text('Lapor Secara Anonim'),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              var data = Provider.of<UserNotifier>(context,
                                      listen: false)
                                  .sessionData;

                              if (data != null) {
                                if (_formKey.currentState!.validate()) {
                                  int id = data.userid;
                                  String url = _urlController.text.toString();
                                  String desc = _descController.text.isEmpty
                                      ? "tidak ada deskripsi"
                                      : _descController.text.toString();
                                  XFile img = _image!;
                                  String category = _selectedCategory;
                                  bool isAnonym = _anonym;

                                  var report = ReportRequest(
                                    user: id,
                                    url: url,
                                    description: desc,
                                    category: category,
                                    isAnonym: isAnonym,
                                    img: img,
                                  );

                                  final progress = ProgressHUD.of(context);
                                  progress?.showWithText('Loading...');

                                  await Provider.of<ReportNotifier>(
                                    context,
                                    listen: false,
                                  ).sendReport(data.token, report);

                                  final state = Provider.of<ReportNotifier>(
                                          context,
                                          listen: false)
                                      .postReportState;

                                  final message = Provider.of<ReportNotifier>(
                                          context,
                                          listen: false)
                                      .postReportMessage;

                                  final result = Provider.of<ReportNotifier>(
                                          context,
                                          listen: false)
                                      .report;

                                  if (state == RequestState.success) {
                                    progress!.dismiss();
                                    Navigation.intentWithData(
                                        OnSuccessReport.ROUTE_NAME, result!);
                                  } else if (state == RequestState.error) {
                                    progress!.dismiss();
                                    toast(message);
                                    Navigation.intent(
                                        OnFailureReport.ROUTE_NAME);
                                  } else {
                                    progress!.dismiss();
                                  }
                                }
                              }
                            },
                            child: const Text('Lapor'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ButtonHistory(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

class _Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 11, left: 15),
          child: GestureDetector(
            child: const Icon(Icons.arrow_back, size: 32),
            onTap: () => Navigator.pop(context),
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
        const SizedBox(
          height: 45,
        ),
        Center(
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/illustration/not_login.svg',
                width: 250,
                height: 250,
              ),
              const SizedBox(height: 10),
              Text(
                'Kamu belum login!',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 25),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigation.intent(LoginPage.ROUTE_NAME);
              },
              child: const Text('Login'),
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 11),
      child: GestureDetector(
        child: const Icon(Icons.arrow_back, size: 32),
        onTap: () => Navigation.intent(homeRoute),
      ),
    );
  }

}

class _ButtonHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var data =
            Provider.of<UserNotifier>(context, listen: false)
                .sessionData;
        if (data != null) {
          Navigation.intentWithData(HistoryPage.ROUTE_NAME,
              TokenId(data.userid, data.token));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: const Center(
          child: Text(
            'Lihat riwayat pelaporan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: orangeBlaze,
            ),
          ),
        ),
      ),
    );
  }

}
