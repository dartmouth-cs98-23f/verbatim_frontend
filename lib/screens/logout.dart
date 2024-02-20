import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/logIn.dart';
import 'package:verbatim_frontend/widgets/guest_utility.dart';
import '../Components/shared_prefs.dart';



class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  Map<String, Text> validationErrors = {};

  Future<void> logout(BuildContext context) async {
    // Clear out all the user information
    await SharedPrefs().init();
    SharedPrefs.setEmail('');
    SharedPrefs.setUserName('');
    SharedPrefs.setPassword('');
    SharedPrefs.setFirstName('');
    SharedPrefs.setLastName('');
    SharedPrefs.setBio('');
    SharedPrefs.setCurrentPage('/login');

    //TODO:clear stats, clear guest stuff
    final GuestUtility guestUtility= GuestUtility();
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
                const Center(
                  child: Text(
                    'Log out from your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE76F51),
                      fontSize: 32,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: 0.30,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Are you sure you want to log out?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: 0.30,
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
                      child: const Text(
                        'Go Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
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
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
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
