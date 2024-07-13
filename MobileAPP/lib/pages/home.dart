// ignore_for_file: avoid_print, unused_local_variable, non_constant_identifier_names, deprecated_member_use, unused_import, file_names, avoid_unnecessary_containers, use_build_context_synchronously, unnecessary_const, prefer_const_constructors, prefer_adjacent_string_concatenation, unused_element, unnecessary_type_check, unnecessary_null_comparison, sized_box_for_whitespace, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget 
{
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> 
{
  bool isScanning = false;
  late String Blt;
  bool isBluetoothConnected = false;
  BeaconBroadcast beaconBroadcast = BeaconBroadcast();
  String selectedLanguage = 'English';
  bool isDarkMode = true;


  @override
  void initState() 
  {
    super.initState();
    BltStat();
    loadSet();
    requestPermissions();

 /*    Timer.periodic(Duration(hours: 1), (timer) {
    verifyLogin();
  }); */
  }

    void showAlertDialog(BuildContext context) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Denied'),
            content: Text('Allow access to Settings'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  print('Settings');
                  Navigator.of(context).pop();
                },
                child: Text('Settings'),
              ),
            ],
          );
        },
      );
    }


    void requestPermissions() async {
    bool permGranted = false;

    // Request permissions
    var statuses = await [
      Permission.location,
      Permission.bluetoothAdvertise,
    ].request();

    // Check if all permissions are granted
    if (statuses[Permission.location]!.isGranted &&
        statuses[Permission.bluetoothAdvertise]!.isGranted ) {
      permGranted = true;
    }
    else
    {
      print('Access Denied');
      showAlertDialog(context);
    }
       print('Permissions granted: $permGranted');
  }

  Future<void> BltStat() async 
  {
    try 
    {
      if (!(await FlutterBluePlus.isAvailable)) 
      {
        print("Bluetooth is not available on this device");
        return;
      }

      if (!(await FlutterBluePlus.isOn)) 
      {
        print("Bluetooth is not turned on");
        return;
      }

      setState(() 
      {
        isBluetoothConnected = true;
      });
    } 
    catch (e) 
    {
      print("Error connecting to device: $e");
    }
  }    
  
    bool isValidUUID(String? uuid) 
    {
      if (uuid == null) return false;
      final pattern = RegExp
      (
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
      );  
      return pattern.hasMatch(uuid);
    }

void _showLoadingDialog(String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            
            shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),         
                   borderRadius: BorderRadius.circular(15.0),
            ),
            backgroundColor: Colors.black,
            content: Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white,),
                SizedBox(width: 20),
                Text(text, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );
      },
    );
  }

  

