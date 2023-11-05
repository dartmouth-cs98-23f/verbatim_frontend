import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:verbatim_frontend/widgets/my_button_with_image.dart';
import 'package:verbatim_frontend/widgets/my_button_no_image.dart';
import 'package:verbatim_frontend/Components/my_textfield.dart';
import 'sideBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:verbatim_frontend/widgets/custom_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verbatim_frontend/widgets/size.dart';
import 'package:verbatim_frontend/widgets/custom_tab.dart';
import 'dart:async';
import 'package:verbatim_frontend/Components/shared_prefs.dart';



class resetPassword extends StatefulWidget{

  const resetPassword({super.key});

  @override
  State<resetPassword>createState()=>_ResetPasswordState();
}

class _ResetPasswordState extends State<resetPassword> {
   final String assetName = 'assets/img1.svg';
   final oldPasswordController = TextEditingController();
   final newPasswordController = TextEditingController();
   final confirmPasswordController = TextEditingController();
   
     get padding => null;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Padding(padding: EdgeInsets.only(left:0.0),
            child: Align(
              alignment: Alignment.topCenter,
                child:Column(

                  children: [
                     // orange background
                    Container(
                      height: 220.v,
                      width: double.maxFinite,
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      child: SvgPicture.asset(
                        assetName,
                        fit: BoxFit.fill,
                      ),
                    ),

                    CustomAppBar(),

                    Positioned(
                        child: Center(
                        child: Text(
                          'Reset Password',
                            style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                     ),



                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left:30.0),
                      child: Align(
                                              alignment: Alignment.topLeft,
                          child:const Text(
                          'Old password',
                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w700,
                          height: 0.04,
                          letterSpacing: 0.30,
                        ),
                       ),
                      )
                    ),
                    
                    const SizedBox(height: 10),

                    MyTextField(
                      controller: oldPasswordController,
                      hintText: 'Current password',
                      obscureText: false,),

                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left:30.0),
                      child: Align(
                                              alignment: Alignment.topLeft,
                          child:const Text(
                          'New password',
                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w700,
                          height: 0.04,
                          letterSpacing: 0.30,
                        ),
                       ),
                      )
                    ),
                    
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: newPasswordController,
                      hintText: 'New password',
                      obscureText: false,),


                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left:30.0),
                      child: Align(
                                              alignment: Alignment.topLeft,
                          child:const Text(
                          'Confirm password',
                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w700,
                          height: 0.04,
                          letterSpacing: 0.30,
                        ),
                       ),
                      )
                    ),
                    
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm password',
                      obscureText: false,),

                  ],
            )

          ),
        )
      );
   }
}




