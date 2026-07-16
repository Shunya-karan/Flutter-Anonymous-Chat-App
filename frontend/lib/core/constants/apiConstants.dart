class ApiConstants {
  ApiConstants._();

  // static const String host = "10.91.62.243";
  static const String host = "localhost";

  static const String baseUrl = "http://$host:3000/api";
  static const String socketUrl = "http://$host:3000";
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String me = "/auth/me";
  static const String updateProfile = "/users/update-profile";
  static const String changePassword = "/users/change-password";
}