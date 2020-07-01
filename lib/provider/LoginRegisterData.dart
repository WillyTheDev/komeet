import 'package:flutter/material.dart';

class LoginRegisterData extends ChangeNotifier {
  String email = "email";
  String userName = "username";
  String password = "password";
  String confirmPassword = "confirmPassword";

  void getEmail(String value) {
    email = value.toLowerCase();
    notifyListeners();
  }

  void getPassword(String value) {
    password = value;
    notifyListeners();
  }

  void getUsername(String value) {
    userName = value;
    notifyListeners();
  }

  void getConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }
}
