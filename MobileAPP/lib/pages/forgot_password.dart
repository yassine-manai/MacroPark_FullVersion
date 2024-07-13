// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:temp1/components/my_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  String generatedCode = '';

  void ToLogin() {
    Navigator.pushNamed(context, '/loginpage');
  }

  Future<void> sendVerificationEmail(String email, String code) async {
    if (email.isEmpty || code.isEmpty) {
      showErrortext("Email or Code is Empty");
      debugPrint('Email or code is empty');
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String server = prefs.getString('server') ?? '192.168.178.16';
      String port = prefs.getString('port') ?? '8000';

      if (server.isEmpty || port.isEmpty) {
        debugPrint('Server or port not specified in SharedPreferences');
        return;
      }

      String sendEndpoint = "send_email";
      var apiUrl = Uri.parse('http://$server:$port/$sendEndpoint');

      final response = await http.post(
        apiUrl,
        body: json.encode({
          'to': email,
          'subject': 'Your Verification Code',
          'body': 'Your verification code is: $code',
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Email sent successfully to $email');
        showSuccessDialog();
        showVerificationCodeDialog();
      } else {
        debugPrint('Failed to send email: ${response.statusCode}, ${response.body}');
        showErrorDialog();
      }
    } catch (e) {
      debugPrint('Exception occurred while sending email: $e');
    }
  }

  void Reset() {
    String email = emailController.text;
    generatedCode = generateRandomCode();
    debugPrint(generatedCode);
    sendVerificationEmail(email, generatedCode);
  }

void showSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Success',style: TextStyle(color: Colors.white)),
        content: Text('Your action was successful.',style: TextStyle(color: Colors.white)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss dialog
            },
            child: Text('OK',style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    },
  );
}

void showErrorDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Error',style: TextStyle(color: Colors.white)),
        content: Text('An error occurred. Please try again later.',style: TextStyle(color: Colors.white)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK',style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    },
  );
}

void showVerificationCodeDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Enter Verification Code',style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              onChanged: (enteredCode) {
                if (enteredCode == generatedCode) {
                  Navigator.of(context).pop();
                  showPasswordResetDialog();
                }
              },
              
              decoration: InputDecoration(
                labelText: 'Verification Code',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              String enteredCode = ''; 
              if (enteredCode == generatedCode) {
                Navigator.of(context).pop();
                showPasswordResetDialog();
              }
            },
            child: Text('Verify',style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    },
  );
}

void showPasswordResetDialog() {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Reset Password',style: TextStyle(color: Colors.white),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle:TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle:TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (passwordController.text == confirmPasswordController.text) {
                changePassword(passwordController.text);
                Navigator.of(context).pop();
                showSuccessDialog();
                ToLogin();
              } else {
                showErrortext("Password do not match");
                debugPrint('Passwords do not match');
              }
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

void showErrortext(String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Error',style: TextStyle(color: Colors.white),),
        content: Text(errorMessage, style: TextStyle(color: Colors.white),),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss dialog
            },
            child: Text('OK',style: TextStyle(color: Colors.black),),
          ),
        ],
      );
    },
  );
}

  Future<void> changePassword(String password) async {
    if (password.isEmpty) {
      debugPrint('Password is empty');
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String server = prefs.getString('server') ?? '192.168.1.13';
      String port = prefs.getString('port') ?? '8200';
      String changePassEndpoint = "changepass";
      var apiUrl = Uri.parse('http://$server:$port/$changePassEndpoint');

      String hashedPassword = cryptageData(password);

      final response = await http.post(
        apiUrl,
        body: json.encode({
          'email': emailController.text,
          'password': hashedPassword,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      debugPrint(hashedPassword);
      if (response.statusCode == 200) {
        debugPrint('Password changed successfully');
      } else {
        debugPrint('Failed to change password: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      debugPrint('Exception occurred while changing password: $e');
    }
  }

  String cryptageData(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  String generateRandomCode() {
    final random = Random();
    const chars = '0123456789';
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments.containsKey('email')) {
      emailController.text = arguments['email'];
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xFF080a16),
          appBar: AppBar(
            backgroundColor: const Color(0xFF080a16),
            title: const Text(
              "Forgot Password",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: ToLogin,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Enter your Email ",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 70,
                    width: 350,
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Email is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: Reset,
                    textButton: 'Send',
                    hb: 50,
                    wb: 250,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
