
class AuthService {
  static String? _accessToken;

  static String? get accessToken => _accessToken;

  static bool get isAuthenticated =>
      _accessToken != null && _accessToken!.isNotEmpty;

  static void setToken(String token) {
    _accessToken = token;
  }

  static void clearToken() {
    _accessToken = null;
  }
}