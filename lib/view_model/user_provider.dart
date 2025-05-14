import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:medpg/presentation/models/login_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:medpg/view_model/user_service.dart';

class UserProvider extends ChangeNotifier {
  // final UserService _userService = UserService();

  UserClass? _userData;
  bool _isLoading = false;
  String? _errorMessage;
  // List<UserClass> _user = [];

  UserClass? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  // List<UserClass> get user => _user;

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userPrefData = prefs.getString("userPrefs");
    if (userPrefData != null) {
      _userData = UserClass.fromJson(
        jsonDecode(userPrefData),
      );
      notifyListeners();
    }
  }

  Future<bool> loginData(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    const url = "https://themedico.app/api/auth/login";

    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'credential': username,
            'password': password,
          }));

      _isLoading = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _userData = UserClass.fromJson(data["user"]);
        
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("userPrefs", jsonEncode(data["user"]));
        prefs.setString("username", username);
        prefs.setString("password",password);

        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
        switch (response.statusCode) {
          case 400:
            _errorMessage = 'Invalid username or password.';
            break;
          case 401:
            _errorMessage =
                'Your account has been disabled. Please contact support.';
            break;
          case 403:
            _errorMessage = 'Your account is inactive.';
            break;
          case 500:
            _errorMessage = 'Server error. Please try again later.';
            break;
          default:
            _errorMessage = error.toString();
        }
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage =
          'Unexpected error occurred. Please check your connection.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logOut()async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _userData = null;
    notifyListeners();
  }

  // Future<void> getAllUserData(String credential, String password) async {
  //   enableLoading();

  //   _user = await _userService.userService(credential, password);
  //   notifyListeners();
  //   disableLoading();
  // }
}
