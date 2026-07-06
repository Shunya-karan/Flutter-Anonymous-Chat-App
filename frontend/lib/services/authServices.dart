import 'package:dio/dio.dart';
import 'package:frontend/core/constants/apiConstants.dart';
import 'package:frontend/core/network/apiClient.dart';

class authService{
  authService._();

  static Future<Response>login({
    required String identifier,
    required String password
})async{
    return await ApiClient.dio.post(
      ApiConstants.login,
      data: {
        "identifier":identifier,
        "password":password
      }
    );
  }
}