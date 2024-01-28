import 'package:flutter/material.dart';

class NewNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 390,
          height: 60.45,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 202,
                height: 24,
                padding: const EdgeInsets.all(10),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Color(0xFFFFF7EE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),

                      child: Stack(),

                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 310,
                      height: 5,
                      child: Text(
                        'Search Users',
                        style: TextStyle(
                          color: Color(0xFF252323),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0.11,
                          letterSpacing: 0.20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 4,
                height: 40.45,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
              ),
              Container(
                width: 40,
                height: 40.45,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://via.placeholder.com/40x40"),
                    fit: BoxFit.fill,
                  ),
                  shape: OvalBorder(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}