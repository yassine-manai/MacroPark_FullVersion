/* // ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_element, avoid_print, unused_local_variable, avoid_unnecessary_containers, sized_box_for_whitespace, dead_code

import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget 
{
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> 
{
  double brightness = 0.5;
  String selectedLanguage = 'English';
  bool isDarkMode = true;

  @override
  void initState() 
  {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() 
    {
      brightness = prefs.getDouble('brightness') ?? 0.5;
      selectedLanguage = prefs.getString('language') ?? 'English';
      isDarkMode = prefs.getBool('darkMode') ?? true;
    });
  }

  Future<void> saveSettings() async 
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('brightness', brightness);
    await prefs.setString('language', selectedLanguage);
    await prefs.setBool('darkMode', isDarkMode);

    ScaffoldMessenger.of(context).showSnackBar
    (
      SnackBar
      (
        content: Text('Settings saved successfully'),
      ),
    );
  }

  Future<void> setBrightness(double value) async 
  {
    try 
    {
      await ScreenBrightness().setScreenBrightness(value);
    } 
    catch (e) 
    {
      print(e);
      throw 'Failed to set brightness';
    }
  }

  Future<bool?> showstatus(BuildContext context , String title , String msg , IconData icon , Color color) 
        async {
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

      Navigator.of(context).pop();
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
        appBar: AppBar
        (
          automaticallyImplyLeading: false,
          title: Text
          (
            "Settings",
            style: TextStyle
            (
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: isDarkMode ? Colors.white : Colors.black          
            ),
          ),

        backgroundColor: isDarkMode ? Color(0xFF080a16) : Colors.white,
        
        centerTitle: true,
        ),
        body: Padding
        (
          padding: const EdgeInsets.all(16.0),
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>
            [
              Text
              (
                'Brightness',
                style: TextStyle
                (
                  fontSize: 18.0, 
                  fontWeight: FontWeight.bold, 
                  color: isDarkMode ? Colors.white : Colors.black
                ),
              ),
             Slider
             (
                value: brightness,
                onChanged: (value) 
                {
                  setState(() 
                  {
                    setBrightness(value);
                    brightness = value; 
                  });
                },
              ),
      
              
              SizedBox(height: 20.0),
      
              Row
              (
                children: 
                [
                  Text
                  (
                    'Language',
                    style: TextStyle
                    (
                      fontSize: 18.0, 
                      fontWeight: FontWeight.bold, 
                      color: isDarkMode ? Colors.white : Colors.black
                    ),
                  ),
                  SizedBox(width: 40),
      
              DropdownButton<String>
              (
                iconSize: 24,
                elevation: 16,
                focusColor: isDarkMode?  Colors.black : Colors.white,
                dropdownColor: isDarkMode?  Colors.black : Colors.white,
                value: selectedLanguage,
                onChanged: (newValue) 
                {
                  setState(() 
                  {
                    selectedLanguage = newValue!;
                  });
                },
      
                items: <String>['English', 'French', 'Arabic'].map<DropdownMenuItem<String>>((String value) 
                {
                  return DropdownMenuItem<String>
                  (
                    value: value,
                    child: Text
                    (
                      value,
                    ),
                  );
                }).toList(),
              ),
      
                ],
              ),
              
              SizedBox(height: 20.0),
              
              Row(
                children: <Widget>
                [
                  Text
                  (
                    'Dark Mode',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                  ),
      
                  SizedBox(width: 40),
      
                  Switch
                  (
                    value: isDarkMode,
                    onChanged: (value) 
                    {
                      setState(()
                      {
                        isDarkMode = value;
                      });
                    },
                  ),
                ],
              ),
      
              SizedBox(height: 50.0),
      
              Center
              (
                child: ElevatedButton
                (
                  onPressed: () async => await showstatus(context, "Success", " Saved Successfully", Icons.done, Colors.green),

                  style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Colors.white : Colors.black),
                  child: 
                    Text
                    (
                      'Save Settings',
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.black : Colors.white),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 */