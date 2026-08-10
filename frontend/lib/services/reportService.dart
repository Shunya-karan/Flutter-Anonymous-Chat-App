import 'package:dio/dio.dart';
import 'package:frontend/core/constants/apiConstants.dart';
import 'package:frontend/core/network/apiClient.dart';


class ReportService {
  ReportService._();

  static Future<Response> report({
    required String reportedUserId,
    required String reason,
  }) async {
    return await ApiClient.dio.post(
      "${ApiConstants.reportUser}/$reportedUserId",
      data: {
        "reason": reason,
      },
    );
  }
}