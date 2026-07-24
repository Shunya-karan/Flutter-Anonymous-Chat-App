import 'package:dio/dio.dart';
import 'package:frontend/core/constants/apiConstants.dart';
import 'package:frontend/core/network/apiClient.dart';
import 'dart:io';

import 'package:frontend/models/userModel.dart';


class UserService{
  UserService._();

  static Future <Response>updateProfile({
    String? username,
    required String gender,
    required String bio,
    required List<String> interests,
    File? profileImage,
  }) async {
    final formData = FormData();
    if (username != null && username.trim().isNotEmpty) {
      formData.fields.add(MapEntry("username", username.trim()));
    }
    formData.fields.add(MapEntry("gender", gender));
    formData.fields.add(MapEntry("bio", bio));
    for (final interest in interests){
      formData.fields.add(MapEntry("interests", interest));
    }
    if(profileImage !=null){
      final multipartFile = await MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.path.split("/").last,
      );
      formData.files.add(MapEntry("profileImage", multipartFile));
    }
   return await ApiClient.dio.put(ApiConstants.updateProfile,data: formData);
  }

  static Future<UserModel> getProfile() async {
    final response = await ApiClient.dio.get(ApiConstants.me);
    if (response.data != null && response.data["data"] != null) {
      return UserModel.fromJson(response.data["data"]);
    } else {
      throw Exception("Failed to load user profile data");
    }
  }
}