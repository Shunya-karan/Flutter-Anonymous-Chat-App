import 'package:dio/dio.dart';
import 'package:frontend/core/constants/apiConstants.dart';
import 'package:frontend/core/network/apiClient.dart';
import 'dart:io';


class UserService{
  UserService._();

  static Future<Response> updateProfile({
    required String gender,
    required String bio,
    required List<String> interests,
    File? profileImage,
  }) async {
    final formData = FormData();

    formData.fields.add(MapEntry("gender", gender));
    formData.fields.add(MapEntry("bio", bio));
    for (final interest in interests){
      formData.fields.add(MapEntry("interests", interest));
    }
    if(profileImage !=null){
      formData.files.add(MapEntry("profileImage",
      await MultipartFile.fromFile(
        profileImage.path,filename: profileImage.path.split("/").last,
      ),
      ),);
    }
   return await ApiClient.dio.put(ApiConstants.updateProfile,data: formData);
  }
}