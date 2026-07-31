import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  SharedPrefService._();

  static const String tokenKey = "talkLOOP";
  static const String themeKey = "TalkLoopTheMEMode";

  //Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  //Theme

  static Future<void>saveThemeMode(String themeMode)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeKey, themeMode);
  }
  static Future<String?>getThemeMode()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(themeKey);
  }


}