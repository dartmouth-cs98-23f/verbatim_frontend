import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:verbatim_frontend/Components/shared_prefs.dart';

class UserData with ChangeNotifier {
  String _email = '';
  String _firstName = '';
  String _lastName = '';
  String _userName = '';
  String _bio = '';
  String _profileUrl = '';
  String _password = '';

  String get email => _email;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get userName => _userName;
  String get bio => _bio;
  String get profileUrl => _profileUrl;
  String get password => _password;

   Future<void>loadUserName() async {
    _userName = SharedPrefs().getUserName() ?? '';
    print("Username in the data stuff is: $_userName");
    notifyListeners();
  }

   Future<void>loadFirstName() async {
    _firstName = SharedPrefs().getFirstName() ?? '';
    notifyListeners();
  }

   Future<void>loadLastName() async {
    _lastName = SharedPrefs().getLastName() ?? '';
    notifyListeners();
  }

  Future<void> loadBio() async {
    _bio= SharedPrefs().getBio() ?? 'Verbatim: That\'s what she said';
    notifyListeners();
  }

   Future<void>loadProfileUrl() async {
 
    _profileUrl = SharedPrefs().getProfileUrl()! == "" ? 'assets/profile_pic.png':SharedPrefs().getProfileUrl()! ;
    notifyListeners();
  }

   Future<void>loadPassword() async {
    _password = SharedPrefs().getUserName() ?? '';
    notifyListeners();
  }

  Future<void> setEmail(String email) async {
    _email = email;

    notifyListeners();
    await SharedPrefs.setEmail(email);
  }

  Future<void> setUserName(String userName) async {
    _userName = userName;

    notifyListeners();
    await SharedPrefs.setUserName(userName);
  }

  Future<void> setFirstName(String firstName) async {
    _firstName = firstName;

    notifyListeners();
    await SharedPrefs.setFirstName(firstName);
  }

  Future<void> setLastName(String lastName) async {
    _lastName = lastName;
    notifyListeners();
    await SharedPrefs.setLastName(lastName);
  }

  Future<void> setBio(String bio) async {
    _bio = bio;
    notifyListeners();
    await SharedPrefs.setBio(bio);
  }

  Future<void> setProfileUrl(String profileUrl) async {
    _profileUrl = profileUrl;
    notifyListeners();
    await SharedPrefs.setProfileUrl(profileUrl);
  }

  Future<void> setPassword(String password) async {
    _password = password;
    notifyListeners();
    await SharedPrefs.setPassword(password);
  }

  void loadValues() {
    loadBio();
    loadFirstName();
    loadLastName();
    loadPassword();
    loadProfileUrl();
    loadUserName();
  }
}
