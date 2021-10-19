import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/user_register.dart';
import 'package:laporhoax/data/models/user_login.dart';
import 'package:laporhoax/presentation/pages/account/user_challenge.dart';

class RegisterPage extends StatefulWidget {
  static String routeName = "/register_page";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;

  var _usernameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _samePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var api = LaporhoaxApi();

    Future<UserRegister> getResponse(UserLogin user) async {
      return await api.postRegister(user);
    }

    void toast(String message) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    final _formKey = GlobalKey<FormState>();
    final _confirmFocusNode = FocusNode();

    return Scaffold(
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Container(
            padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/logo_new.png',
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Daftar",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          autofillHints: [AutofillHints.username],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            icon:
                                Icon(Icons.person_outline, color: orangeBlaze),
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Mohon isikan username!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Email',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: [AutofillHints.email],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            icon:
                                Icon(Icons.email_outlined, color: orangeBlaze),
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Mohon isikan username!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Kata Sandi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: _passwordController,
                          autofillHints: [
                            AutofillHints.newPassword,
                            AutofillHints.password,
                          ],
                          keyboardType: TextInputType.text,
                          obscureText: _obscureText,
                          enableSuggestions: false,
                          autocorrect: false,
                          onEditingComplete: () =>
                              _confirmFocusNode.requestFocus(),
                          decoration: InputDecoration(
                            hintText: 'Kata Sandi',
                            icon:
                                Icon(FontAwesomeIcons.key, color: orangeBlaze),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Mohon isikan password!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Masukkan ulang Kata Sandi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: _samePasswordController,
                          autofillHints: [AutofillHints.password],
                          keyboardType: TextInputType.text,
                          obscureText: _obscureText,
                          enableSuggestions: false,
                          focusNode: _confirmFocusNode,
                          autocorrect: false,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: 'Masukkan ulang Kata Sandi',
                            icon:
                                Icon(FontAwesomeIcons.key, color: orangeBlaze),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.toString() != _passwordController.text) {
                              return 'Password tidak sama!';
                            }
                            if (value.trim().isEmpty) {
                              return 'Mohon isikan password!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Masuk disini',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: orangeBlaze),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final progress = ProgressHUD.of(context);

                                  if (_formKey.currentState!.validate()) {
                                    var username =
                                        _usernameController.text.toString();
                                    var email =
                                        _emailController.text.toString();
                                    var password =
                                        _passwordController.text.toString();

                                    progress!.showWithText('Loading...');

                                    var userData = UserLogin(
                                      name: username,
                                      email: email,
                                      password: password,
                                    );
                                    var response = getResponse(userData);

                                    print('loading...');
                                    response.then((value) {
                                      progress.dismiss();
                                      print(value);
                                      toast('Akun terdaftar! Silakan Login');
                                      Navigation.intentWithData(
                                          UserChallenge.routeName,
                                          value.user.id);
                                    }).onError((error, stackTrace) {
                                      progress.dismiss();
                                      toast('$error');
                                      print('$error');
                                    });
                                  }
                                },
                                child: Text('Selanjutnya'),
                              ),
                            ],
                          ),
                        ),
                      ],
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
