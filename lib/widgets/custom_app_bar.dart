import 'package:flutter/material.dart';
import 'size.dart';
import 'package:verbatim_frontend/screens/sideBar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.transparent,

      toolbarHeight: 100.v,
      // toolbarHeight: 150,

      elevation: 0,
      title: const Column(
        children: [
          SizedBox(height: 60),
          NewNavBar(
            profileImagePath: 'assets/profile2.jpeg',
          ),
          SizedBox(height: 30), // Adjust the distance as needed
          TitleFrame(),
          SizedBox(height: 30),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size(
        mediaQueryData.size.width,
        80.v,
      );
}

class NewNavBar extends StatelessWidget {
  final String profileImagePath;

  const NewNavBar({super.key, required this.profileImagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigate to the SideBar widget
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SideBar()),
              );
            },
          ),
          SearchBarTextField(),
          const SizedBox(width: 20),
          Container(
            width: 40,
            height: 40.45,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(profileImagePath),
                fit: BoxFit.fill,
              ),
              shape: const OvalBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBarTextField extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  SearchBarTextField({super.key});

  void handleSearchChange(String value) {
    // Add your logic for handling search input changes
    print('Search input changed: $value');
  }

  void handleSearchPress() {
    // Add your logic for handling search
    print('Search performed');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFFFF7EE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: handleSearchPress, // Add onPressed function
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 20,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: handleSearchChange, // Add onChange function
                onSubmitted: (value) =>
                    handleSearchPress(), // Add onSubmitted for Enter key press

                decoration: const InputDecoration(
                  hintText: 'Search Users',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 0.11,
                    letterSpacing: 0.20,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleFrame extends StatelessWidget {
  const TitleFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 357,
      height: 70,
      padding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Account Settings',
            style: TextStyle(
              color: Color(0xFFFFF7EE),
              fontSize: 32,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 0.04,
              letterSpacing: 0.10,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
