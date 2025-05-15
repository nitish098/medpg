import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:medpg/presentation/models/leader_board.dart';
import 'package:medpg/presentation/models/login_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
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
        final data = jsonDecode(response.body); //extract the user information
        _userData = UserClass.fromJson(data["user"]);

        final cookie = response.headers['set-cookie']; //extract the connect sid
        final sidMatch =
            RegExp(r'connect\.sid=([^;]+)').firstMatch(cookie ?? '');
        final connectSid = sidMatch?.group(1);
        print("nitish $connectSid");
        if (connectSid == null) {
          _errorMessage = "Session ID missiing";
          notifyListeners();
          return false;
        }

        final prefs =
            await SharedPreferences.getInstance(); //Strore to the local data
        prefs.setString("userPrefs", jsonEncode(data["user"]));
        prefs.setString("connectSid", connectSid);
        prefs.setString("username", username);
        prefs.setString("password", password);

        final csrfSuccess = await _fetchCsrfToken(connectSid);

        if (csrfSuccess == false) {
          _errorMessage = "No Csrf token found";
          notifyListeners();
          return false;
        }

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

  Future<bool> _fetchCsrfToken(String connectSid) async {
    const url = "https://themedico.app/api/csrf-token";
    final csrfResponce = await http.get(
      Uri.parse(url),
      headers: {'Cookie': "connect.sid=$connectSid"},
    );
    print("nitisshhhhhhhhhhhhhhhhh");
    if (csrfResponce.statusCode == 200) {
      // print("nitisshhhhhhhhhhhhhhhhh $csrfResponce");
      final csfrData = jsonDecode(csrfResponce.body);
      final csrfToken = csfrData['csrfToken'];
      print("nitish $csrfToken");

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('csrfToken', csrfToken);

      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>?> progressGrowth() async {
    final prefs = await SharedPreferences.getInstance();
    final sid = prefs.getString('connectSid');
    final csrf = prefs.getString('csrfToken');
    print("nitish $sid");
    print("nitish $csrf");
    if (sid == null || csrf == null) return null;
    print("nitisshhhhhhhhhhhhhhhhh fetc dfdf");
    final url = Uri.parse('https://themedico.app/api/progress/growth');
    print("nitish $url");
    final growthResponse = await http.get(
      url,
      headers: {
        'Cookie': 'connect.sid=$sid',
        'X-CSRF-Token': csrf,
      },
    );
    if (growthResponse.statusCode == 200) {
      final growthdata = jsonDecode(growthResponse.body);
      return {
        'questionsGrowth': growthdata['questionsGrowth'],
        'accuracyGrowth': growthdata['accuracyGrowth'],
        'sessionsGrowth': growthdata['sessionsGrowth'],
      };
    }
    return null;
  }

  Future<List<LeaderboardEntry>> fetchLeaderboard({
    required String category,
    required String period,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final sid = prefs.getString('connectSid');
    final csrf = prefs.getString('csrfToken');
    print("nitish $sid");
    print("nitish $csrf");
    if (sid == null || csrf == null) return [];
    print("nitisshhhhhhhhhhhhhhhhh fetc dfdf");
    final url = Uri.parse(
        'https://themedico.app/api/leaderboard?period=$period&category=$category&limit=10&synthetic=true');
    print("nitish $url");
    final leaderBoardResponse = await http.get(
      url,
      headers: {
        'Cookie': 'connect.sid=$sid',
        'X-CSRF-Token': csrf,
      },
    );

    if (leaderBoardResponse.statusCode == 200) {
      final leaderData = jsonDecode(leaderBoardResponse.body);
      final leaderBoard = leaderData['entries'] as List;
      return leaderBoard.map((e) => LeaderboardEntry.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> logOut() async {
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
