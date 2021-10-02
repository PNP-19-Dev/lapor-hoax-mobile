import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/provider/preferences_provider.dart';
import 'package:laporhoax/ui/account/login_page.dart';
import 'package:laporhoax/ui/report/history_page.dart';
import 'package:provider/provider.dart';

class LaporPage extends StatefulWidget {
  static String routeName = 'lapor_page';

  @override
  _LaporPageState createState() => _LaporPageState();
}

class _LaporPageState extends State<LaporPage> {
  var selectedCategory;
  bool anonim = false;
  XFile? _image;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  List categories = [
    "Kesusilaan",
    "Perjudian",
    "Pencemaran nama baik",
    "Hoax",
    "SARA",
    "Penyadapan",
    "Ujaran Kebencian",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
            Consumer<PreferencesProvider>(builder: (context, provider, child) {
          if (provider.isLoggedIn) {
            return lapor();
          } else
            return welcome();
        }),
      ),
    );
  }

  Widget lapor() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 11, left: 15),
                child: GestureDetector(
                  child: Icon(Icons.arrow_downward_rounded, size: 32),
                  onTap: () => Navigation.back(),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                child: Center(
                  child: Text(
                    'Buat Laporan',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 45,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: getImage,
                    child: Text('Inp. Gambar'),
                  ),
                  SizedBox(width: 8),
                  Text(_image == null ? 'Sertakan Screenshoot' : _image!.name),
                ],
              ),
              TextField(
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    labelText: 'URL / Link (optional)', icon: Icon(Icons.link)),
              ),
              DropdownButtonFormField<String>(
                isExpanded: true,
                iconSize: 0,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.borderAll),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                hint: Text('Category'),
                value: selectedCategory,
                items: categories.map((value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (v) {
                  setState(() {
                    selectedCategory = v!;
                  });
                },
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Checkbox(
                    onChanged: (bool? value) {
                      setState(() {
                        anonim = value!;
                      });
                    },
                    value: anonim,
                  ),
                  Text('Lapor Secara Anonim'),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Lapor'),
                ),
              ),
              GestureDetector(
                onTap: () => Navigation.intent(HistoryPage.routeName),
                child: Center(
                    child: Text(
                  'Lihat riwayat pelaporan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ),
            ],
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
            child: Icon(Icons.arrow_downward_rounded, size: 32),
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
