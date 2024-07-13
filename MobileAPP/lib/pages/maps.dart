// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_element, avoid_print, unused_local_variable, avoid_unnecessary_containers, sized_box_for_whitespace, dead_code

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Maps extends StatefulWidget 
{
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> 
{
  
  late WebViewController controller;

 @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://www.google.com/maps"))
      ..setBackgroundColor(Color(0xFF080a16));
      

    super.initState();
  }


  @override
  Widget build(BuildContext context) 
  {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Container
    (
      height: screenHeight,
      width: screenWidth,
      
      child: Scaffold
      (
         backgroundColor: Color(0xFF080a16),

        resizeToAvoidBottomInset: false,
        appBar: AppBar
        (
          automaticallyImplyLeading: false,
          title: Text
          (
            "Maps",
            style: TextStyle
            (
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white        
            ),
          ),

        backgroundColor: Color(0xFF080a16),
        
        centerTitle: true,
        ),
        body: WebViewWidget(
        controller: controller
        
      ),
    )
    );
  }
}
