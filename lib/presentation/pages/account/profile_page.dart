/*
 * Created by andii on 14/11/21 01.40
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 13/11/21 22.11
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporhoax/presentation/pages/account/account_page.dart';
import 'package:laporhoax/presentation/pages/account/change_user_question.dart';
import 'package:laporhoax/presentation/pages/account/password_change_page.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/utils/navigation.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const ROUTE_NAME = '/profile_page';

  final String email;

  ProfilePage({required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  var _usernameController = TextEditingController();
  var _emailController = TextEditingController();
  int _id = 0;

  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().fetchSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocListener<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccessWithData) {
                    _usernameController.text = state.data.username;
                    _emailController.text = state.data.email;
                    _id = state.data.userid;
                  }
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        enabled: false,
                      ),
                      SizedBox(height: 10),
                      Text('Email',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: false,
                      ),
                      SizedBox(height: 10),
                      Divider(
                        height: 10,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(height: 10),
                      BuildCard(
                        Icons.vpn_key_outlined,
                        'Ubah Kata Sandi',
                            () => Navigation.intent(PasswordChangePage.ROUTE_NAME),
                      ),
                      BuildCard(
                        Icons.vpn_key_outlined,
                        'Ubah Pertanyaan Keamanan',
                            () => Navigation.intentWithData(
                            ChangeUserQuestion.ROUTE_NAME, _id),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
