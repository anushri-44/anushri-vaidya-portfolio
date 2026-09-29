class AdminLoginResponse {
  final String accessToken;
  final String tokenType;

  AdminLoginResponse({
    required this.accessToken,
    required this.tokenType,
  });

  factory AdminLoginResponse.fromJson(Map<String, dynamic> json) {
    return AdminLoginResponse(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
    );
  }
}