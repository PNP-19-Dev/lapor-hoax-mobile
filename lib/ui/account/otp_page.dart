import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:laporhoax/common/navigation.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/otp_status.dart';

class OtpPage extends StatelessWidget {
  static String routeName = '/otp_page';

  final email;

  OtpPage({required this.email});

  var _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var client = Client();
    var api = LaporhoaxApi(client);

    Future<OtpStatus> verifyUser(String email, String otp) async {
      return await api.verifyOtp(email, otp);
    }

    var currentFocus;

    unfocus() {
      currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigation.back(),
                child: Icon(Icons.arrow_back),
              ),
              Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/sms_send.svg',
                      height: 200,
                    ),
                    SizedBox(height: 22.2),
                    Text(
                      'Kode Verifikasi',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Kami telah mengirimkan kode verifikasi ke @emailuser',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFBABABA),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.go,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: (value) {
                        print('${value.toString()}');
                        if (value!.length == 6) {
                          unfocus();
                          var auth = verifyUser(email, value);

                          auth
                              .then((authValue) {})
                              .onError((error, stackTrace) {
                            _otpController.clear();
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Kirim Ulang Kode',
                        textAlign: TextAlign.end,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Color(0xFFF96C00),
                        ),
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
