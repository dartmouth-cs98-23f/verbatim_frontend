// // User class for when backend passes in users

// class User {
//   int id = 0;
//   String email = "";
//   String username = "";
//   String lastName = "";
//   String firstName = "";
//   dynamic profilePicture;
//   String? bio = "";
//   int numGlobalChallengesCompleted = 0;
//   int numCustomChallengesCompleted = 0;
//   int streak = 0;
//   bool hasCompletedDailyChallenge = false;
//   bool isRequested = false;

//   User({
//     required this.id,
//     required this.email,
//     required this.username,
//     required this.lastName,
//     required this.firstName,
//     required this.profilePicture,
//     required this.bio,
//     required this.numGlobalChallengesCompleted,
//     required this.numCustomChallengesCompleted,
//     required this.streak,
//     required this.hasCompletedDailyChallenge,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       email: json['email'],
//       username: json['username'],
//       lastName: json['lastName'],
//       firstName: json['firstName'],
//       profilePicture: json['profilePicture'] ?? "assets/profile_pic.png",
//       bio: json['bio'] ?? " ",
//       numGlobalChallengesCompleted: json['numGlobalChallengesCompleted'],
//       numCustomChallengesCompleted: json['numCustomChallengesCompleted'],
//       streak: json['streak'],
//       hasCompletedDailyChallenge: json['hasCompletedDailyChallenge'],
//     );
//   }
// }
