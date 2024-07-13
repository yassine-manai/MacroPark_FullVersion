// ignore_for_file: library_private_types_in_public_api, avoid_print, unused_local_variable, unused_label, unused_import, non_constant_identifier_names, use_build_context_synchronously, prefer_const_constructors, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:temp1/components/my_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';


class RegisterPage extends StatefulWidget 
{
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> 
{
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  // data to add // 
  final TextEditingController emailController = TextEditingController(); // ok
  final TextEditingController phoneController = TextEditingController(); // ok 

  final TextEditingController passwordController = TextEditingController(); // ok 
  final TextEditingController confpasswordController = TextEditingController(); // ok 

  final TextEditingController nameController = TextEditingController(); //ok

  final TextEditingController lpn1Controller = TextEditingController(); //ok
  final TextEditingController lpn2Controller = TextEditingController(); //ok
  // * * * * * * //


  TextEditingController serverController = TextEditingController(); // ok
  TextEditingController portController = TextEditingController(); //ok

  bool isObscureP = true;
  bool isObscureCP = true;

  @override
  void initState() 
  {
    super.initState();
  }

  /* **************** C R Y P T A G E   F U N C T I O N ******************* */

  String cryptageData(String input) 
  {
    return md5.convert(utf8.encode(input)).toString();
  }


  /* **************** Network  F U N C T I O N ******************* */
  void SettingsLogin() 
  {
    showDialog
    (
      context: context,
      builder: (BuildContext context) 
      {
        return AlertDialog
        (
          title: const Text("Network Settings", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
          content: Column
          (
            mainAxisSize: MainAxisSize.min,
            children: 
            [
              const Text("Add Server and Port to Connect", style: TextStyle(color: Colors.white)),

              const SizedBox(height: 15),

              Container
              (
                height: 50,
                decoration: BoxDecoration
                (
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[800],
                ),

                child: TextFormField
                (
                  controller: serverController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration
                  (
                    labelText: 'Server',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),

              SizedBox(height: 16),

              Container
              (
                height: 50,
                decoration: BoxDecoration
                (
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[800],
                ),

                child: TextFormField
                (
                  controller: portController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration
                  (
                    labelText: 'Port',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),
            ],
          ),

          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

          actions: <Widget>
          [
            ElevatedButton
            (
              child: const Text("Save", style: TextStyle(color: Colors.black)),
              onPressed: () 
              {
                saveSettings(serverController.text, portController.text);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

void saveSettings(String server, String port) async 
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('server', server);
  await prefs.setString('port', port);
}

/* **************** Register F U N C T I O N ******************* */

void signUserUp() async
 {
  String userEmail = emailController.text;
  String userPassword = passwordController.text;
  String userPhoneNumber = phoneController.text;

  String name = nameController.text;

  String lpn1 = lpn1Controller.text;
  String lpn2 = lpn2Controller.text;

  String passwordCrypted = cryptageData(userPassword);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String server = prefs.getString('server') ?? '127.0.0.1';
  String port = prefs.getString('port') ?? '8100';
  String reg = "addGuest";

  if (server.isEmpty || port.isEmpty) 
  {
    debugPrint('Server or port not specified in SharedPreferences');
    return;
  }

  if(userEmail.isEmpty || userPassword.isEmpty || lpn1.isEmpty || userPhoneNumber.isEmpty || name.isEmpty)
  {
    await showStatus(context, "Warning", "All fields are required ", Icons.warning, Colors.red, Duration(seconds: 2));
    return;
  }


  String signUpUrl = 'http://$server:$port/$reg';

  //Map to add data
  Map<String, dynamic> userData = 
  {
    "email": userEmail,
    "name": name,
    "password": passwordCrypted,
    "phoneNumber": userPhoneNumber,
    "lpn1": lpn1,
    "lpn2": lpn2
  };

  // Encode the userData map to JSON format
  String jsonBody = jsonEncode(userData);
  print(jsonBody);

  // Send POST request using http package
  try {
    var response = await http.post(
      Uri.parse(signUpUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
      
    );

    if (response.statusCode == 200 || response.statusCode == 201) 
    {
      print('User sign-up successful');

      await showStatus(context, "Registred Successfully", "Wait the admin to approuve your account", Icons.check_circle_rounded, Colors.green, Duration(seconds: 2));

      Navigator.of(context).pop();

      Future.delayed(Duration(seconds: 3), () 
      {
        Navigator.pushNamed
        (
          context,
          '/loginpage',
          arguments: 
          {
            'email': userEmail,
            'password': userPassword,
          },
        );
      });
    }

    else 
    {
      await showStatus(context, "Failed", "Sign up Failed user already exist", Icons.dangerous, Colors.red, Duration(seconds: 4));
      debugPrint('User sign-up failed with status (user already exist): ${response.statusCode}');
    }
  } 
  catch (e) 
  {
    debugPrint('Error: $e');
  }
}

  /* **************** Redirect to L O G I N   F U N C T I O N ******************* */

  void signUserIn() 
  {
    Navigator.pushNamed(context, '/loginpage');
  }

  Future<bool?> showStatus(BuildContext context, String title, String msg, IconData icon, Color color, Duration delay) async 
  {
    // Show the dialog
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Text(msg),
              Icon(
                icon,
                size: 50,
                color: color,
              ),
              
            ],
          ),
        );
      },
    );

    if (result != null) {
      await Future.delayed(delay);
    }

    // Return the result
    return result;
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
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFF080a16),
      
        body: SingleChildScrollView
        (
          child: SafeArea
          (
            child: Form
            (
              key: form,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Center
              (
                child: Column
                (
                  children: 
                  [
                    GestureDetector
                    (
                      onTap: SettingsLogin,
                      child: const Row
                      (
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: 
                        [
                          Padding
                          (
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                            child: Icon(Icons.settings,color: Colors.white,size: 35),
                          ),
                        ],
                      ),
                    ),
          
          
          /* **************** T E X T : Register to Know more ******************* */
                  
                    Text
                    (
                      "Register as a Guest",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
          
                    const SizedBox(height: 30),


                    SizedBox
                    (
                      height: 50,
                      width: screenWidth/1.2,
                      child: TextFormField
                      (
          
                        keyboardType: TextInputType.name,                    
                        controller: nameController,
          
                          validator: (value) 
                          {
                            if (value?.isEmpty ?? true) 
                            {
                              return 'NameEmail is required';
                            }
                            
                            return null;
                          },

          
                        decoration: InputDecoration
                        (
                          labelText: 'Name',
          
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
          
                          focusedErrorBorder: const OutlineInputBorder
                          (
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    
                   
                    const SizedBox(height: 10),
          
                /* **************** F I E L D : Email ******************* */
          
                    SizedBox
                    (
                      height: 50,
                      width: screenWidth/1.2,
                      child: TextFormField
                      (
          
                        keyboardType: TextInputType.emailAddress,                    
                        controller: emailController,
          
                          validator: (value) 
                          {
                            if (value?.isEmpty ?? true) 
                            {
                              return 'Email is required';
                            }
                            /*else if (!value!.contains('@')) 
                            {
                              return 'Invalid email format';
                            }
                            else if (!value!.contains('.')) 
                            {
                              return 'Invalid email format';
                            }*/
                            
                            return null;
                          },
          
          
                        decoration: InputDecoration
                        (
                          labelText: 'Email',
          
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
          
                          focusedErrorBorder: const OutlineInputBorder
                          (
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 10),
          
                  /* **************** F I E L D : Phone Number ******************* */
                    SizedBox
                    (
                      height: 50,
                      width: screenWidth/1.2,
                      child: TextFormField
                      (
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        validator: (value) 
                        {
                          if (value?.isEmpty ?? true) 
                          {
                            return 'Phone Number is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration
                        (
                          labelText: 'Phone Number',
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
          
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
          
                    const SizedBox(height: 10),

                    Container(
                      
                      child: Row
                      (
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                      
                          SizedBox
                          (
                            height: 50,
                            width: screenWidth/2.5,
                            child: TextFormField
                            (
                              controller: lpn1Controller,
                              
                              decoration: InputDecoration
                              (
                                labelText: 'Licence Plate 1',
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
                                    
                                hintStyle: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                          ),
                      
                          const SizedBox(width: 10),
                      
                          SizedBox
                          (
                            height: 50,
                            width: screenWidth/2.5,
                            child: TextFormField
                            (
                              controller: lpn2Controller,
                             
                              decoration: InputDecoration
                              (
                                labelText: 'Licence Plate 2',
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
                                    
                                hintStyle: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                          ),
                      
                      
                        ],
                      ),
                    ),
          
                    const SizedBox(height: 10),
          
                 /* **************** F I E L D : Password ******************* */
                    SizedBox
                    (
                      height: 50,
                      width: screenWidth/1.2,
                      child: TextFormField
                      (
                        controller: passwordController,
                        obscureText: isObscureP,
          
                        validator: (value) 
                        {
                          if (value?.isEmpty ?? true) 
                          {
                            return 'Password is required';
                          }
          
                          else if (value!.length < 8) 
                          {
                            return 'Password must be at least 8 characters long';
                          }
                          
                          return null;
                        },
                        decoration: InputDecoration
                        (
                          labelText: 'Password',
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
          
                          suffixIcon: IconButton
                          (
                            onPressed: () 
                            {
                              setState(() 
                              {
                                isObscureP = !isObscureP;
                              });
                            },
          
                       /* **************** I C O N : Show / Hide ******************* */
          
                            icon: Icon
                            (
                              isObscureP
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),

                          ),
                        ),
                      ),
                    ),
          
                    const SizedBox(height: 10),
                    
          
                 /* **************** F I E L D : Confirm Password ******************* */
                    SizedBox
                    (
                      height: 50,
                      width: screenWidth/1.2,
                      child: TextFormField
                      (
                        controller: confpasswordController,
                        obscureText: isObscureCP,
          
                        validator: (value) 
                        {
                          if (value?.isEmpty ?? true) 
                          {
                            return 'Password is required';
                          } 
          
                          else if (value != passwordController.text)
                          {
                            return 'Password do not match';
                          }
          
                          else if (value!.length < 8) 
                          {
                            return 'Password must be at least 8 characters long';
                          }
          
                          return null;
                        },
          
                        
                        decoration: InputDecoration
                        (
                          labelText: 'Confirm Password',
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
          
                          suffixIcon: IconButton
                          (
                            onPressed: () 
                            {
                              setState(() 
                              {
                                isObscureCP = !isObscureCP;
                              });
                            },
          
                   /* **************** I C O N : Show / Hide ******************* */
          
                            icon: Icon
                            (
                              isObscureCP
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
          

  
                    const SizedBox(height:50),


                    
          /* **************** R E G I S T E R  B U T T O N ******************* */
          
                    MyButton
                    (
                      onTap: signUserUp,
                      textButton: 'R  E  G  I  S  T  E  R ',
                      hb: 50,
                      wb: screenWidth,
                    ),
          
                    const SizedBox(height: 15),
          
            /* **************** O R  B L O C K  ******************* */
          
                    Padding
                    (
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row
                      (
                        children: 
                        [
                          Expanded
                          (
                            child: Divider
                            (
                              thickness: 0.5,
                              color: Colors.grey[700],
                            ),
                          ),
                          const Padding
                          (
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text
                            (
                              'Or ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded
                          (
                            child: Divider
                            (
                              thickness: 0.5,
                              color: Colors.grey[700],
                            ),
                          )
                        ],
                      ),
                    ),
          
                    const SizedBox(height: 15),
          
              /* **************** L O G I N  B U T T O N ******************* */
          
                    MyButton
                    (
                      onTap: signUserIn,
                      textButton: 'L  O  G  I  N ',
                      hb: 50,
                      wb: screenWidth,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
