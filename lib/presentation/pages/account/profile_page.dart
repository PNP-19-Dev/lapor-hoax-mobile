import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/presentation/pages/account/change_user_question.dart';
import 'package:laporhoax/presentation/pages/account/password_change_page.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/styles/colors.dart';
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
  late SessionData? data;

  @override
  void initState() {
    super.initState();
    context.read<LoginCubit>().fetchSession();
    data = context.read<LoginCubit>().session;
  }

  @override
  Widget build(BuildContext context) {
    data != null
        ? _usernameController.text = data!.username
        : _usernameController.text = '';
    data != null
        ? _emailController.text = data!.email
        : _emailController.text = '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 100),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      decoration: InputDecoration(
                        hintText: 'Username',
                        icon: Icon(Icons.person_outline, color: orangeBlaze),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Email',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        icon: Icon(Icons.email_outlined, color: orangeBlaze),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigation.intentWithData(
                            ChangeUserQuestion.ROUTE_NAME, data?.userid ?? -1),
                        child: Text('Ubah Pertanyaan Keamanan'),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigation.intent(PasswordChangePage.ROUTE_NAME),
                        child: Text('Ganti Password'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
