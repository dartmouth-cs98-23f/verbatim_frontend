import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:verbatim_frontend/screens/logIn.dart';
import 'package:verbatim_frontend/widgets/guest_utility.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  Map<String, Text> validationErrors = {};

  Future<void> logout(BuildContext context) async {
    // Initialize GoogleSignIn
    final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        clientId:
            '1052195157201-9d7dskf4jihdd8b3ad6bmidnkoilu9ht.apps.googleusercontent.com');

    try {
      // Attempt to sign out from Google first
      await googleSignIn.signOut();
      print("\nSuccessfully signed out of Google\n");
    } catch (error) {
      print("Error signing out from Google: $error");
    }



    //clear stats, clear guest stuff
    final GuestUtility guestUtility = GuestUtility();
    guestUtility.clearStats();
    guestUtility.clearGameObject();
    
    // Navigate to the login page after logout
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LogIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3EE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/Logo.png',
                      width: 150,
                      height: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 160),
                Center(
                  child: Text(
                    'Log out from your account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Color(0xFFE76F51),
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        letterSpacing: 0.30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Are you sure you want to log out?',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            letterSpacing: 0.30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Go to the previous page
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE76F51), // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(13.0), // Rectangular shape
                        ),
                      ),
                      child: Text(
                        'Go Back',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    ElevatedButton(
                      onPressed: () {
                        // Log out
                        logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFFFF3EE), // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(13.0), // Rectangular shape
                        ),
                      ),
                      child: Text(
                        'Log Out',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
