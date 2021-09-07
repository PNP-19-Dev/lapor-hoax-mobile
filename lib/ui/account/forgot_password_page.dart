import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  static String routeName = '/forgot_password';

  @override
  Widget build(BuildContext context) {
    var _inputUser = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
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
                  Text("Lupa Password", style: TextStyle(fontSize: 30.0)),
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
                onPressed: () {},
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
