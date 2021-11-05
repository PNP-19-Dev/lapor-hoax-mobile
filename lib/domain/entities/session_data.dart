class SessionData {
  final String token;
  final int userid;
  final String expiry;
  final String email;
  final String username;

  SessionData({
    required this.token,
    required this.userid,
    required this.expiry,
    required this.email,
    required this.username,
  });
}
