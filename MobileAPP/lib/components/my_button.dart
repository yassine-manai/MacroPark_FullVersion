import "package:flutter/material.dart";

class MyButton extends StatelessWidget 
{

  final Function()? onTap;


  const MyButton
  (
    {
      super.key, 
      required this.onTap,
      required this.textButton,
      required this.hb,
      required this.wb,
    }
  );

  final String textButton;
  final double hb,wb;

  @override
  Widget build(BuildContext context) 
  {
    return SizedBox
    (
      height: hb,
      width: wb,
      child: GestureDetector
      (
        onTap: onTap,
        child: Container
        (
          margin: const EdgeInsets.symmetric(horizontal: 35),
          decoration: 
          const BoxDecoration(
            color: Color(0xFF810cf5),
            borderRadius: BorderRadius.all(Radius.circular(18))),
            
          child:  Center
          (
            child: Text
            (
              textButton,
              style: 
              const TextStyle
              (
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ) 
          ),
        ),
      ),
    );
  }
}