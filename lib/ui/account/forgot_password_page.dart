import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/model/challenge.dart';
import 'package:laporhoax/data/model/user_data.dart';
import 'package:laporhoax/provider/list_providers.dart';
import 'package:laporhoax/util/route/challenge_arguments.dart';
import 'package:laporhoax/util/widget/toast.dart';
import 'package:provider/provider.dart';

class ForgotPasswordSectionOne extends StatefulWidget {
  static String routeName = '/forgot_password1';

  @override
  _ForgotPasswordSectionOneState createState() =>
      _ForgotPasswordSectionOneState();
}

class _ForgotPasswordSectionOneState extends State<ForgotPasswordSectionOne> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var _inputEmail = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                top: 40.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        SvgPicture.asset('assets/illustration/get_email.svg'),
                        SizedBox(height: 10),
                        Text(
                          'Lupa Password',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .apply(color: Colors.black),
                        ),
                        Text(
                          'Masukkan email yang telah terdaftar untuk melanjutkan',
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          TextFormField(
                            controller: _inputEmail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              icon: Icon(Icons.mail_outline),
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'Mohon isikan alamat email anda!';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Consumer<ListProviders>(
                                builder: (context, provider, widget) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        final progress =
                                            ProgressHUD.of(context);
                                        progress!.show();

                                        provider
                                            .getUserData(_inputEmail.text)
                                            .then((value) {
                                          User user = value;
                                          String id = value.id.toString();

                                          provider
                                              .getUserQuestion(id)
                                              .then((value) {
                                            progress.dismiss();
                                            Navigation.intentWithData(
                                                ForgotPasswordSectionTwo
                                                    .routeName,
                                                ChallengeArguments(
                                                    user, value));
                                          }).onError((error, stackTrace) {
                                            toast('Error $error');
                                          });
                                        }).onError((error, stackTrace) {
                                          progress.dismiss();
                                          toast('Error $error');
                                        });
                                      }
                                    },
                                    child: Text('selanjutnya'),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordSectionTwo extends StatefulWidget {
  static String routeName = '/forgot_password2';
  final User user;
  final Challenge challenge;

  ForgotPasswordSectionTwo({required this.user, required this.challenge});

  @override
  _ForgotPasswordSectionTwo createState() => _ForgotPasswordSectionTwo();
}

class _ForgotPasswordSectionTwo extends State<ForgotPasswordSectionTwo> {
  var _inputQuestion = TextEditingController();
  var _inputAnswer = TextEditingController();
  var question = 'value';
  Map<int, String> questionMap = {};
  List<String> userAnswer = [];
  List<int> index = [];

  void getAnsAndIndex() {
    userAnswer.clear();
    userAnswer.add(widget.challenge.ans1 ?? '');
    userAnswer.add(widget.challenge.ans2 ?? '');
    userAnswer.add(widget.challenge.ans3 ?? '');
    index.clear();
    index.add(widget.challenge.quest1 ?? 1);
    index.add(widget.challenge.quest2 ?? 1);
    index.add(widget.challenge.quest3 ?? 1);

    print('index: ${index.length}');
  }

  @override
  void initState() {
    super.initState();
    getAnsAndIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text('Pertanyaan Rahasia'),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Container(
            padding: const EdgeInsets.only(
              top: 40,
              left: 16,
              right: 16,
            ),
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
                Consumer<ListProviders>(builder: (context, provider, child) {
                  questionMap = provider.questionToMap();

                  _inputQuestion.text =
                      questionMap[index.isNotEmpty ? index[0] : 1] as String;

                  return TextField(
                    controller: _inputQuestion,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: 'Pertanyaan',
                      icon: Image.asset(
                        'assets/icons/question.png',
                        width: 24,
                      ),
                    ),
                  );
                }),
                SizedBox(height: 20),
                Text(
                  'Jawaban',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                TextField(
                  controller: _inputAnswer,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Jawabanmu',
                    icon: Image.asset(
                      'assets/icons/ans.png',
                      width: 24,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    var random = Random();
                    var nilaiRandom = random.nextInt(3);
                    int nilai = index[nilaiRandom];
                    print(nilai);
                    var _newValue = questionMap[nilai] as String;

                    _inputQuestion.value = TextEditingValue(
                      text: _newValue,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: _newValue.length),
                      ),
                    );

                    print(_inputQuestion.value);
                  },
                  child: Container(
                    child: Text(
                      'Ganti Pertanyaan?',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: orangeBlaze,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Selanjutnya'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
