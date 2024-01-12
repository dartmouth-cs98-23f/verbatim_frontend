import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SamplePage extends StatefulWidget {
  final String imagePath; // Pass the image path as a parameter

  // Constructor to receive the image path
  SamplePage({required this.imagePath});

  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  late String _currentImagePath; // Track the currently displayed image

  @override
  void initState() {
    super.initState();
    _currentImagePath =
        widget.imagePath; // Initialize with the provided image path
  }

  // Function to show the centered edit profile picture pop-up
  void _showEditProfilePicturePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProfilePicturePopup(
          imagePath: _currentImagePath,
          onImageTap: _viewEnlarged,
          onChangeImageGallery: () => _pickImage(ImageSource.gallery),
          onChangeImageCamera: () => _pickImage(ImageSource.camera),
          onRemoveCurrentPicture: _removeCurrentPicture,
        );
      },
    );
  }

// Function to pick an image using ImagePicker
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      // Handle the selected image file
      setState(() {
        _currentImagePath = pickedFile.path;
      });
    } else {
      // User canceled the operation
    }
  }

  // Function to handle removing the current picture
  void _removeCurrentPicture() {
    // Implement your logic for removing the current picture
    // Update _currentImagePath accordingly
    // Make sure to handle errors and user feedback appropriately
  }

  // Function to navigate to an enlarged version of the image
  void _viewEnlarged() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnlargedImageView(imagePath: _currentImagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Page'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _viewEnlarged, // Call _viewEnlarged when the image is tapped
          child: Stack(
            children: [
              Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    _currentImagePath,
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0, // Adjust the bottom position as needed
                right: 16.0, // Adjust the right position as needed
                child: FloatingActionButton(
                  onPressed: _showEditProfilePicturePopup,
                  tooltip: 'Change Image',
                  mini: true, // Set mini to true to reduce the size
                  backgroundColor: Colors.deepOrange,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                        size: 24.0, // Adjust the size of the icon as needed
                        color: Colors.white, // Border color
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfilePicturePopup extends StatelessWidget {
  final String imagePath;
  final VoidCallback onImageTap;
  final VoidCallback onChangeImageGallery; // Updated this line
  final VoidCallback onChangeImageCamera; // Added this line
  final VoidCallback onRemoveCurrentPicture;

  EditProfilePicturePopup({
    required this.imagePath,
    required this.onImageTap,
    required this.onChangeImageGallery, // Updated this line
    required this.onChangeImageCamera, // Added this line
    required this.onRemoveCurrentPicture,
  });

  // Function to handle image uploading
  Future<void> _uploadImage(String imagePath) async {
    // Simulate an asynchronous upload process
    await Future.delayed(Duration(seconds: 2));

    // Print the path of the uploaded image
    print('Image uploaded successfully: $imagePath');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Edit Profile Picture',
                style: TextStyle(
                  color: Color(0xFF3C63B0),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 0.09,
                  letterSpacing: 0.30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: onImageTap,
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(
              Icons.photo_camera,
              color: Color(0xFFDE674A),
            ),
            title: Text(
              'Take a photo',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0.09,
                letterSpacing: 0.10,
              ),
            ),
            onTap: onChangeImageCamera,
          ),

          // ... (Previous code)

          ListTile(
            leading: Icon(
              Icons.photo,
              color: Color(0xFFDE674A),
            ),
            title: Text(
              'Choose from gallery',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0.09,
                letterSpacing: 0.10,
              ),
            ),
            onTap: onChangeImageGallery,
          ),
          ListTile(
            leading: Stack(
              children: [
                // Border color
                Icon(
                  Icons.delete,
                  color: Color(0xFFDE674A),
                ),
              ],
            ), // Use a trash can icon for removal
            title: Text(
              'Remove current picture',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0.09,
                letterSpacing: 0.10,
              ),
            ),
            onTap: () {
              onRemoveCurrentPicture();
              Navigator.pop(
                  context); // Close the pop-up after removing the picture
            },
          ),
        ],
      ),
    );
  }
}

class EnlargedImageView extends StatelessWidget {
  final String imagePath;

  EnlargedImageView({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: 'enlarged_image', // Unique tag for the hero animation
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }
}
