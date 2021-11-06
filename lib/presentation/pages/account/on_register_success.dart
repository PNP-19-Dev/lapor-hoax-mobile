import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laporhoax/presentation/pages/account/login_page.dart';
import 'package:laporhoax/utils/navigation.dart';

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
              Text(
                message,
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 9),
              Text(
                '''Selamat pendaftaran akunmu berhasil.
                Silahkan login untuk melanjutkan''',
                style: Theme.of(context).textTheme.headline6,
              ),
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
