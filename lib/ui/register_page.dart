import 'package:flutter/material.dart';
import 'package:laporhoax/ui/home_page.dart';

class RegisterPage extends StatelessWidget{
  static String routeName = "/register_page";

  @override
  Widget build(BuildContext context){
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
              height: 450,
              padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
              child: Column(
                children: [
                  Text('Daftar', style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_outline),
                      labelText: 'Username',
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.email_outlined),
                      labelText: 'Email',
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone_enabled_outlined),
                      labelText: 'No. Telepon',
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key_outlined),
                      labelText: 'Kata Sandi',
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key_outlined),
                      labelText: 'Masukkan Ulang Kata Sandi',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:20, right:20, top:8),
                      child: SizedBox(
                        width: double.infinity,
                          child: ElevatedButton(
                              onPressed: (){},
                              child: Text('Daftar'),
                          )
                      )
                  ),

                  Center(
                    child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                        Text('Sudah mempunyai akun?'),
                        SizedBox(
                          width: 5,
                        ),
                    GestureDetector(
                      onTap: () {
                          Navigator.pushNamed(context, HomePage.routeName);
                        },
                        child: Text(
                          'Masuk disini',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]
                  ),
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