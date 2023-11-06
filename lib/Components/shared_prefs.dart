import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String UserName = '';
  static const String LastName = "";
  static const String FirstName = "";
  static const String Bio = '';
  static const String Email = '';

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

  String? getLastName() {
    return _sharedPrefs!.getString("lastname");
  }

  void setFirstName(String firstName) {
    _sharedPrefs!.setString("firstname", firstName);
  }

  String? getFirstName() {
    return _sharedPrefs!.getString("firstname");
  }

  void setBio(String? bio) {
    _sharedPrefs!.setString("bio", bio ?? '');
  }

  String? getBio() {
    return _sharedPrefs!.getString("bio");
  }

  void setEmail(String email) {
    _sharedPrefs!.setString("email", email);
  }

  String? getEmail() {
    return _sharedPrefs!.getString("email");
  }

  void setPassword(String password) {
    _sharedPrefs!.setString("password", password);
  }

  String? getPassword() {
    return _sharedPrefs!.getString("password");
  }
}
