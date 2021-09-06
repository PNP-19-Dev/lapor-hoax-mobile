import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:laporhoax/api/google_signin_api.dart';
import 'package:laporhoax/ui/register_page.dart';

class LoginPage extends StatelessWidget {
  static String routeName = "/login_page";

  @override
  Widget build(BuildContext context) {
    Future signIn() async {
      final user = await GoogleSignInApi.login();

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign in failed'),
        ));
      }
    }

    Future facebookSignIn() async {
      final user = await FacebookAuth.instance.login();

      if (user.status == LoginStatus.failed) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign in failed'),
        ));
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFBABABA),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 100,
            left: 10,
            right: 10,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(33),
                child: Container(
                  color: Colors.black54,
                  height: 80,
                  width: 80,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                  color: Color(0xFFFAFAFA)),
              height: 400,
              padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
              child: Column(
                children: [
                  Text('Masuk',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.people_outline),
                      labelText: 'username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key_outlined),
                      labelText: 'password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  Text('Lupa password?', style: TextStyle()),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Login'),
                    ),
                  ),
                  Center(child: Text('atau')),
                  SignInButton(Buttons.GoogleDark, onPressed: signIn),
                  SignInButton(Buttons.Facebook, onPressed: facebookSignIn),
                  Wrap(
                    children: [
                      Text('Masih belum mempunyai akun?'),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.routeName);
                        },
                        child: Text(
                          'Daftar disini',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
