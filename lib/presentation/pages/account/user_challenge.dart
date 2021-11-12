import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:laporhoax/domain/entities/question.dart';
import 'package:laporhoax/domain/entities/user_question.dart';
import 'package:laporhoax/presentation/pages/account/on_register_success.dart';
import 'package:laporhoax/presentation/provider/question_cubit.dart';
import 'package:laporhoax/presentation/widget/toast.dart';
import 'package:laporhoax/styles/colors.dart';
import 'package:laporhoax/utils/navigation.dart';
import 'package:provider/provider.dart';

class UserChallenge extends StatefulWidget {
  final int id;

  static const String ROUTE_NAME = '/challenge';

  UserChallenge({required this.id});

  @override
  _UserChallengeState createState() => _UserChallengeState();
}

class _UserChallengeState extends State<UserChallenge> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _linkFocusNode = new FocusNode();
  var _selectedQ1, _selectedQ2, _selectedQ3;
  var _ans1 = TextEditingController();
  var _ans2 = TextEditingController();
  var _ans3 = TextEditingController();
  List<Question> questions = [];

  @override
  initState() {
    super.initState();
    context.read<QuestionCubit>().fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Atur Pertanyaan Rahasia'),
      ),
      body: BlocListener<QuestionCubit, QuestionState>(
        listener: (_, state) {
          var progress = ProgressHUD.of(context);

          if (state is QuestionLoading) {
            progress!.showWithText('Memeriksa pertanyaan');
          } else if (state is QuestionHasData) {
            questions = state.questions;
          } else if (state is QuestionError) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(state.message),
                  );
                });
          } else if (state is ChallengeError) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(state.message),
                  );
                });
          } else if (state is ChallengeSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Success')));
            Navigation.intentWithData(
                OnRegisterSuccess.ROUTE_NAME, 'Akun berhasil dibuat!');
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pertanyaan 1',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    iconSize: 0,
                    decoration: InputDecoration(
                      icon: Image.asset('assets/icons/question.png'),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    hint: BlocBuilder<QuestionCubit, QuestionState>(
                      builder: (context, state) {
                        if (state is QuestionLoading) {
                          return Text('Loading');
                        } else {
                          return Text('Pilih Pertanyaan');
                        }
                      },
                    ),
                    value: _selectedQ1,
                    items: questions
                        .map((value) {
                          return DropdownMenuItem<int>(
                            child: Text(value.question),
                            value: value.id,
                          );
                        })
                        .where((item) =>
                            item.value != _selectedQ2 &&
                            item.value != _selectedQ3)
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        _selectedQ1 = v!;
                      });
                    },
                    onTap: () {
                      if (questions.isEmpty) {
                        toast('');
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  Text('Jawaban',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _ans1,
                    decoration: InputDecoration(
                      hintText: 'jawaban pertanyaan 1',
                      icon: Image.asset('assets/icons/ans.png'),
                      labelStyle: TextStyle(
                        color: _linkFocusNode.hasFocus
                            ? orangeBlaze
                            : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text('Pertanyaan 2',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    iconSize: 0,
                    decoration: InputDecoration(
                      icon: Image.asset('assets/icons/question.png'),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    hint: BlocBuilder<QuestionCubit, QuestionState>(
                      builder: (context, state) {
                        if (state is QuestionLoading) {
                          return Text('Loading');
                        } else {
                          return Text('Pilih Pertanyaan');
                        }
                      },
                    ),
                    value: _selectedQ2,
                    items: questions
                        .map((value) {
                          return DropdownMenuItem<int>(
                            child: Text(value.question),
                            value: value.id,
                          );
                        })
                        .where((item) =>
                            item.value != _selectedQ1 &&
                            item.value != _selectedQ3)
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        _selectedQ2 = v!;
                      });
                    },
                    onTap: () {
                      if (questions.isEmpty) {
                        toast('');
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  Text('Jawaban',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _ans2,
                    decoration: InputDecoration(
                      hintText: 'jawaban pertanyaan 2',
                      icon: Image.asset('assets/icons/ans.png'),
                      labelStyle: TextStyle(
                        color: _linkFocusNode.hasFocus
                            ? orangeBlaze
                            : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text('Pertanyaan 3',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    iconSize: 0,
                    decoration: InputDecoration(
                      icon: Image.asset('assets/icons/question.png'),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    hint: BlocBuilder<QuestionCubit, QuestionState>(
                      builder: (context, state) {
                        if (state is QuestionLoading) {
                          return Text('Loading');
                        } else {
                          return Text('Pilih Pertanyaan');
                        }
                      },
                    ),
                    value: _selectedQ3,
                    items: questions
                        .map((value) {
                          return DropdownMenuItem<int>(
                            child: Text(value.question),
                            value: value.id,
                          );
                        })
                        .where((item) =>
                            item.value != _selectedQ1 &&
                            item.value != _selectedQ2)
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        _selectedQ3 = v!;
                      });
                    },
                    onTap: () {
                      if (questions.isEmpty) {
                        toast('');
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  Text('Jawaban',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _ans3,
                    decoration: InputDecoration(
                      hintText: 'jawaban pertanyaan 3',
                      icon: Image.asset('assets/icons/ans.png'),
                      labelStyle: TextStyle(
                        color: _linkFocusNode.hasFocus
                            ? orangeBlaze
                            : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<QuestionCubit>()
                              .sendQuestions(UserQuestion(
                                user: widget.id.toString(),
                                quest1: _selectedQ1,
                                quest2: _selectedQ2,
                                quest3: _selectedQ3,
                                ans1: _ans1.text,
                                ans2: _ans2.text,
                                ans3: _ans3.text,
                              ));
                        }
                      },
                      child: Text('Daftar'),
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
