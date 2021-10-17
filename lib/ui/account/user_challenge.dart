import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/challenge.dart';
import 'package:laporhoax/data/model/user_question.dart';
import 'package:laporhoax/ui/home_page.dart';
import 'package:laporhoax/util/widget/toast.dart';

class UserChallenge extends StatefulWidget {
  final id;

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

  List<QuestionResult> _q1 = [];
  List<QuestionResult> _q2 = [];
  List<QuestionResult> _q3 = [];
  final api = LaporhoaxApi();

  void getQuestions() async {
    final response = await api.getQuestions();
    var listData = response;
    setState(() {
      _q1 = listData.results;
      _q2 = listData.results;
      _q3 = listData.results;
    });
  }

  @override
  initState() {
    super.initState();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        child: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text('Atur Pertanyaan Rahasia'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  iconSize: 0,
                  decoration: InputDecoration(
                    icon: Image.asset('assets/icons/question.png'),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  hint: Text('Category'),
                  value: _selectedQ1,
                  items: _q1.map((value) {
                    return DropdownMenuItem<String>(
                      child: Text(value.question),
                      value: value.question,
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedQ1 = v!;
                    });
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: _ans1,
                  decoration: InputDecoration(
                    labelText: 'jawaban pertanyaan 1',
                    icon: Image.asset('assets/icons/ans.png'),
                    labelStyle: TextStyle(
                      color:
                          _linkFocusNode.hasFocus ? orangeBlaze : Colors.black,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  iconSize: 0,
                  decoration: InputDecoration(
                    icon: Image.asset('assets/icons/question.png'),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  hint: Text('Category'),
                  value: _selectedQ2,
                  items: _q2.map((value) {
                    return DropdownMenuItem<String>(
                      child: Text(value.question),
                      value: value.question,
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedQ2 = v!;
                    });
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: _ans2,
                  decoration: InputDecoration(
                    labelText: 'jawaban pertanyaan 1',
                    icon: Image.asset('assets/icons/ans.png'),
                    labelStyle: TextStyle(
                      color:
                          _linkFocusNode.hasFocus ? orangeBlaze : Colors.black,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  iconSize: 0,
                  decoration: InputDecoration(
                    icon: Image.asset('assets/icons/question.png'),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  hint: Text('Category'),
                  value: _selectedQ3,
                  items: _q3.map((value) {
                    return DropdownMenuItem<String>(
                      child: Text(value.question),
                      value: value.question,
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedQ3 = v!;
                    });
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: _ans3,
                  decoration: InputDecoration(
                    labelText: 'jawaban pertanyaan 1',
                    icon: Image.asset('assets/icons/ans.png'),
                    labelStyle: TextStyle(
                      color:
                          _linkFocusNode.hasFocus ? orangeBlaze : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String question1 = _selectedQ1;
                    String question2 = _selectedQ2;
                    String question3 = _selectedQ3;
                    String ans1 = _ans1.text;
                    String ans2 = _ans2.text;
                    String ans3 = _ans3.text;

                    var challenge = Challenge(
                      quest1: question1,
                      quest2: question2,
                      quest3: question3,
                      ans1: ans1,
                      ans2: ans2,
                      ans3: ans3,
                    );

                    var progress = ProgressHUD.of(context);
                    var result = api.postSecurityQNA(widget.id, challenge);
                    progress!.showWithText('Memeriksa pertanyaan');

                    result.then((value) {
                      print('result status: $value');
                      progress.dismiss();
                      Navigation.intent(HomePage.routeName);
                    }).onError((error, stackTrace) {
                      progress.dismiss();
                      print(error);
                      toast('error');
                    });
                  },
                  child: Text('Daftar'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
