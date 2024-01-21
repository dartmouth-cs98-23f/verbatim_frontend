import 'package:flutter/material.dart';
import 'package:verbatim_frontend/screens/settings.dart';
import 'size.dart';
import 'package:verbatim_frontend/screens/sideBar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 150,
      elevation: 0,
      title: Column(
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

  NewNavBar({required this.profileImagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigate to the SideBar widget
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SideBar()),
              );
            },
          ),
          SearchBarTextField(),
          SizedBox(width: 20),
          Container(
            width: 40,
            height: 40.45,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(profileImagePath),
                fit: BoxFit.fill,
              ),
              shape: OvalBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBarTextField extends StatelessWidget {
  TextEditingController _searchController = TextEditingController();

  void handleSearch(String value) {
    // Handle the search input changes
    print("Search onChanged: $value");
  }

  void handleSubmit(String value) {
    // Handle the search submission
    print("Search onSubmitted: $value");
  }

  void handleSearchIconPressed() {
    // Handle the search icon pressed
    print("Search icon pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      fit: FlexFit.tight,
      child: Container(
        width: 380,
        height: 30,
        padding: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Color(0xFFFFF7EE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.black, size: 20),
              onPressed: handleSearchIconPressed,
            ),
            SizedBox(width: 20),
            Flexible(
              child: TextField(
                controller: _searchController,
                onChanged: handleSearch,
                onSubmitted: handleSubmit,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0.11,
                  letterSpacing: 0.20,
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
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
                  contentPadding: EdgeInsets.symmetric(
                      vertical: -16), // Adjust vertical padding as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SearchBarTextField extends StatelessWidget {
//   TextEditingController _searchController = TextEditingController();

//   void handleSearch(String value) {
//     // Handle the search input changes
//     print("Search onChanged: $value");
//   }

//   void handleSubmit(String value) {
//     // Handle the search submission
//     print("Search onSubmitted: $value");
//   }

//   void handleSearchIconPressed() {
//     // Handle the search icon pressed
//     print("Search icon pressed");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         clipBehavior: Clip.antiAlias,
//         decoration: ShapeDecoration(
//           color: Color(0xFFFFF7EE),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: Icon(Icons.search, color: Colors.black, size: 20),
//               onPressed: handleSearchIconPressed,
//             ),
//             SizedBox(width: 20),
//             Expanded(
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: handleSearch,
//                 onSubmitted: handleSubmit,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 12,
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w600,
//                   height: 0.11,
//                   letterSpacing: 0.20,
//                 ),
//                 cursorColor: Colors.black,
//                 decoration: InputDecoration(
//                   hintText: 'Search Users',
//                   hintStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 12,
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w600,
//                     height: 0.11,
//                     letterSpacing: 0.20,
//                   ),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class TitleFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 357,
      height: 70,
      padding: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: Column(
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
