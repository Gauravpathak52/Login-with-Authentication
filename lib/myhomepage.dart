import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_login/userdata.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? accesstoken;

  @override
  void initState() {
    super.initState();
    login2();
  }

  Future<void> login2() async {
    var url = Uri.parse('https://dummyjson.com/auth/login');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': 'noahh',
        'password': 'noahhpass',
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        accesstoken = jsonResponse['accessToken'];
      });

      if (accesstoken != null) {
        print('Login successful, Access Token: $accesstoken');
      } else {
        print('Token is null');
      }
    } else {
      print('Login failed: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: accesstoken != null
            ? ElevatedButton(
                child: Text('Fetch User Data'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserDataScreen(accesstoken: accesstoken!),
                    ),
                  );
                },
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
