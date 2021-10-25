import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/presentation/pages/account/login_page.dart';

class OnRegisterSuccess extends StatelessWidget {
  static const String ROUTE_NAME = "/on_success";

  final message;

  OnRegisterSuccess(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset('assets/illustration/otp_success.svg'),
              SizedBox(height: 32),
              Text(message,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              SizedBox(height: 9),
              Text('''Selamat pendaftaran akunmu berhasil.
                Silahkan login untuk melanjutkan''',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: Navigation.intent(LoginPage.ROUTE_NAME),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
