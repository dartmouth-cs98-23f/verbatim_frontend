// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class Settings extends StatefulWidget {
//   const Settings({Key? key}) : super(key: key);

//   @override
//   _SettingsState createState() => _SettingsState();
// }

// class _SettingsState extends State<Settings> {
//   final ImagePicker picker = ImagePicker();
//   ImageProvider<Object> selectedImage = AssetImage('assets/profile.jpeg');

//   // Create a new GlobalKey for each instance of _SettingsState
//   GlobalKey<_SettingsState> _settingsKey = GlobalKey<_SettingsState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _settingsKey, // Use the GlobalKey here
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120.0,
//               height: 120.0,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   image: selectedImage, // MemoryImage(webImage!)
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () async {
//                 await _pickImage();
//               },
//               child: const Text('Change Picture'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickImage() async {
//     if (!kIsWeb) {
//       final ImagePicker _picker = ImagePicker();
//       XFile? image = await _picker.pickImage(source: ImageSource.gallery);

//       if (image != null) {
//         var selected = File(image.path);
//         setState(() {
//           selectedImage = selected as ImageProvider<Object>;
//         });
//       } else {
//         print('\nNo image has been picked');
//       }
//     } else if (kIsWeb) {
//       final ImagePicker _picker = ImagePicker();
//       XFile? image = await _picker.pickImage(source: ImageSource.gallery);

//       if (image != null) {
//         String path = image.path;
//         print("\n\nchosen path: $path");

//         var bytes = await image.readAsBytes();
//         setState(() {
//           selectedImage = MemoryImage(bytes!);
//         });
//       } else {
//         print('\nNo image has been picked');
//       }
//     } else {
//       print('\nSomething went wrong.');
//     }
//   }

//   void confirmation() {
//     print('\nafter uploading the image');
//   }
// }
