// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, unnecessary_null_comparison, non_constant_identifier_names, unused_local_variable, unused_element, use_build_context_synchronously, unused_label, unused_import, avoid_unnecessary_containers, avoid_types_as_parameter_names

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget 
{

  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile>
{
  late String mailuser = "email";

  late String name = "Name";
  late String mail = "Email";
  late String phone = "Phone";
  late String lpn1 = "123TN1234";
  late String lpn2 = "123TN1234";
  late String curpas = "Current Password";
  late String newpas = "New Password";
  late List<dynamic> lpns = []; // List to store license plate numbers
  String selectedLanguage = 'English';
  bool isDarkMode = true;

  
  @override
  void initState() 
  {
    super.initState();
    ProfileData();
    loadSet();
  }

  Future<void> loadSet() async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() 
    {
      selectedLanguage = prefs.getString('language')?? 'English';
      print(isDarkMode);
      isDarkMode = prefs.getBool('darkMode')?? true;
    });
  }
  
  Future<bool?> showConfirmationDialog(BuildContext context , String title , String msg , IconData icon, Color clr) 
  {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title , textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 50,
              color: clr,
            ),
            SizedBox(height: 20),
            Text(msg),
          ],
        ),

        
        actions: [
          TextButton(
            onPressed: () {
              // Handle cancel action
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
            onPressed: () {
                print("hell");              
                Navigator.of(context).pop(true);
            },
            child: Text('Confirm',style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    },
  );
}

      Future<bool?> showstatus(BuildContext context , String title , String msg , IconData icon , Color color) 
        {
        return showDialog<bool>
        (
          context: context,
          builder: (BuildContext context) 
          {
            return AlertDialog(
              title: Text(title , textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 50,
                    color: color,
                  ),
                  SizedBox(height: 20),
                  Text(msg),
                ],
              ),
            );
          },
        );
      }

      void Logout() async 
      {
        bool? result = await showConfirmationDialog(context, "Confirmation", "Are you sure you want to Log Out?", Icons.warning, Colors.orange);

        if (result != null && result) 
        {
          print('User confirmed');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('user');
          Navigator.pushNamed(context, '/loginpage');
        } 
        else 
        {
          print('User canceled');
        }
      }

  String cryptageData(String input) 
  {
    return md5.convert(utf8.encode(input)).toString();
  }
  

