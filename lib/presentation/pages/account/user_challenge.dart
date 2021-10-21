import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/models/user_question_model.dart';
import 'package:laporhoax/domain/entities/question.dart';
import 'package:laporhoax/presentation/provider/user_notifier.dart';
import 'package:laporhoax/presentation/widget/toast.dart';
import 'package:provider/provider.dart';

class UserChallenge extends StatefulWidget {
  final int id;

  static String routeName = '/challenge';

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
    Future.microtask(() =>
        Provider.of<UserNotifier>(context, listen: false)..fetchQuestions());
  }

  void postResult(BuildContext context, UserQuestionModel challenge) async {
    var progress = ProgressHUD.of(context);
    progress!.showWithText('Memeriksa pertanyaan');

    /*result.then((value) {
      print('result status: $value');
      progress.dismiss();
      toast('Berhasil diperbarui!');
      Navigation.intent(HomePage.routeName);
    }).onError((error, stackTrace) {
      progress.dismiss();
      print(error);
      toast('error $error');
    });*/
  }

  @override
  Widget build(BuildContext context) {
    String loading = "Mengambil data...";

    return ProgressHUD(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            title: Text('Atur Pertanyaan Rahasia'),
          ),
          body: SingleChildScrollView(
            child: Consumer<UserNotifier>(
              builder: (context, provider, child) {
                var progress = ProgressHUD.of(context);

                if (provider.questionState == RequestState.Loading) {
                  progress!.showWithText('Mengambil Pertanyaan');
                } else if (provider.questionState == RequestState.Loaded) {
                  progress!.dismiss();
                  questions = provider.question;
                } else {
                  toast(provider.questionMessage);
                }

                return Form(
                  key: _formKey,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
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
                          hint: Text('Category'),
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
                              toast(loading);
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
                          hint: Text('Category'),
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
                              toast(loading);
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
                          hint: Text('Category'),
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
                              toast(loading);
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
                              int question1 = _selectedQ1;
                              int question2 = _selectedQ2;
                              int question3 = _selectedQ3;
                              String ans1 = _ans1.text;
                              String ans2 = _ans2.text;
                              String ans3 = _ans3.text;

                              print('userID ${widget.id}');
                              var challenge = UserQuestionModel(
                                user: widget.id.toString(),
                                quest1: question1,
                                quest2: question2,
                                quest3: question3,
                                ans1: ans1,
                                ans2: ans2,
                                ans3: ans3,
                              );

                              postResult(context, challenge);
                            },
                            child: Text('Daftar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
