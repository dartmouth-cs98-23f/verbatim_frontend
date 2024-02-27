import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                padding: const EdgeInsets.only(left: 12.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Edit Profile Picture',
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                      color: Color(0xFF3C63B0),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 0.09,
                      letterSpacing: 0.30,
                    )),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
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
          Container(
              padding: const EdgeInsets.all(0),
              child: Center(
                child: ListTile(
                  leading: const Icon(
                    Icons.photo_camera_outlined,
                    color: Color(0xFFDE674A),
                  ),
                  title: Text(
                    'Take a photo',
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      //   height: 0.09,
                      //  letterSpacing: 0.10,
                    )),
                  ),
                  onTap: widget.onChangeImageCamera,
                ),
              )),
          const SizedBox(height: 10),
          Container(
              padding: const EdgeInsets.all(0),
              child: Center(
                child: ListTile(
                  title: Text(
                    'Choose from gallery',
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
                  ),
                  leading: const Icon(
                    Icons.photo_outlined,
                    color: Color(0xFFDE674A),
                  ),
                  onTap: widget.onChangeImageGallery,
                ),
              )),
          const SizedBox(height: 10),
          Container(
              child: Center(
            child: ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Color(0xFFDE674A),
              ),
              title: Text('Remove current picture',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              onTap: widget.onRemoveCurrentPicture,
            ),
          )),
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
