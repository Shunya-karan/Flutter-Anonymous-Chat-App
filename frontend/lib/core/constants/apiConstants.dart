class ApiConstants {
  ApiConstants._();

  // static const String host = "10.224.68.243";
  // static const String host = "localhost";
  static const String host = "flutter-anonymous-chat-app.onrender.com";

  static const String baseUrl = "https://$host/api";
  static const String socketUrl = "https://$host";
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String me = "/auth/me";
  static const String updateProfile = "/users/update-profile";
  static const String changePassword = "/users/change-password";

  static const String generateAnonymousName = "/anonymous/generate-name";
  static const String generateAnonymousProfile = "/anonymous/profile";
  static const String updateAnonymousProfile = "/anonymous/profile";
  static const String getAnonymousProfile = "/anonymous/profile";

  static const String blockUser = "/block";
  static const String reportUser = "/report";


}