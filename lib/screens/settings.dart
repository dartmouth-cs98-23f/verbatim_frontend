import 'dart:html';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:verbatim_frontend/BackendService.dart';
import 'package:verbatim_frontend/Components/EditProfilePicturePopup.dart';
import 'package:verbatim_frontend/widgets/MyTextFieldSettings.dart';
import 'package:verbatim_frontend/widgets/button_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/showSuccessDialog.dart';
import 'dart:async';
import 'package:verbatim_frontend/screens/resetPassword.dart';
import 'package:verbatim_frontend/widgets/center_custom_app_bar.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  Reference ref = FirebaseStorage.instance.ref().child('Verbatim_Profiles');

  final fullNameSettings = TextEditingController();

  final usernameSettings = TextEditingController();
  final bioSettings = TextEditingController();
  final emailSettings = TextEditingController();
  final String assetName = 'assets/img1.svg';

  final String imagePath = 'assets/profile_pic.png';
  late String _currentProfileUrl =
      window.sessionStorage['ProfileUrl'] ?? 'assets/profile_pic.png';

  final ImagePicker picker = ImagePicker();

  ImageProvider<Object> selectedImage =
      const AssetImage('assets/profile_pic.png');

  @override
  @override
  void initState() {
    super.initState();

    _loadProfileImage();
  }

  void edits(
    BuildContext context,
    String fullName,
    String username,
    String newUsername,
    String bio,
    String email,
    String profilePic,
  ) async {
    try {
      Map<String, String> nameMap = getFirstAndLastName(fullName);

      String firstName = nameMap['firstName'] ?? '';
      String lastName = nameMap['lastName'] ?? '';

      final response = await http.post(
        Uri.parse('${BackendService.getBackendUrl()}accountSettings'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'newUsername': newUsername,
          'email': email,
          'bio': bio,
          'profilePic': profilePic,
        }),
      );

      //do sth to verify the response,
      if (response.statusCode == 200) {
        //get the account info to display as dummy text
        setState(() {
          window.sessionStorage['FirstName'] = firstName;
          window.sessionStorage['LastName'] = lastName;
          window.sessionStorage['Bio'] = bio;
          window.sessionStorage['Email'] = email;
          window.sessionStorage['ProfileUrl'] = profilePic;
          window.sessionStorage['UserName'] = newUsername;
        });

        SuccessDialog.show(context, 'Your changes have been recorded!');
      }
    } catch (error) {
      print('Sorry cannot edit account settings:$error');
    }
  }

  Map<String, String> getFirstAndLastName(String fullName) {
    // Split the full name by whitespace
    List<String> nameParts = fullName.trim().split(' ');

    // Extract the first name and last name
    String firstName = nameParts.isNotEmpty ? nameParts.first : '';
    String lastName = nameParts.length > 1 ? nameParts.last : '';

    // Return the first name and last name as a map
    return {'firstName': firstName, 'lastName': lastName};
  }

  String getVal(String? fieldval, String currentval) {
    String finalVal;
    fieldval!.isEmpty ? finalVal = currentval : finalVal = fieldval;
    return finalVal;
  }

  Future<void> _loadProfileImage() async {
    String profileUrl = window.sessionStorage['ProfileUrl']!;
    // Download the image bytes
    Uint8List imageBytes = await downloadImage(profileUrl);
    // Update the selectedImage with the loaded image bytes
    setState(() {
      selectedImage = MemoryImage(imageBytes);
    });
  }

  Future<Uint8List> downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('\nError: ${response.statusCode} - ${response.reasonPhrase}\n');
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load image');
    }
  }

  // Function to show the centered edit profile picture pop-up
  void _showEditProfilePicturePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProfilePicturePopup(
          imagePath: _currentProfileUrl,
          selectedImage: selectedImage,
          onImageTap: _viewEnlarged,
          onChangeImageGallery: () => _pickImage(ImageSource.gallery),
          onChangeImageCamera: () => _pickImage(ImageSource.camera),
          onRemoveCurrentPicture: _removeCurrentPicture,
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source, imageQuality: 70);

    if (image != null) {
      var bytes = await image.readAsBytes();
      String newProfileUrl =
          await uploadFileToFirebase(bytes); // Get new profile picture URL
      String prevProfileUrl = window.sessionStorage['ProfileUrl'] ??
          ''; // Get previous profile picture URL

      // Update profile picture URL in local storage
      window.sessionStorage['ProfileUrl'] = newProfileUrl;

      // Delete previous profile picture if URL is not empty and different from new URL
      if (prevProfileUrl.isNotEmpty && prevProfileUrl != newProfileUrl) {
        await deleteFileFromFirebase(prevProfileUrl);
      }
      _currentProfileUrl = newProfileUrl;

      setState(() {
        selectedImage = MemoryImage(bytes);
        window.sessionStorage['ProfileUrl'] = newProfileUrl;
      });

      Navigator.pop(context);

      edits(
        context,
        window.sessionStorage['FirstName'] ??
            '' + (window.sessionStorage['LastName'] ?? ''),
        window.sessionStorage['UserName'] as String,
        window.sessionStorage['UserName'] as String,
        window.sessionStorage['Bio'] as String,
        window.sessionStorage['Email'] as String,
        newProfileUrl,
      );
    } else {
      print('\nNo image has been picked');
    }
  }

  Future<String> uploadFileToFirebase(Uint8List image) async {
    String imgId = generateUuid();
    Reference imgRef = ref.child(imgId);

    UploadTask uploadTask = imgRef.putData(
      image,
      SettableMetadata(contentType: 'image/jpg'),
    );

    TaskSnapshot snapshot = await uploadTask;

    String profileUrl = await snapshot.ref.getDownloadURL();

    return profileUrl;
  }

  Future<void> deleteFileFromFirebase(String fileUrl) async {
    try {
      // Get the reference to the file in Firebase Storage
      Reference reference = FirebaseStorage.instance.refFromURL(fileUrl);

      // Delete the file
      await reference.delete();

      print('File deleted successfully');
    } catch (error) {
      print('Error deleting file: $error');
      // Handle the error gracefully
    }
  }

  String generateUuid() {
    const Uuid uuid = Uuid();
    return uuid.v4(); // Generates a random UUID (v4)
  }

  Future<void> _removeCurrentPicture() async {
    String prevProfileUrl = window.sessionStorage['ProfileUrl'] ?? "";
    String newProfileUrl = 'assets/profile_pic.png';

    setState(() {
      selectedImage = const AssetImage('assets/profile_pic.png');
      // SharedPrefs.setProfileUrl(newProfileUrl);
      window.sessionStorage['ProfileUrl'] = newProfileUrl;

      // Close the pop-up
      Navigator.pop(context);
    });

    // Delete previous profile picture if URL is not empty and different from new URL
    if (prevProfileUrl.isNotEmpty && prevProfileUrl != newProfileUrl) {
      await deleteFileFromFirebase(prevProfileUrl);
    }
  }

  void _viewEnlarged() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnlargedImageView(imageProvider: selectedImage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: SafeArea(
          child: Container(
              color: const Color.fromARGB(255, 255, 243, 238),
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.maxFinite,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              // orange background
                              Container(
                                height: 200,
                                width: double.maxFinite,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                child: SvgPicture.asset(
                                  assetName,
                                  fit: BoxFit.fill,
                                ),
                              ),

                              // app bar on top of background
                              const centerAppBar(
                                title: 'Settings',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 50.0), 
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: _viewEnlarged,
                        child: Stack(
                          children: [
                            Container(
                              width: 110.0,
                              height: 110.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFE76F51),
                                  width: 2.0,
                                ),
                              ),
                              child: ClipOval(
                                child: Container(
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: selectedImage,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12.0,
                              right: -2.0,
                              child: FloatingActionButton(
                                onPressed: _showEditProfilePicturePopup,
                                tooltip: 'Change Image',
                                mini: true,
                                backgroundColor: const Color(0xFFE76F51),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0),
                                  side: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                child: Container(
                                  child: const Center(
                                    child: Icon(
                                      Icons.create_outlined,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //Reset password
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: MouseRegion(
                          onHover: (_) {},
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Navigate to the ResetPassword page
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ResetPassword(),
                                ));
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Reset Password',
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                    color: Color(0xFF3C64B1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16, 
                                    height: 0.06,
                                    letterSpacing: 0.30,
                                  )),
                                ),
                              ),
                            ),
                          )),
                    ),
                  ),

                  const SizedBox(height: 38),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Name',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 0.04,
                          letterSpacing: 0.30,
                        )),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  MyTextFieldSettings(
                      controller: fullNameSettings,
                      hintText:
                          "${window.sessionStorage['FirstName'] ?? ""} ${window.sessionStorage['LastName'] ?? ""}",
                      obscureText: false),

                  //username
                  const SizedBox(height: 38),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Username',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 0.04,
                          letterSpacing: 0.30,
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextFieldSettings(
                      controller: usernameSettings,
                      hintText: window.sessionStorage['UserName'] ?? "",
                      obscureText: false),

                  //bio
                  const SizedBox(height: 38),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Bio',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 0.04,
                          letterSpacing: 0.30,
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextFieldSettings(
                      controller: bioSettings,
                      hintText:
                          window.sessionStorage['Bio'] ?? "Enter your bio",
                      obscureText: false),

                  //email
                  const SizedBox(height: 38),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 0.04,
                          letterSpacing: 0.30,
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextFieldSettings(
                      controller: emailSettings,
                      hintText: window.sessionStorage['Email'] ?? "",
                      obscureText: false),

                  Center(
                      child: Column(
                    children: [
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 27.0), 
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: DeepOrangeButton(
                            buttonText: 'Update Profile',
                            onPressed: () {
                              edits(
                                  context,
                                  getVal(fullNameSettings.text,
                                      window.sessionStorage['FullName'] ?? ""),
                                  window.sessionStorage['UserName'] ?? "",
                                  getVal(
                                    usernameSettings.text,
                                    window.sessionStorage['UserName'] ?? "",
                                  ),
                                  getVal(bioSettings.text,
                                      window.sessionStorage['Bio'] ?? ""),
                                  getVal(emailSettings.text,
                                      window.sessionStorage['Email'] ?? ""),
                                  window.sessionStorage['ProfileUrl']!);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ))
                ],
              )),
        )),
      ),
    );
  }
}

class EnlargedImageView extends StatelessWidget {
  final ImageProvider<Object> imageProvider;

  const EnlargedImageView({super.key, required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
            tag: 'enlarged_image',
            child: Image(
              image: imageProvider,
              fit: BoxFit
                  .cover, 
            ),
          ),
        ),
      ),
    );
  }
}
