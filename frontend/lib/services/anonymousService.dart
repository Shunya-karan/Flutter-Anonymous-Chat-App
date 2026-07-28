import 'package:dio/dio.dart';
import 'package:frontend/core/constants/apiConstants.dart';
import 'package:frontend/core/network/apiClient.dart';
import 'package:frontend/models/anonymousProfileModel.dart';

class AnonymousService {
  AnonymousService._();

  // generateAnonymousName
  static Future<Response>generateAnonymousName()async{
    final response= await ApiClient.dio.get(
      ApiConstants.generateAnonymousName,
    );
    return response;
  }

  // createAnonymousProfile
  static Future <Response>createAnonymousProfile({
    required String displayName,
    required String avatar
  })async{
    final response = await ApiClient.dio.post(
        ApiConstants.generateAnonymousProfile,
    data: {
      "displayName":displayName,
      "avatar":avatar
    });
    return response;
  }
  // getAnonymousProfile
  static Future <AnonymousProfileModel>getAnonymousProfile()async{
    final response = await ApiClient.dio.get(
      ApiConstants.getAnonymousProfile
    );
    if (response.data != null && response.data["profile"] != null) {
      return AnonymousProfileModel.fromJson(response.data["profile"]);
    } else {
      throw Exception("Failed to load anonymous profile data");
    }
  }

  // updateAnonymousProfile
  static Future<Response>updateAnonymousProfile({
    required String displayName,
    required String avatar,
})async{
    final response = await ApiClient.dio.put(
      ApiConstants.updateAnonymousProfile,
      data: {
        "displayName":displayName,
        "avatar":avatar
      }
    );
    return response;
  }
}