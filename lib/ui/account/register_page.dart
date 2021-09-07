import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(33),
                      child: Container(
                        color: Color(0xFF999999),
                        height: 80,
                        width: 80,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Daftar", style: TextStyle(fontSize: 30.0)),
                  ],
                ),
              ),
              Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                autofillHints: [AutofillHints.username],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Username',
                  icon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Mohon isikan username!';
                  }
                },
              ),
              SizedBox(height: 10),
              Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: [AutofillHints.email],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Email',
                  icon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Mohon isikan username!';
                  }
                },
              ),
              SizedBox(height: 10),
              Text('Kata Sandi', style: TextStyle(fontWeight: FontWeight.bold)),
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
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Kata Sandi',
                  icon: Icon(FontAwesomeIcons.key),
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
                autocorrect: false,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Masukkan ulang Kata Sandi',
                  icon: Icon(FontAwesomeIcons.key),
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
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Daftar'),
                  ),
                ),
              ),
              Center(
                child: Wrap(
                  children: [
                    Text('Sudah mempunyai akun?'),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Masuk disini',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
