import "package:flutter/material.dart";

class SquareTile extends StatelessWidget 
{
  final String imagePath;
  final double height,width;
  
  const SquareTile
  (
    {
      super.key,
      required this.imagePath,
      required this.height,
      required this.width
    }
  );

  @override
  Widget build(BuildContext context) 
  {
    return  Container
    (
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration
      (
        border: Border.all(color: Colors.white),
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        color: Colors.grey[200],
      ),
      
      child: Image.asset
      (
        imagePath,
        height: height,
        width: width,
      ),
    );
  }
}