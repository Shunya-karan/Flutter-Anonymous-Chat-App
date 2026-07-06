class ApiConstants {
  ApiConstants._();

  // Android Emulator
  // static const String baseUrl = "http://10.0.2.2:3000/api";

  // Windows / Physical Device

  //static const String baseUrl= "http://10.130.78.243:3000/api";
  static const String baseUrl = "http://localhost:3000/api";
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String me = "/users/me";
  static const String updateProfile = "/users/profile";
  static const String changePassword = "/users/change-password";
}