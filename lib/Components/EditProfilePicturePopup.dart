import 'package:flutter/material.dart';
import "package:hovering/hovering.dart";

class EditProfilePicturePopup extends StatefulWidget {
  final String imagePath;
  final VoidCallback onImageTap;
  final VoidCallback onChangeImageGallery;
  final VoidCallback onChangeImageCamera;
  final VoidCallback onRemoveCurrentPicture;

  EditProfilePicturePopup({
    required this.imagePath,
    required this.onImageTap,
    required this.onChangeImageGallery,
    required this.onChangeImageCamera,
    required this.onRemoveCurrentPicture,
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
          MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: GestureDetector(
              onTap: widget.onImageTap,
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isHovered ? Colors.blue : Colors.deepOrange,
                    width: 2.0,
                  ),
                ),
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onImageTap,
                      child: Image.asset(
                        widget.imagePath,
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
            onTap: widget.onChangeImageCamera,
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
