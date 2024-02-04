//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String UserName = '';
  static const String LastName = "";
  static const String FirstName = "";
  static const String Bio = '';
  static const String Email = '';

  static const String responseQ1 = '';
  static const String responseQ2 = '';
  static const String responseQ3 = '';
  static const String referer = '';

  static SharedPreferences? _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  void setUserName(String username) {
    _sharedPrefs!.setString("username", username);
  }

  String? getUserName() {
    return _sharedPrefs!.getString("username");
  }

  void setLastName(String lastName) {
    _sharedPrefs!.setString("lastname", lastName);
  }

  void setCurrentPage(String currentPage) {
    _sharedPrefs!.setString("currentPage", currentPage);
  }

  String? getLastName() {
    return _sharedPrefs!.getString("lastname");
  }

  void setFirstName(String firstName) {
    _sharedPrefs!.setString("firstname", firstName);
  }

  String? getFirstName() {
    return _sharedPrefs!.getString("firstname");
  }

  void setBio(String bio) {
    _sharedPrefs!.setString("bio", bio);
  }

  String? getBio() {
    return _sharedPrefs!.getString("bio");
  }

  void setEmail(String email) {
    _sharedPrefs!.setString("email", email);
  }

  void updateGameValues(String response1, String response2, String response3) {
    _sharedPrefs!.setString("response1", response1);
    _sharedPrefs!.setString("response2", response2);
    _sharedPrefs!.setString("response3", response3);
  }

  void updateReferer(String referer) {
    _sharedPrefs!.setString("referer", referer);
  }

  String? getEmail() {
    return _sharedPrefs!.getString("email");
  }

  String? getGameValues() {
    String responses =
        "${_sharedPrefs!.getString("response1")!} ${_sharedPrefs!.getString("response2")!} ${_sharedPrefs!.getString("response3")!}";
    return responses;
  }

  String getReferer() {
    // return "${_sharedPrefs!.getString("referer")!} ";
    print("In shared prefs scouting for referer: ${_sharedPrefs!.getString("referer")}");
    return "${_sharedPrefs!.getString("referer")}";
  }

  String getResponse1() {
    return "${_sharedPrefs!.getString("response1")}";
  }

  String getResponse2() {
    return "${_sharedPrefs!.getString("response2")}";
  }

  String getResponse3() {
    return "${_sharedPrefs!.getString("response3")}";
  }

  void setPassword(String password) {
    _sharedPrefs!.setString("password", password);
  }

  String? getPassword() {
    return _sharedPrefs!.getString("password");
  }

  String? getCurrentPage() {
    return _sharedPrefs!.getString("currentPage");
  }
}
