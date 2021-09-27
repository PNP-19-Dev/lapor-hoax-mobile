class OtpStatus {
  final status;

  OtpStatus({required this.status});

  factory OtpStatus.fromJson(Map<String, dynamic> json) => OtpStatus(
        status: json['status'],
      );
}
