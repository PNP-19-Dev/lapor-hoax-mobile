import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  static String routeName = "/login_page";

  @override
  Widget build(BuildContext context) {
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
                borderRadius: BorderRadius.circular(20),
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
                  Text('Masuk', style: TextStyle(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Colors.black54,
                            height: 60,
                            width: 60,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: Colors.black54,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('Masih belum mempunyai akun? daftar disini'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
