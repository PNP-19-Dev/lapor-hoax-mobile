import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/entities/user_question.dart';
import 'package:laporhoax/presentation/provider/question_notifier.dart';
import 'package:laporhoax/presentation/provider/user_notifier.dart';
import 'package:laporhoax/presentation/widget/toast.dart';
import 'package:provider/provider.dart';

class ForgotPasswordSectionOne extends StatefulWidget {
  static const String ROUTE_NAME = '/forgot_password1';

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
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final progress = ProgressHUD.of(context);
                                    progress!
                                        .showWithText("Mendapatkan Data..");
                                    await Provider.of<UserNotifier>(context,
                                            listen: false)
                                        .getUserData(_inputEmail.text);

                                    final state = Provider.of<UserNotifier>(
                                            context,
                                            listen: false)
                                        .userState;
                                    final message = Provider.of<UserNotifier>(
                                            context,
                                            listen: false)
                                        .userMessage;

                                    if (state == RequestState.Loaded) {
                                      progress.dismiss();
                                      var user = Provider.of<UserNotifier>(
                                              context,
                                              listen: false)
                                          .user;
                                      Navigation.intentWithData(
                                          ForgotPasswordSectionTwo.ROUTE_NAME,
                                          user!);
                                    } else {
                                      progress.dismiss();
                                      toast(message);
                                    }
                                  }
                                },
                                child: Text('selanjutnya'),
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
  static const String ROUTE_NAME = '/forgot_password2';
  final User user;

  ForgotPasswordSectionTwo({required this.user});

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

  void getAnsAndIndex(UserQuestion userQuestion) {
    userAnswer.clear();
    userAnswer.add(userQuestion.ans1 ?? '');
    userAnswer.add(userQuestion.ans2 ?? '');
    userAnswer.add(userQuestion.ans3 ?? '');
    index.clear();
    index.add(userQuestion.quest1 ?? 1);
    index.add(userQuestion.quest2 ?? 1);
    index.add(userQuestion.quest3 ?? 1);

    print('index: ${index.length}');
  }

  void populateData(BuildContext context) async {
    final provider = Provider.of<QuestionNotifier>(context, listen: false);

    if (provider.userQuestionState == RequestState.Loaded) {
      print('question length : ${provider.question.length}');
      questionMap = provider.questionMap;
      getAnsAndIndex(provider.userQuestion);
      _inputQuestion.text =
          questionMap[index.isNotEmpty ? index[0] : 1] as String;
    } else {
      toast(provider.userQuestionMessage);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<QuestionNotifier>(context, listen: false)
        ..fetchQuestions()
        ..getUserSecurityQuestion(widget.user.id),
    );
    // getAnsAndIndex();
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
          builder: (context) {
            populateData(context);
            return Container(
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
                  TextField(
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
                        onPressed: () async {
                          // TOKENNYA MANAAAAAA !!!!!!
                          await Provider.of<UserNotifier>(context,
                                  listen: false)
                              .reset(widget.user.email, '');

                          final message =
                              Provider.of<UserNotifier>(context, listen: false)
                                  .resetMessage;

                          if (message == UserNotifier.messageReset) {
                            toast(message);
                          } else {
                            toast(message);
                          }
                        },
                        child: Text('Selanjutnya'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
