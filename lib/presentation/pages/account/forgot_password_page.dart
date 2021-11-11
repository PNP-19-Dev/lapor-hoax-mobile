import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/presentation/pages/account/login_page.dart';
import 'package:laporhoax/presentation/provider/password_cubit.dart';
import 'package:laporhoax/presentation/provider/question_cubit.dart';
import 'package:laporhoax/presentation/widget/toast.dart';
import 'package:laporhoax/styles/colors.dart';
import 'package:laporhoax/utils/navigation.dart';
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
      appBar: AppBar(elevation: 0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          TextFormField(
                            controller: _inputEmail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
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
                              BlocListener<PasswordCubit, PasswordState>(
                                listener: (context, state) {
                                  final progress = ProgressHUD.of(context);

                                  if (state is PasswordLoading) {
                                    progress!
                                        .showWithText("Mendapatkan Data..");
                                  }

                                  if (state is UserHasData) {
                                    progress!.dismiss();
                                    Navigation.intentWithData(
                                        ForgotPasswordSectionTwo.ROUTE_NAME,
                                        state.data);
                                  } else if (state is PasswordError) {
                                    progress!.dismiss();
                                    toast(state.message);
                                  }
                                },
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<PasswordCubit>().getUserData(
                                          _inputEmail.text.toString());
                                    }
                                  },
                                  child: Text('selanjutnya'),
                                ),
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
  var i = 0;

  @override
  void initState() {
    super.initState();
    context.read<QuestionCubit>().fetchQuestionWithChallenge(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('Pertanyaan Rahasia'),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) {
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
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  BlocListener<QuestionCubit, QuestionState>(
                    listener: (context, state) {
                      final progress = ProgressHUD.of(context);

                      if (state is QuestionLoading) {
                        progress!.show();
                        _inputQuestion.text = 'Mendapatkan Data';
                      }

                      if (state is ChallengeSuccess) {
                        progress?.dismiss();
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                insetPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                content: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Password Baru',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text('12345678',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text(
                                        'Ini adalah password barumu. Silakan masuk untuk melanjutkan',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                        textAlign: TextAlign.center,
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pushNamed(
                                          context,
                                          LoginPage.ROUTE_NAME,
                                        ),
                                        child: Text('Masuk'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else if (state is ChallengeError) {
                        progress?.dismiss();
                        toast(state.message);
                      }

                      if (state is QuestionHasData) {
                        progress?.dismiss();
                        questionMap = state.questionMap!;
                        index = state.index!;
                        userAnswer = state.userQuestion!;
                        _inputQuestion.text =
                            state.questionMap![state.index![0]]!;
                      } else if (state is QuestionError) {
                        progress?.dismiss();
                        _inputQuestion.text = 'Gagal Mendapatkan Data';
                      }
                    },
                    child: TextField(
                      controller: _inputQuestion,
                      enabled: false,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Jawaban',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  TextField(
                    controller: _inputAnswer,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      i++;
                      if (i >= 3) i = 0;
                      int nilai = index[i];
                      var _newValue = questionMap[nilai] as String;

                      _inputQuestion.value = TextEditingValue(
                        text: _newValue,
                        selection: TextSelection.fromPosition(
                          TextPosition(offset: _newValue.length),
                        ),
                      );
                    },
                    child: Container(
                      child: Text(
                        'Ganti Pertanyaan?',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: orangeBlaze),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<PasswordCubit>()
                              .resetPassword(widget.user.email);

                          toast(
                              'Mohon Maaf, Jawaban Anda salah, silakan ulangi');
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