/*   void verifyLogin() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String server = prefs.getString('server') ?? '192.168.178.16';
    String port = prefs.getString('port') ?? '8000';
    String loginEndpoint = "login";
    var apiUrl = Uri.parse('http://$server:$port/$loginEndpoint');

    final response = await http.post(
      apiUrl,

    );

    if (response.statusCode == 200) {
      debugPrint('User is still logged in');
    } else {
      debugPrint('User is no longer logged in, logging out...');
      logout();
    }
  } catch (e) {
    debugPrint('Exception occurred while verifying login: $e');
  }
}

void logout() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear(); 
    Navigator.pushNamedAndRemoveUntil(context, '/loginpage', (route) => false);
  } catch (e) {
    debugPrint('Exception occurred while logging out: $e');
  }
}
 */

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
                children: 
                [
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
    
  Future<void> openGate() async 
  {

    if(!isBluetoothConnected)
    {
        await showstatus(context, "Error", "Bluetooth not activated ", Icons.warning, Colors.red);

    }
else
{

   SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('ui');

    print('id: $id');

    // exp 00000000-0000-0000-0000-0000.0000.0000

    if (id != null) 
    {
      try 
      {
        //int myInt = int.tryParse(id) ?? 0; 
        //String hexString = myInt.toRadixString(16); 
        
        //String Cid = 'F8';

        //print('Hex String: $hexString');
    
        String uuid = 'F826'+'$id'+'0-0122-3344-0509-9C398FC199D2';

        //String uuid = 'F83261ef01010000f850';

        //String u = 'F83261ef-0101-0000-f850';
        print('Generated UUID: $uuid');

        bool isValid = isValidUUID(uuid);

        if (isValid) 
        {
          try 
          {
            
            _showLoadingDialog("Sending Command . . .");

            beaconBroadcast
                .setUUID(uuid)
                .setIdentifier("15")
                .setMajorId(1)
                .setMinorId(100)
                .start();
                          
            print('--------------------------------BLE Signal Advertised --------------------------------------');


            /* ScaffoldMessenger.of(context).showSnackBar
            (
              SnackBar
              (
                content: Text(' Openeing Barrier ', style: TextStyle(color: Colors.black),),
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.white,
                behavior: SnackBarBehavior.floating,
              ),
            );    

            ScaffoldMessenger.of(context).showSnackBar
            (
              SnackBar
              (
                content: Text(' Barrier Opened ', style: TextStyle(color: Colors.black),),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.white,
                behavior: SnackBarBehavior.floating,
              ),
            ); 
 */
          
        await Future.delayed(Duration(seconds: 3));
      
         Navigator.of(context).pop();

            beaconBroadcast
              .setUUID(uuid)
              .stop();

            print('--------------------------------BLE Signal Stopped --------------------------------------');

          } 
          catch (e) 
          {
            Navigator.of(context).pop();
            print('*************************** Error Broadcasting BLE Signal: $e ********************************');
          }
        } 
        else 
        {
          print('**************************************** Invalid UUID: $uuid ********************************');
        }
      } 
      catch (e) 
      {
        print('Error: $e');
      }
    } 
    else 
    {
      print('ID not found in SharedPreferences');
    }
  }
  }
  /*Future<void> OpenGate() async 
  {

    try 
    {
      beaconBroadcast
        .setUUID('39ED98FF-2900-441A-802F-9C398FC199D2')
        .setMajorId(1)
        .setMinorId(100)
        .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
        .setManufacturerId(0x004c)
        .start();

      ScaffoldMessenger.of(context).showSnackBar
      (
        SnackBar
        (
          content: Text('Sent Succesfully'),
        ),
      );    
    } 
    catch (e) 
    {
      print('Failed to start beacon advertising: $e');
      ScaffoldMessenger.of(context).showSnackBar
    (
      SnackBar
      (
        content: Text('Failed'),
      ),
    );    
  }



    /*
    final customSignalData = [0x00, 0x00, 0x00, 0x00];
    final eddystoneFrame = EddystoneUidFrame
    (
      namespaceId: [0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF], 
      instanceId: customSignalData,
    );
    */

    print('BLE Signal Sent Successfully');
  }*/


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
        backgroundColor: isDarkMode ? const Color(0xFF080a16) : Colors.white,
        
        body: Column
        (
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: 
          [
            AppBar
            (
              automaticallyImplyLeading: false,
              title: Text
              (
                "Welcome",
      
                style: TextStyle
                (
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color:  Colors.white,
                ),
              ),
      
              backgroundColor: const Color(0xFF080a16),
              centerTitle: true,
            ),
            
      const SizedBox(height: 30),
            Center
            (
              child: Container
              (
                alignment: Alignment.center,
                width: screenWidth/1.5,
                height: 60,
                decoration: BoxDecoration
                (
                  color: const Color(0xFFA367B1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding
                (
                  padding: EdgeInsets.all(15.0),
                  child: Text
                  (
                    'Main Entry',
                    style: TextStyle
                    (
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
      
          const SizedBox(height: 40),
      
            Row
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
                Center
                (
                  child: Image.asset
                  (
                    isBluetoothConnected ? 'images/Connected.png' : 'images/not_connected.png',
                    width: 25,
                    height: 25,
                  ),
                ),
                Padding
                (
                  padding: const EdgeInsets.all(10.0),
                  child: Text
                  (
                    'Bluetooth :',
                    style: TextStyle
                    (
                      fontSize: 22,
                      color: Colors.white,          
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
      
                const SizedBox(width: 10),
      
                Text
                (
                  isBluetoothConnected ? 'Connected' : 'Not connected',
                  style: TextStyle
                  (
                    color: isBluetoothConnected ? Colors.green : Colors.red,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 50),
      
            Center
            (
              child: Image.asset
              (
                isDarkMode ? 'images/main.png' : 'images/main_img.png',
                width: 200,
                height: 200,
              ),
            ),
      
            const SizedBox(height: 40),
      
            Center
            (
              child: GestureDetector
              (
                onTap: openGate,
                child: Container
                (
                  width: 200,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration
                  (
                    gradient: RadialGradient
                    (
                      radius: 1,
                      colors:
                       [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Color(0xFF810cf5),
                        ]
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding
                  (
                    padding: const EdgeInsets.all(15.0),
                    child: Text
                    (
                      'Click to OPEN',
                      style: TextStyle
                      (
                        color:Colors.white,          
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30), 
          ],
        ),
      ),
    );
  }
}
