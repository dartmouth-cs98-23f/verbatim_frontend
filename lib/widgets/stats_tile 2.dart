// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';

// class MyStatsTile extends StatelessWidget {
//   final String stat;
//   final String icon;
//   final String field;
//   const MyStatsTile(
//       {super.key, required this.stat, required this.icon, required this.field});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const SizedBox(width: 15),
//         SvgPicture.asset(icon),
//         const SizedBox(width: 15),
//         Center(
//           child: Column(
//             children: [
//               const Padding(padding: EdgeInsets.only(top: 15.0)),
//               Text(
//                 stat,
//                 textAlign: TextAlign.left,
//                 style: GoogleFonts.poppins(
//                     textStyle: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20)),
//               ),
//               Text(
//                 field,
//                 textAlign: TextAlign.left,
//                 style: GoogleFonts.poppins(
//                     textStyle:
//                         const TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
