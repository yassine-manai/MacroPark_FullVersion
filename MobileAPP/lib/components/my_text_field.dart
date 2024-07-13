import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget 
{
  final TextEditingController controller;
  final String hintText,labelt;
  final bool obscureText;



  const MyTextField
  (
    {
      super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.labelt,
    }
  );

  @override
  MyTextFieldState createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> 
{
  bool _isObscure = false;

  @override
  Widget build(BuildContext context) 
  {
    return Padding
    (
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField
      (
        controller: widget.controller,
        obscureText: _isObscure,
        decoration: InputDecoration
        (
          labelText: widget.labelt,
          enabledBorder: const OutlineInputBorder
          (
            borderSide: BorderSide(color: Colors.white),
          ),

          focusedBorder: const OutlineInputBorder
          (
            borderSide: BorderSide(color: Colors.white),
          ),

          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,

          hintStyle: TextStyle
          (
            color: Colors.grey[500]),
            suffixIcon: widget.obscureText?
            IconButton
            (
              onPressed: () 
              {
                setState(() 
                {
                  _isObscure = !_isObscure;
                });
              },

                icon: 
                Icon
                (
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
            )
          :null,
        ),
      ),
    );
  }
}
