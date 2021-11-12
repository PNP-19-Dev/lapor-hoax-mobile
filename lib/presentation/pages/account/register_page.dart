import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laporhoax/domain/entities/register.dart';
import 'package:laporhoax/presentation/pages/account/login_page.dart';
import 'package:laporhoax/presentation/pages/account/user_challenge.dart';
import 'package:laporhoax/presentation/provider/register_cubit.dart';
import 'package:laporhoax/styles/colors.dart';
import 'package:laporhoax/utils/navigation.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  static const String ROUTE_NAME = "/register_page";

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
    final _formKey = GlobalKey<FormState>();
    final _confirmFocusNode = FocusNode();

    return Scaffold(
      body: ProgressHUD(
        child: Builder(
          builder: (context) => SafeArea(
            child: Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigation.back(),
                          icon: Icon(Icons.arrow_back),
                        ),
                      ],
                    ),
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
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: Colors.black),
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
                              if (value!.toString() !=
                                  _passwordController.text) {
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () =>
                                      Navigation.intent(LoginPage.ROUTE_NAME),
                                  child: Text(
                                    'Masuk disini',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          color: orangeBlaze,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                BlocListener<RegisterCubit, RegisterState>(
                                  listener: (context, state) {
                                    final progress = ProgressHUD.of(context);
                                    if (state is Registering) {
                                      progress!.showWithText('Loading...');
                                    }

                                    if (state is RegisterError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(state.message),
                                        ),
                                      );
                                    } else if (state is RegisterSuccess) {
                                      Navigation.intentWithData(
                                        UserChallenge.ROUTE_NAME,
                                        state.id,
                                      );
                                    }
                                  },
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        var userData = Register(
                                          name: _usernameController.text
                                              .toString(),
                                          email:
                                              _emailController.text.toString(),
                                          password: _passwordController.text
                                              .toString(),
                                        );

                                        context
                                            .read<RegisterCubit>()
                                            .register(userData);
                                      }
                                    },
                                    child: Text('Selanjutnya'),
                                  ),
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
      ),
    );
  }
}
