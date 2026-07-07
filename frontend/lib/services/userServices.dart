import 'package:dio/dio.dart';
import 'package:frontend/core/constants/apiConstants.dart';
import 'package:frontend/core/network/apiClient.dart';


class UserService{
  UserService._();

  static Future<Response> updateProfile({
    required String gender,
    required String bio,
    required List<String> interests,
  }) async {
    return ApiClient.dio.put(
      ApiConstants.updateProfile,
      data: {
        "gender": gender,
        "bio": bio,
        "interests": interests,
      },
    );
  }
}