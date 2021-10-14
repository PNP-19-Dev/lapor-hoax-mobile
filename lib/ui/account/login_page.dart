import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/data/api/google_signin_api.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/user_data.dart';
import 'package:laporhoax/data/model/user_token.dart';
import 'package:laporhoax/provider/preferences_provider.dart';
import 'package:laporhoax/ui/account/forgot_password_page.dart';
import 'package:laporhoax/ui/account/register_page.dart';
import 'package:laporhoax/ui/home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/login_page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var client = Dio();
    var api = LaporhoaxApi(client);

    Future<UserToken> getToken(String username, String password) async {
      return await api.postLogin(username, password);
    }

    Future<List<User>> getData(String username) async {
      return await api.getUserData(username);
    }

    Future signIn() async {
      final user = await GoogleSignInApi.login();

      if (user != null) {
        var header = await user.authHeaders;
        var authentication = user.authentication.toString();
        print("HEADERS $header");
        print("Auth $authentication}");
        print("User ID ${user.id}");
      }

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign in failed'),
        ));
      }
    }

    // ERROR OVERFLOWED!
    /*Future facebookSignIn() async {
      final user = await FacebookSignInApi.login();

      if (user!.status == LoginStatus.failed) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign in failed'),
        ));
      }
    }*/

    void toast(String message) {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Container(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigation.back(),
                    child: Icon(Icons.arrow_back),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/logo_new.png',
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(height: 10),
                        Text("Login", style: TextStyle(fontSize: 30.0)),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          enableSuggestions: true,
                          autofillHints: [AutofillHints.username],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            icon:
                                Icon(Icons.person_outline, color: orangeBlaze),
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Mohon isikan alamat email anda!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Text('Kata Sandi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: _passwordController,
                          autofillHints: [AutofillHints.password],
                          keyboardType: TextInputType.text,
                          obscureText: _obscureText,
                          enableSuggestions: false,
                          autocorrect: false,
                          textInputAction: TextInputAction.done,
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
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ForgotPassword.routeName);
                            },
                            child: Text('Lupa Password ?',
                                style: GoogleFonts.inter(
                                    color: orangeBlaze,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                                textAlign: TextAlign.end),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RegisterPage.routeName);
                                },
                                child: Text(
                                  'Daftar Akun',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: orangeBlaze,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final progress = ProgressHUD.of(context);
                                  if (_formKey.currentState!.validate()) {
                                    var username =
                                        _usernameController.text.toString();
                                    var password =
                                        _passwordController.text.toString();

                                    progress!.showWithText('Loading...');
                                    var token = getToken(username, password);
                                    var data = getData(username);
                                    var provider =
                                        Provider.of<PreferencesProvider>(
                                            context,
                                            listen: false);

                                    print('loading...');

                                    data.then((value) =>
                                        provider.setUserData(value.first));

                                    token.then(
                                      (value) {
                                        progress.dismiss();
                                        provider.setSessionData(value);
                                        Navigation.intent(HomePage.routeName);
                                      },
                                    ).onError(
                                      (error, stackTrace) {
                                        progress.dismiss();
                                        toast('$error');
                                        print(error);
                                      },
                                    );
                                  }
                                },
                                child: Text('Login'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin:
                              const EdgeInsets.only(left: 10, right: 20),
                              child: Divider(
                                height: 36,
                              ),
                            ),
                          ),
                          Text(
                            'atau',
                            style: TextStyle(color: grey500),
                          ),
                          Expanded(
                            child: Container(
                              margin:
                              const EdgeInsets.only(left: 20, right: 10),
                              child: Divider(
                                height: 36,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      SignInButton(
                        Buttons.Google,
                        text: 'Login dengan Google',
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        onPressed: signIn,
                      ),
/*                      SignInButton(
                        Buttons.FacebookNew,
                        text: 'Login dengan Facebook',
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        onPressed: facebookSignIn,
                      ),*/
                    ],
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
