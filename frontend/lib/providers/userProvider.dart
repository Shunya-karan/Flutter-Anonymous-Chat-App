import 'package:flutter/material.dart';
import 'package:frontend/models/userModel.dart';
import 'package:frontend/services/userServices.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  bool get hasUser => _user != null;

  Future<void> loadUser() async {
    _user = await UserService.getProfile();
    notifyListeners();
  }

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await loadUser();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}