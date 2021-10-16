import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/model/user_question.dart';

class ForgotPassword extends StatefulWidget {
  static String routeName = '/forgot_password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var _inputQuestion = TextEditingController();
    var _inputAnswer = TextEditingController();
    final dio = Dio();
    List<QuestionResult> _q1 = [];

    @override
    initState() {
      super.initState();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text('Pertanyaan Rahasia'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pertanyaan',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              TextFormField(
                controller: _inputQuestion,
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Pertanyaan',
                  icon: Image.asset(
                    'assets/icons/question.png',
                    width: 24,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Jawaban',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              TextFormField(
                controller: _inputAnswer,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Masukkan Jawabanmu',
                  icon: Image.asset(
                    'assets/icons/ans.png',
                    width: 24,
                  ),
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Kamu belum memasukkan jawabannya';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Ganti Pertanyaan?',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: orangeBlaze,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                    child: Text('Selanjutnya'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordAction extends StatelessWidget {
  static String routeName = '/forgot_action';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: GestureDetector(
                onTap: () => Navigation.back(),
                child: Icon(Icons.arrow_back),
              ),
            ),
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    child: SvgPicture.asset(
                      'assets/logo.svg',
                      width: 81,
                      height: 81,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Username',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .apply(color: Colors.black),
                  ),
                  Text(
                    'Pilih kontak yang akan digunakan untuk reset passwordmu',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .apply(color: grey400),
                    softWrap: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Wrap(
                      children: [
                        Icon(Icons.mail),
                        SizedBox(width: 20),
                        Text(
                          'Kirim Email',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    child: Wrap(children: [
                      Icon(Icons.phone),
                      SizedBox(width: 20),
                      Text(
                        'Kirim SMS',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
