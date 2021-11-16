/*
 * Created by andii on 14/11/21 14.07
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 14.05
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporhoax/presentation/pages/account/account_page.dart';
import 'package:laporhoax/presentation/pages/account/change_user_question.dart';
import 'package:laporhoax/presentation/pages/account/password_change_page.dart';
import 'package:laporhoax/presentation/provider/profile_cubit.dart';
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
    context.read<ProfileCubit>().getData(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileDataFetched) {
          _usernameController.text = state.user.username;
          _emailController.text = state.user.email;
          _id = state.user.id;
        }
      },
      child: Scaffold(
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          return TextFormField(
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: state is ProfileGetData
                                  ? 'Mendapatkan data'
                                  : state is ProfileDataError
                                      ? state.message
                                      : '',
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Text('Email',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          return TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: state is ProfileGetData
                                  ? 'Mendapatkan data'
                                  : state is ProfileDataError
                                      ? state.message
                                      : '',
                            ),
                          );
                        },
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
            ],
          ),
        ),
      ),
    );
  }
}
