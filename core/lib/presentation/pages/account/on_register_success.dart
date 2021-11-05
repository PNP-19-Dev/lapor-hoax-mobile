import 'package:core/utils/navigation.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
              const SizedBox(height: 32),
              Text(message,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              const SizedBox(height: 9),
              Text('''Selamat pendaftaran akunmu berhasil.
                Silahkan login untuk melanjutkan''',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: Navigation.intent(loginRoute),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
