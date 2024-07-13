// ignore_for_file: unnecessary_const, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<dynamic> _userData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('ui');

    String server = prefs.getString('server') ?? '192.168.25.30';
    String port = prefs.getString('port') ?? '8000';

    final userUrl = 'http://$server:$port/userappid/$id';

    if (id != null) {
      final response = await http.get(Uri.parse(userUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _userData = data['users'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load user data');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('User ID not found');
    }
  }
  
void _showImageDialog(String base64Image) {
  Uint8List imageBytes = base64Decode(base64Image);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      
      backgroundColor: const Color.fromARGB(255, 30, 32, 45),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Image.memory(imageBytes, fit: BoxFit.contain),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight,
      width: screenWidth,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF080a16),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              surfaceTintColor: const Color(0xFF080a16),
              automaticallyImplyLeading: false,
              title: const Text(
                "History",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color(0xFF080a16),
              centerTitle: true,
            ),
            Expanded(
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : _userData.isEmpty
                        ? const Text(
                            "No history found",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: _userData.length,
                            itemBuilder: (context, index) 
                            {
                              var user = _userData[index];
                              return Card
                              (
                                color: const Color.fromARGB(0, 255, 255, 255),
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder
                                (
                                  side: const BorderSide(color: Colors.deepPurple, width: 2.5),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'User Name:',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            user['user_name'] ?? '',
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Method:',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            user['Methode'] ?? '',
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'License:',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            user['license'] ?? '',
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Device ID:',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            user['deviceId'] ?? '',
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Date:',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            user['date'] ?? '',
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Time:',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            user['time'] ?? '',
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      if (user['Methode'] == 'Camera Action')
                                        GestureDetector(
                                          onTap: () {
                                            if (user['imageData'] != null) {
                                              _showImageDialog(user['imageData']);
                                              debugPrint(user['imageData']);
                                            } else {
                                              debugPrint('No image data available');
                                            }
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 130),
                                            child: Text(
                                              'Show Image',
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ),

                                        if (user['Methode'] == 'Phone Action') 
                                        const Center(
                                          child: Text(
                                            'Opened with Phone',
                                              style: TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
