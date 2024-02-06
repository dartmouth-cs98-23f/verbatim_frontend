// User class for when backend passes in users
class User {
  int id = 0;
  String email = "";
  String username = "";
  String lastName = "";
  String password = "";
  dynamic profilePicture;
  String? bio = "";
  int numGlobalChallengesCompleted = 0;
  int numCustomChallengesCompleted = 0;
  int streak = 0;
  bool hasCompletedDailyChallenge = false;

  User({required this.username, this.bio});

  

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      bio: json['bio']
    );
  }


}