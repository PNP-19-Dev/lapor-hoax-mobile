import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/theme.dart';
import 'package:laporhoax/presentation/provider/user_notifier.dart';
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

  _showSimpleModalDialog(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              constraints: BoxConstraints(maxHeight: 200),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Password berhasil Diganti !',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Selamat password anda berhasil diganti !',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Tutup'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<UserNotifier>(context, listen: false)..getSession());
  }

  @override
  Widget build(BuildContext context) {
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
            child: Consumer<UserNotifier>(
              builder: (context, provider, widget) {
                final progress = ProgressHUD.of(context);

                return Form(
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
                          hintText: 'Old Password',
                          icon: Icon(
                            FontAwesomeIcons.key,
                            color: orangeBlaze,
                          ),
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
                          hintText: 'New Password',
                          icon: Icon(
                            FontAwesomeIcons.key,
                            color: orangeBlaze,
                          ),
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
                          hintText: 'Confirm Password',
                          icon: Icon(
                            FontAwesomeIcons.key,
                            color: orangeBlaze,
                          ),
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
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              String oldPass = _oldPassword.text;
                              String newPass = _newPassword.text;
                              String? token = provider.sessionData?.token;

                              progress!.showWithText('Loading...');

                              print('loading password...');
                              /* response.then((value) {
                                print(value);
                                _showSimpleModalDialog(context);
                              }).onError((error, stackTrace) {
                                toast('Error $error');
                              });*/
                            }
                          },
                          child: Text('Kirim'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
