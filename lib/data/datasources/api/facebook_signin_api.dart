import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignInApi {
  static final _facebookSignIn = FacebookAuth.instance;

  static Future<LoginResult?> login() => _facebookSignIn.login();

  static Future logout() => _facebookSignIn.logOut();
}
