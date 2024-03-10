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

  static Future <void> setUserName (String username)async {
    await _sharedPrefs!.setString("username", username);
  }

  static Future <void> setLastName(String lastName)async {
    await _sharedPrefs!.setString("lastname", lastName);
     
  }

  String? getUserName() {
    return _sharedPrefs!.getString("username");
  }



  static Future <void> setCurrentPage(String currentPage) async{
   await  _sharedPrefs!.setString("currentPage", currentPage);
  
  }
  String? getCurrentPage() {
    return _sharedPrefs!.getString("currentPage");
  }

  String? getLastName() {
    return _sharedPrefs!.getString("lastname");

  }

  static Future <void> setFirstName(String firstName) async{
   await  _sharedPrefs!.setString("firstname", firstName);
     
  }

  String? getFirstName() {
    return _sharedPrefs!.getString("firstname");
  }

  static Future <void> setBio(String bio) async{
   await  _sharedPrefs!.setString("bio", bio);
    
  }

  String? getBio() {
    return _sharedPrefs!.getString("bio");
  }

  static Future <void> setEmail(String email)async {
    await _sharedPrefs!.setString("email", email);
   
  }


  String? getEmail() {
    return _sharedPrefs!.getString("email");
  }


  static Future <void> setPassword(String password) async{
    await _sharedPrefs!.setString("password", password);
  
  }

  String? getPassword() {
    return _sharedPrefs!.getString("password");
  }

  static Future <void> setProfileUrl(String profileUrl) async{
    if (profileUrl.isNotEmpty) {
      await _sharedPrefs!.setString("profileUrl", profileUrl);
  
    } else {
      await _sharedPrefs!.setString("profileUrl", 'assets/profile_pic.png');
      
    }
  }

  String? getProfileUrl() {
    return _sharedPrefs!.getString("profileUrl");
  }
 
}


