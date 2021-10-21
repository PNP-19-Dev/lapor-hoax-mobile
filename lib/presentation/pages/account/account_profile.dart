import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/presentation/pages/account/password_change_page.dart';
import 'package:laporhoax/presentation/pages/account/user_challenge.dart';
import 'package:laporhoax/presentation/provider/user_notifier.dart';
import 'package:laporhoax/presentation/widget/toast.dart';
import 'package:provider/provider.dart';

class AccountProfile extends StatefulWidget {
  static const routeName = '/account_profile';

  @override
  _AccountProfileState createState() => _AccountProfileState();
}

class _AccountProfileState extends State<AccountProfile> {
  final _formKey = GlobalKey<FormState>();
  var _usernameController = TextEditingController();
  var _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<UserNotifier>(context, listen: false)
      ..getSession()
      ..isLogin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
              child: Consumer<UserNotifier>(
                builder: (context, provider, widget) {
                  var userData = provider.sessionData;

                  _usernameController.text = userData.username;
                  _emailController.text = userData.email;

                  return Form(
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
                            icon:
                                Icon(Icons.person_outline, color: orangeBlaze),
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
                            icon:
                                Icon(Icons.email_outlined, color: orangeBlaze),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigation.intentWithData(
                                UserChallenge.routeName, userData.userid),
                            child: Text('Ubah Pertanyaan Keamanan'),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              String? token =
                                  await FirebaseMessaging.instance.getToken();
                              print('FIREBASE token: $token');

                              if (token != null) {
                                // api.postFcmToken(userData.id.toString(), token);
                                provider.postToken(
                                    userData.userid.toString(), token);
                              } else {
                                toast('error in firebase!');
                              }
                            },
                            child: Text('Kirim Token Ke Server (DEV MODE)'),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigation.intent(PasswordChangePage.routeName),
                            child: Text('Ganti Password'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