Future<void> ProfileData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userEmail = prefs.getString('user');
  print('User email: $userEmail');

  try {
    if (userEmail == null) {
      print('User email is null');
      return;
    }

    String server = prefs.getString('server') ?? '192.168.178.16';
    String port = prefs.getString('port') ?? '5000';
    final userUrl = 'http://$server:$port/user/$userEmail';

    final response = await http.get(Uri.parse(userUrl), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      // Access the nested 'user' object
      var userData = jsonResponse['user'];

      // Update state variables with user data
      setState(() {
        name = userData['name'] ?? 'Name not available';
        mail = userData['email'] ?? 'Email not available';
        phone = userData['phoneNumber'] ?? 'Phone number not available';
        String pass = userData['password'] ?? 'Password not available';
        
        lpns = [
          userData['lpn1'] ?? '',
          userData['lpn2'] ?? '',
          userData['lpn3'] ?? '',
          userData['lpn4'] ?? '',
        ].where((lpn) => lpn.isNotEmpty).toList();
      
          print(userData['lpn1']);

        print(pass);

        prefs.setString('cps',pass);
        
      });
    } else {
      print("Failed to load user data: ${response.statusCode}");
      // Handle error cases
      // You can show an error message to the user or retry the request
    }
  } catch (e) {
    print('Error fetching user data: $e');
    // Handle exceptions
    // You can show an error message to the user or retry the request
  }
}


  Future<void> showUpdateUserDialog() async 
  {
    String newName = name;
    String newMail = mail;
    String newPhone = phone;
    String newlpn1 = lpn1;
    String newlpn2 = lpn2;
    String actualPassword = curpas;
    String newPassword = newpas;


    return showDialog
    (
      context: context,
      builder: (BuildContext context) 
      {
        return AlertDialog
        (
          backgroundColor: Color(0xFF080a16),
          title: Text
          (
            'Update Profile',
            style: TextStyle
            (
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: SingleChildScrollView
          (
            child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>
              [
                Container
                (
                  height: 60,
                  decoration: BoxDecoration
                  (
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[800],
                  ),
                  child: TextField
                  (                  
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) => newName = value,
                    decoration: InputDecoration
                    (
                      labelText: 'Name',                    
                      labelStyle: TextStyle(color: Colors.white),                    
                      border: InputBorder.none,                    
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),

            const SizedBox(height: 15),

                Container
                (
                  height: 60,
                  decoration: BoxDecoration
                  (
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[800],
                  ),

                  child: TextField
                  (    
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) => newMail = value,
                    decoration: InputDecoration
                    (
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),                    
                      border: InputBorder.none,                    
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),

     const SizedBox(height: 15),

                Container
                (
                  height: 60,
                  decoration: BoxDecoration
                  (
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[800],
                  ),
                  child: TextField
                  (                    
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) => newPhone = value,
                    decoration: InputDecoration
                    (
                      labelText: 'Phone',
                      labelStyle: TextStyle(color: Colors.white),                    
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),

const SizedBox(height: 15),

                Container
                (
                  height: 60,
                  decoration: BoxDecoration
                  (
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[800],
                  ),
                  child: TextField
                  (                    
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) => newlpn1 = value,
                    decoration: InputDecoration
                    (
                      labelText: 'Licence Plate Number 1',
                      labelStyle: TextStyle(color: Colors.white),                    
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),


const SizedBox(height: 15),

                Container
                (
                  height: 60,
                  decoration: BoxDecoration
                  (
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[800],
                  ),
                  child: TextField
                  (                    
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) => newlpn2 = value,
                    decoration: InputDecoration
                    (
                      labelText: 'Licence Plate Number 2',
                      labelStyle: TextStyle(color: Colors.white),                    
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),

      const SizedBox(height: 15),

                Container
                (
                  height: 60,
                  decoration: BoxDecoration
                  (
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[800],
                  ),
                  child: TextField
                  (    
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) => curpas = value,
                    decoration: InputDecoration
                    (
                      labelText: 'Current Password',
                      labelStyle: TextStyle(color: Colors.white),                    
                      border: InputBorder.none,                    
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),

        const SizedBox(height: 15),

                Container
                (
                  height: 60,
                  decoration: BoxDecoration
                  (
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[800],
                  ),
                  child: TextField
                  (    
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) => newpas = value,
                    decoration: InputDecoration
                    (
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: Colors.white),                    
                      border: InputBorder.none,                    
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
          actions: <Widget>
          [
            ElevatedButton
            (
              onPressed: () async 
              {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? actualStoredPassword = prefs.getString('cps');
                

                // Save the updated data to the database
                String server = prefs.getString('server') ?? '192.168.178.16';
                String port = prefs.getString('port') ?? '5000';

                final userUrl = 'http://$server:$port/modifyUser/$mail';
                
                final response = await http.put
                (
                  Uri.parse(userUrl),
                  headers: <String, String>
                  {
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>
                  {
                    'name': newName,
                    'email': newMail,
                    'phoneNumber': newPhone,
                    'password': cryptageData(newpas),
                    'lpn1': newlpn1,
                    'lpn2': newlpn2,
                  }),
                );

                if (response.statusCode == 200) 
                {
                    name = newName;
                    mail = newMail;
                    phone = newPhone;
                    lpn1 = newlpn1;
                    lpn2 = newlpn2;

                    print("User data Updated Successfully . . .");

                    await showstatus(context, "Success", "Updated Succesfully", Icons.done, Colors.green);


                  Future.delayed(Duration(seconds: 1), () 
                  {           
                    Navigator.of(context).pop();
                  });
                }
                else 
                {
                  print('Failed to update user: ${response.statusCode}');
                }
              },
              child: Text('Update'),
            ),

            ElevatedButton
            (
              onPressed: () 
              {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
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
        resizeToAvoidBottomInset: false,
        backgroundColor: isDarkMode ? Color(0xFF080a16) : Colors.white,
      
        body: SingleChildScrollView
        (
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: 
            [
              AppBar
              (
                automaticallyImplyLeading: false,
                title: Text
                (
                  "Profile",
                  style: TextStyle
                  (
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
               ),
                            
                  backgroundColor: isDarkMode ? Color(0xFF080a16) : Colors.white,
                  centerTitle: true,
                  leading:
                    IconButton
                    (
                      onPressed: Logout,
                      icon: Icon
                      (
                        Icons.logout,      
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  actions: 
                  [
                    Padding
                    (
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: IconButton
                      (
                        icon: Icon
                        (
                          Icons.edit,
                          color: isDarkMode ? Colors.white : Colors.black,
                          size: 30,
                        ),
                        
                        tooltip: 'Edit Profile',
                        onPressed: showUpdateUserDialog,
                      ),
                    )  
                  ],
                ),                         
                            
                const SizedBox(height:30),
                            
                          Center
                          (
                            child: Container
                            (
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration
                              (
                                shape: BoxShape.circle,
                              ),
                              child: Padding
                              (
                                padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                                child: ProfilePicture
                                (
                                  name: name,
                                  radius: 31,
                                  fontsize: 45,
                                  tooltip: true,
                                  role: 'User',
                                ),
                              ),
                            ),
                          ),
                        
             const SizedBox(height:75),
                            
                      Center
                      (
                        child: Container
                        (
                          width: 350,
                          height: 40,
                          decoration: BoxDecoration
                          (
                             color: isDarkMode ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                      
                          child: Row
                          (
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: 
                            [
                              SizedBox(width:15),
                            
                              Padding
                              (
                                padding: EdgeInsets.zero,
                                child: Icon
                                (
                                  Icons.person, color: isDarkMode ? Color(0xFF5e3b91): Color.fromARGB(255, 213, 190, 252),
                                ),
                              ),
                            
                                  SizedBox(width:15),
                      
                                Container
                                (
                                  alignment: Alignment.center,
                                  child: Text
                                  (
                                    name,
                                    style: TextStyle
                                    (
                                      color: isDarkMode ? Colors.black : Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                            
             const SizedBox(height:20),
                            
                      Center
                      (
                        child: Container
                        (
                          width: 350,
                          height: 40,
                          decoration: BoxDecoration
                          (
                             color: isDarkMode ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                      
                          child: Row
                          (
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: 
                            [
                                SizedBox(width:15),
                            
                              Icon(Icons.mail, color: isDarkMode ? Color(0xFF5e3b91): Color.fromARGB(255, 213, 190, 252)),
                      
                                SizedBox(width:15),
                      
                              Text
                              (
                                mail,
                                style: TextStyle
                                (
                                  color: isDarkMode ? Colors.black : Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                            
              const SizedBox(height:20),
                            
                      Center
                      (
                        child: Container
                        (
                          width: 350,
                          height: 40,
                          decoration: BoxDecoration
                          (
                            color: isDarkMode ? Colors.white : Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                      
                          child: Row
                          (
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: 
                            [
                              SizedBox(width:15),
                            
                              Icon(Icons.phone,color: isDarkMode ? Color(0xFF5e3b91) : Color.fromARGB(255, 213, 190, 252) ),
                      
                              SizedBox(width:15),
                      
                              Text
                              (
                                phone,
                                style: TextStyle
                                (
                                  color: isDarkMode ? Colors.black : Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                            
                           const SizedBox(height:10),
               
          if (lpns.isNotEmpty)
            Column(
              children: lpns
                  .map(
                    (lpn) => Container(
                      width: 350,
                      height: 40,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 15),
                          Icon(
                            Icons.directions_car_filled,
                            color: isDarkMode ? Color(0xFF5e3b91) : Color.fromARGB(255, 213, 190, 252),
                          ),
                          SizedBox(width: 10),
                          Text(
                            lpn,
                            style: TextStyle(
                              color: isDarkMode ? Colors.black : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
                            
                      /*Center
                      (
                        child: GestureDetector
                        (
                          onTap: Logout,
                          child: Container
                          (
                            width: 200,
                            height: 60,
                            alignment: Alignment.center,
                            
                            decoration: BoxDecoration
                            (
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              gradient: RadialGradient
                              (
                                radius: 1,
                                
                                colors: <Color>
                                [
                                  Color.fromARGB(255, 149, 97, 202),
                                  Color(0xFF810cf5),
                                  Color(0xFFa64efc),
                                ]
                              ),
                            ),
                          
                            child: Padding
                            (
                              padding: EdgeInsets.all(15.0),
                              child: Text
                              (
                                'Logout ',
                                style: TextStyle
                                (
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),*/  
                    ],
                  ),
                ),
              ),
    );
  }
}