import 'package:flutter/material.dart';

class MyTextFieldSettings extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextFieldSettings({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  _MyTextFieldSettingsState createState() => _MyTextFieldSettingsState();
}

class _MyTextFieldSettingsState extends State<MyTextFieldSettings> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: const Color(0xFFE76F51)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: TextField(
            controller: widget.controller,
            focusNode: focusNode,
            obscureText: widget.obscureText,
            obscuringCharacter: '*',
            onTap: () {
              if (widget.controller.text.isEmpty) {
                setState(() {
                  widget.controller.text = widget.hintText;
                });
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 0.10,
                letterSpacing: 0.20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
