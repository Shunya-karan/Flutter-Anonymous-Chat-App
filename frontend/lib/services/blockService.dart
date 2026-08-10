import 'package:dio/dio.dart';
import 'package:frontend/core/constants/apiConstants.dart';
import 'package:frontend/core/network/apiClient.dart';


class BlockService{
  BlockService._();

  static Future<Response>block({
    required String blockedUserId,
})async{
    return await ApiClient.dio.post(
      "${ApiConstants.blockUser}/$blockedUserId",
    );
  }
}