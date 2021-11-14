/*
 * Created by andii on 14/11/21 14.07
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 11.08
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laporhoax/presentation/pages/account/forgot_password_page.dart';
import 'package:laporhoax/presentation/pages/account/register_page.dart';
import 'package:laporhoax/presentation/pages/home_page.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/styles/colors.dart';
import 'package:laporhoax/utils/navigation.dart';

class LoginPage extends StatefulWidget {
  static const String ROUTE_NAME = "/login_page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 35,
                            left: 50,
                            right: 50,
                            bottom: 40,
                          ),
                          child: Text(
                            "Selamat Datang Kembali",
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.center,
                          ),
                        ),
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
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          enableSuggestions: true,
                          autofillHints: [AutofillHints.username],
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Mohon isikan alamat email anda!';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25),
                        Text('Kata Sandi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          autofillHints: [AutofillHints.password],
                          keyboardType: TextInputType.text,
                          obscureText: _obscureText,
                          enableSuggestions: false,
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
                            onTap: () => Navigation.intent(
                                ForgotPasswordSectionOne.ROUTE_NAME),
                            child: Container(
                              child: Text('Lupa Password ?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(color: orangeBlaze),
                                  textAlign: TextAlign.end),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    Navigation.intent(RegisterPage.ROUTE_NAME),
                                child: Text(
                                  'Daftar Akun',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: orangeBlaze,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              BlocListener<LoginCubit, LoginState>(
                                listener: (context, state) {
                                  final progress = ProgressHUD.of(context);
                                  if (state is Login) {
                                    progress?.showWithText('Loading...');
                                  } else if (state is LoginFailure) {
                                    progress!.dismiss();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                      ),
                                    );
                                  } else if (state is LoginSuccess) {
                                    progress!.dismiss();
                                    Navigation.intent(HomePage.ROUTE_NAME);
                                  }
                                },
                                child: SizedBox(
                                  width: 130.0,
                                  height: 42.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<LoginCubit>().login(
                                              _usernameController.text
                                                  .toString(),
                                              _passwordController.text
                                                  .toString(),
                                            );
                                      }
                                    },
                                    child: Text('Login'),
                                  ),
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
    );
  }
}
