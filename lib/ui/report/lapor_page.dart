import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/category.dart';
import 'package:laporhoax/data/model/report.dart';
import 'package:laporhoax/data/model/token_id.dart';
import 'package:laporhoax/provider/preferences_provider.dart';
import 'package:laporhoax/ui/account/login_page.dart';
import 'package:laporhoax/ui/report/history_page.dart';
import 'package:laporhoax/ui/report/on_loading_report.dart';
import 'package:provider/provider.dart';

class LaporPage extends StatefulWidget {
  static const routeName = '/lapor_page';

  @override
  _LaporPageState createState() => _LaporPageState();
}

class _LaporPageState extends State<LaporPage> {
  var _selectedCategory;
  bool _anonym = false;
  XFile? _image;
  var dio = Dio();

  var _urlController = TextEditingController();
  var _descController = TextEditingController();

  void getCategories() async {
    final dio = Dio();
    final api = LaporhoaxApi(dio);
    final response = await api.getCategory();
    var listData = response;
    setState(() {
      _categories = listData;
    });
  }

  List<Category> _categories = [];

  Future getPhoto() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    setState(() {
      _image = image;
    });
  }

  Future getImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    setState(() {
      _image = image;
    });
  }

  @override
  initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<PreferencesProvider>(
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
        child: Builder(
          builder: (context) => SingleChildScrollView(
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
                                onPressed: getImage,
                                icon: Icon(Icons.image),
                              ),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              backgroundColor: orangeBlaze,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.camera_alt),
                              ),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _image == null
                                    ? 'Sertakan Screenshoot'
                                    : _image!.name,
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
                              icon: SvgPicture.asset('assets/link_on.svg'),
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
                            icon: SvgPicture.asset('assets/category_alt.svg'),
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
                                  style: BorderStyle.solid, color: orangeBlaze),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(style: BorderStyle.solid),
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                var data = Provider.of<PreferencesProvider>(
                                    context,
                                    listen: false);
                                int id = data.userData.id;
                                String url = _urlController.text.toString();
                                String desc = _descController.text.toString();
                                XFile img = _image!;
                                String category = _selectedCategory;
                                bool isAnonym = _anonym;

                                var report = Report(
                                  user: id,
                                  url: url,
                                  description: desc,
                                  category: category,
                                  isAnonym: isAnonym,
                                  img: img,
                                );

                                var api = LaporhoaxApi(dio);
                                var progress = ProgressHUD.of(context);
                                var result = api.postReport(
                                    data.loginData.token!, report);
                                progress!
                                    .showWithText('Laporanmu sedang diupload!');

                                result.then((value) {
                                  print('Report Status : ${value.status}');
                                  progress.dismiss();
                                  Navigation.intentWithData(
                                      OnSuccessReport.routeName, value);
                                }).onError((error, stackTrace) {
                                  print(error);
                                  progress.dismiss();
                                  Navigation.intent(OnFailureReport.routeName);
                                });
                              }
                            },
                            child: Text('Lapor'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<PreferencesProvider>(
                      builder: (context, provider, child) {
                    return GestureDetector(
                      onTap: () => Navigation.intentWithData(
                          HistoryPage.routeName,
                          TokenId(
                            token: provider.loginData.token!,
                            id: provider.userData.id.toString(),
                          )),
                      child: Center(
                          child: Text(
                        'Lihat riwayat pelaporan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
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
                  'assets/not_login.svg',
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
                Navigation.intent(LoginPage.routeName);
              },
              child: Text('Login'),
            ),
          ),
        ),
      ],
    );
  }
}
