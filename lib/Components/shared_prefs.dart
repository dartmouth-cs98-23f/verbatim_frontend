//import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String UserName = '';
  static const String LastName = "";
  static const String FirstName = "";
  static const String Bio = '';
  static const String Email = '';
  static const String ProfileUrl = '';


  static SharedPreferences? _sharedPrefs;
  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {

    _sharedPrefs ??= await SharedPreferences.getInstance();
  
  }

  void setUserName(String username) {
    _sharedPrefs!.setString("username", username);
     _sharedPrefs?.commit();
  }

  String? getUserName() {
    return _sharedPrefs!.getString("username");
  }

  void setLastName(String lastName) {
    _sharedPrefs!.setString("lastname", lastName);
     _sharedPrefs?.commit();
  }

  void setCurrentPage(String currentPage) {
    _sharedPrefs!.setString("currentPage", currentPage);
     _sharedPrefs?.commit();
  }
  String? getCurrentPage() {
    return _sharedPrefs!.getString("currentPage");
  }

  String? getLastName() {
    return _sharedPrefs!.getString("lastname");

  }

  void setFirstName(String firstName) {
    _sharedPrefs!.setString("firstname", firstName);
     _sharedPrefs?.commit();
  }

  String? getFirstName() {
    return _sharedPrefs!.getString("firstname");
  }

  void setBio(String bio) {
    _sharedPrefs!.setString("bio", bio);
     _sharedPrefs?.commit();
  }

  String? getBio() {
    return _sharedPrefs!.getString("bio");
  }

  void setEmail(String email) {
    _sharedPrefs!.setString("email", email);
     _sharedPrefs?.commit();
  }


  String? getEmail() {
    return _sharedPrefs!.getString("email");
  }


  void setPassword(String password) {
    _sharedPrefs!.setString("password", password);
     _sharedPrefs?.commit();
  }

  String? getPassword() {
    return _sharedPrefs!.getString("password");
  }

  void setProfileUrl(String profileUrl) {
    if (profileUrl.isNotEmpty) {
      _sharedPrefs!.setString("profileUrl", profileUrl);
      _sharedPrefs?.commit();
    } else {
      _sharedPrefs!.setString("profileUrl", 'assets/profile_pic.png');
      _sharedPrefs?.commit();
    }
  }

  String? getProfileUrl() {
    return _sharedPrefs!.getString("profileUrl");
  }
 
}


// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefs {
//   static const String UserName = '';
//   static const String LastName = "";
//   static const String FirstName = "";
//   static const String Bio = '';
//   static const String Email = '';
//   static const String ProfileUrl = '';

//   static SharedPreferences? _sharedPrefs;

//   factory SharedPrefs() => SharedPrefs._internal();

//   SharedPrefs._internal();

//   Future<void> init() async {
//     _sharedPrefs ??= await SharedPreferences.getInstance();
//   }

//   void setUserName(String username) {
//     _sharedPrefs!.edit().setString("username", username).commit();
//   }

//   String? getUserName() {
//     return _sharedPrefs!.getString("username");
//   }

//   void setLastName(String lastName) {
//     _sharedPrefs!.edit().setString("lastname", lastName).commit();
//   }

//   String? getLastName() {
//     return _sharedPrefs!.getString("lastname");
//   }

//   void setCurrentPage(String currentPage) {
//     _sharedPrefs!.edit().setString("currentPage", currentPage).commit();
//   }

//   String? getCurrentPage() {
//     return _sharedPrefs!.getString("currentPage");
//   }

//   void setFirstName(String firstName) {
//     _sharedPrefs!.edit().setString("firstname", firstName).commit();
//   }

//   String? getFirstName() {
//     return _sharedPrefs!.getString("firstname");
//   }

//   void setBio(String bio) {
//     _sharedPrefs!.edit().setString("bio", bio).commit();
//   }

//   String? getBio() {
//     return _sharedPrefs!.getString("bio");
//   }

//   void setEmail(String email) {
//     _sharedPrefs!.edit().setString("email", email).commit();
//   }

//   String? getEmail() {
//     return _sharedPrefs!.getString("email");
//   }

//   void setPassword(String password) {
//     _sharedPrefs!.edit().setString("password", password).commit();
//   }

//   String? getPassword() {
//     return _sharedPrefs!.getString("password");
//   }

//   void setProfileUrl(String profileUrl) {
//     if (profileUrl.isNotEmpty) {
//       _sharedPrefs!.edit().setString("profileUrl", profileUrl).commit();
//     } else {
//       _sharedPrefs!.edit().setString("profileUrl", 'assets/profile_pic.png').commit();
//     }
//   }

//   String? getProfileUrl() {
//     return _sharedPrefs!.getString("profileUrl");
//   }
// }
