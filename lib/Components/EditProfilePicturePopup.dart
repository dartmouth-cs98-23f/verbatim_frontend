import 'package:flutter/material.dart';

class EditProfilePicturePopup extends StatefulWidget {
  final String imagePath;
  final ImageProvider<Object> selectedImage;
  final VoidCallback onImageTap;
  final VoidCallback onChangeImageGallery;
  final VoidCallback onChangeImageCamera;
  final VoidCallback onRemoveCurrentPicture;

  const EditProfilePicturePopup({
    super.key,
    required this.imagePath,
    required this.selectedImage,
    required this.onImageTap,
    required this.onChangeImageGallery,
    required this.onChangeImageCamera,
    required this.onRemoveCurrentPicture,
    // ... (your existing parameters)
  });

  @override
  _EditProfilePicturePopupState createState() =>
      _EditProfilePicturePopupState();
}

class _EditProfilePicturePopupState extends State<EditProfilePicturePopup> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Align(
                  alignment: Alignment.topCenter,
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
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the popup
                },
              ),
            ],
          ),
          const SizedBox(height: 5),
          MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: GestureDetector(
              onTap: widget.onImageTap,
              child: Container(
                  // ... (your existing image container)
                  ),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(
              Icons.photo_camera_outlined,
              color: Color(0xFFDE674A),
            ),
            title: const Text(
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
            onTap: widget.onChangeImageCamera,
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(
              Icons.photo_outlined,
              color: Color(0xFFDE674A),
            ),
            title: const Text(
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
            onTap: widget.onChangeImageGallery,
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(
              Icons.delete_outline,
              color: Color(0xFFDE674A),
            ),
            title: const Text(
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
            onTap: widget.onRemoveCurrentPicture,
          ),
        ],
      ),
    );
  }

  void _onHover(bool hover) {
    setState(() {
      isHovered = hover;
    });
  }
}
