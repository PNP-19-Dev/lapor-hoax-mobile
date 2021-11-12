/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.49
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/presentation/provider/password_cubit.dart';
import 'package:provider/provider.dart';

class PasswordChangePage extends StatefulWidget {
  static const String ROUTE_NAME = '/password_change';

  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  var _oldPassword = TextEditingController();
  var _newPassword = TextEditingController();
  var _confirmPassword = TextEditingController();
  var _token = '';

  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().fetchSession();
  }

  void clearAll() {
    _oldPassword.clear();
    _newPassword.clear();
    _confirmPassword.clear();
  }

  @override
  Widget build(BuildContext context) {
    showSnackBar(String message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Ganti Password'),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocListener<PasswordCubit, PasswordState>(
              listener: (context, state) {
                final progress = ProgressHUD.of(context);

                if (state is PasswordLoading) {
                  progress!.showWithText('Loading...');
                }

                if (state is PasswordChanged) {
                  progress!.dismiss();
                  clearAll();
                  showSnackBar('Password telah diganti!');
                } else if (state is PasswordError) {
                  progress!.dismiss();
                  clearAll();
                  showSnackBar(state.message);
                }
              },
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Password Lama',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _oldPassword,
                      obscureText: _obscureText,
                      enableSuggestions: false,
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
                          return 'Mohon isikan password lama!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Password Baru',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _newPassword,
                      obscureText: _obscureText,
                      enableSuggestions: false,
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
                          return 'Mohon isikan password lama!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Password Konfirmasi Password',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _confirmPassword,
                      obscureText: _obscureText,
                      enableSuggestions: false,
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
                        if (value!.toString() != _newPassword.text) {
                          return 'Password tidak sama!';
                        }

                        if (value.trim().isEmpty) {
                          return 'Mohon isikan password!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: BlocListener<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginSuccessWithData) {
                            _token = state.data.token;
                          }
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<PasswordCubit>().changePassword(
                                  _oldPassword.text.toString(),
                                  _newPassword.text.toString(),
                                  _token);
                            }
                          },
                          child: Text('Ganti Kata Sandi'),
                        ),
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
