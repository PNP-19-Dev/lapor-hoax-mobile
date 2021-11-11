import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/domain/entities/category.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/presentation/pages/account/login_page.dart';
import 'package:laporhoax/presentation/pages/home_page.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/presentation/provider/report_cubit.dart';
import 'package:laporhoax/presentation/widget/toast.dart';
import 'package:laporhoax/styles/colors.dart';
import 'package:laporhoax/utils/navigation.dart';
import 'package:provider/provider.dart';

import 'history_page.dart';
import 'on_loading_report.dart';

class ReportPage extends StatefulWidget {
  static const ROUTE_NAME = '/lapor_page';

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().fetchSession();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (_, state) {
            if (state is LoginSuccessWithData) {
              return _OnLapor(state.data);
            } else {
              return _OnWelcome();
            }
          },
        ),
      ),
    );
  }
}

class _OnWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              style: Theme.of(context).textTheme.headline5,
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
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 10),
                Text(
                  'Silahkan login untuk melanjutkan pelaporan',
                  style: Theme.of(context).textTheme.caption,
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
              onPressed: () => Navigation.intent(LoginPage.ROUTE_NAME),
              child: Text('Login'),
            ),
          ),
        ),
      ],
    );
  }
}

class _OnLapor extends StatefulWidget {
  final SessionData data;

  _OnLapor(this.data, {Key? key}) : super(key: key);

  @override
  _OnLaporState createState() => _OnLaporState();
}

class _OnLaporState extends State<_OnLapor> {
  @override
  void initState() {
    super.initState();
    context.read<ReportCubit>().fetchCategory();
  }

  var _selectedCategory;
  bool _anonym = false;
  XFile? _image;
  String filename = '';

  final _urlController = TextEditingController();
  final _descController = TextEditingController();

  FocusNode _linkFocusNode = new FocusNode();
  final _formKey = GlobalKey<FormState>();

  sendData() {
    if (_formKey.currentState!.validate() && _image != null) {
      context.read<ReportCubit>().sendReport(
            widget.data.token,
            widget.data.userid,
            _urlController.text.toString(),
            _descController.text.toString(),
            _image!,
            _selectedCategory,
            _anonym,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReportPageHeader(),
                  const SizedBox(height: 45),
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
                                onPressed: () {
                                  final get = context
                                      .read<ReportCubit>()
                                      .getImage(ImageSource.gallery);
                                  get
                                      .then((value) => setState(()=> _image = value))
                                      .onError((error, _) => toast('$error'));
                                },
                                icon: Icon(
                                  Icons.image,
                                  color: isDark ? Colors.grey : Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              backgroundColor: orangeBlaze,
                              child: IconButton(
                                onPressed: () {
                                  final get = context
                                      .read<ReportCubit>()
                                      .getImage(ImageSource.camera);
                                  get
                                      .then((value) => setState(()=> _image = value))
                                      .onError((error, _) => toast('$error'));
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: isDark ? Colors.grey : Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _image == null
                                    ? 'Sertakan Screenshoot'
                                    : _image!.path.trim().split('/').last,
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
                        BlocBuilder<ReportCubit, ReportState>(
                          builder: (_, state) {
                            List<Category> _categories = [];
                            String message = '';

                            if (state is CategoryInitial) {
                              message = state.message;
                            } else if (state is CategoryError) {
                              message = state.message;
                            } else {
                              message = 'category';
                            }

                            if (state is CategoryFetched) {
                              _categories = state.category;
                              message = 'category';
                            }

                            return DropdownButtonFormField<String>(
                              isExpanded: true,
                              iconSize: 0,
                              decoration: InputDecoration(
                                icon: SvgPicture.asset(
                                    'assets/icons/category_alt.svg'),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                              hint: Text(message),
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
                          child: BlocListener<ReportCubit, ReportState>(
                            listener: (context, state) {
                              final progress = ProgressHUD.of(context);

                              if (state is ReportUploading) {
                                progress?.showWithText('Loading...');
                              }

                              if (state is ReportError) {
                                progress!.dismiss();
                                Navigator.pushNamed(
                                    context, OnFailureReport.ROUTE_NAME);
                              } else if (state is ReportUploaded) {
                                progress!.dismiss();
                                Navigator.pushNamed(
                                    context, OnSuccessReport.ROUTE_NAME);
                              }
                            },
                            child: ElevatedButton(
                              onPressed: sendData,
                              child: Text('Lapor'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ReportPageFooter(widget.data),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReportPageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 11),
          child: GestureDetector(
            child: Icon(Icons.arrow_back, size: 32),
            onTap: () => Navigation.intent(HomePage.ROUTE_NAME),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
          child: Center(
            child: Text(
              'Buat Laporan',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReportPageFooter extends StatelessWidget {
  final SessionData data;

  _ReportPageFooter(this.data);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return Navigation.intentWithData(
            HistoryPage.ROUTE_NAME, TokenId(data.userid, data.token));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Center(
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
