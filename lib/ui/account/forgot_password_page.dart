import 'package:flutter/material.dart';
import 'package:laporhoax/common/navigation.dart';

class ForgotPassword extends StatelessWidget {
  static String routeName = '/forgot_password';

  @override
  Widget build(BuildContext context) {
    var _inputUser = TextEditingController();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: GestureDetector(
                onTap: () => Navigation.back(),
                child: Icon(Icons.arrow_back),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33),
                      child: Container(
                        color: Color(0xFF999999),
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Lupa Password",
                      style: Theme.of(context).textTheme.headline4),
                  Text(
                    'Masukkan username atau email yang terhubung dengan akunmu!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: _inputUser,
              textInputAction: TextInputAction.done,
              autofillHints: [AutofillHints.email, AutofillHints.username],
              decoration: InputDecoration(hintText: 'Username / Email'),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    Navigation.intent(ForgotPasswordAction.routeName),
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordAction extends StatelessWidget {
  static String routeName = '/forgot_action';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: GestureDetector(
                onTap: () => Navigation.back(),
                child: Icon(Icons.arrow_back),
              ),
            ),
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey, shape: BoxShape.circle),
                      width: 81,
                      height: 81,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Username',
                      style: Theme.of(context).textTheme.headline4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
