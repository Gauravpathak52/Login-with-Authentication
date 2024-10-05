import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UserDataScreen extends StatefulWidget {
  final String accesstoken;

  UserDataScreen({required this.accesstoken});

  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  late Future<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData(widget.accesstoken);
  }

  Future<Map<String, dynamic>> fetchUserData(String token) async {
    var url = Uri.parse('https://dummyjson.com/auth/me'); // सही API URL डालें

    var response = await http.get(
      url,
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTMsInVzZXJuYW1lIjoibm9haGgiLCJlbWFpbCI6Im5vYWguaGVybmFuZGV6QHguZHVtbXlqc29uLmNvbSIsImZpcnN0TmFtZSI6Ik5vYWgiLCJsYXN0TmFtZSI6Ikhlcm5hbmRleiIsImdlbmRlciI6Im1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL25vYWhoLzEyOCIsImlhdCI6MTcyODE0NjM1NiwiZXhwIjoxNzI4MTQ5OTU2fQ.eCnARfvzvXVQhIopuSJXM3pzE4YpCUnjfXw-U_Dywt4', // टोकन पास करें
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('User Data')),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var data = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                ListTile(
                  leading: Image.network(data['image']),
                  title: Text('${data['firstName']} ${data['lastName']}'),
                  subtitle: Text(data['email']),
                ),
                Divider(),
                ListTile(
                  title: Text('Username'),
                  subtitle: Text(data['username']),
                ),
                ListTile(
                  title: Text('Phone'),
                  subtitle: Text(data['phone']),
                ),
                ListTile(
                  title: Text('Birth Date'),
                  subtitle: Text(data['birthDate']),
                ),
                ListTile(
                  title: Text('Gender'),
                  subtitle: Text(data['gender']),
                ),
                ListTile(
                  title: Text('Blood Group'),
                  subtitle: Text(data['bloodGroup']),
                ),
                ListTile(
                  title: Text('Height'),
                  subtitle: Text('${data['height']} cm'),
                ),
                ListTile(
                  title: Text('Weight'),
                  subtitle: Text('${data['weight']} kg'),
                ),
                ListTile(
                  title: Text('Eye Color'),
                  subtitle: Text(data['eyeColor']),
                ),
                ListTile(
                  title: Text('Hair Color'),
                  subtitle: Text(data['hair']['color']),
                ),
                ListTile(
                  title: Text('Hair Type'),
                  subtitle: Text(data['hair']['type']),
                ),
                ListTile(
                  title: Text('Address'),
                  subtitle: Text(
                      '${data['address']['address']}, ${data['address']['city']}, ${data['address']['state']} - ${data['address']['postalCode']}'),
                ),
                ListTile(
                  title: Text('University'),
                  subtitle: Text(data['university']),
                ),
                ListTile(
                  title: Text('Company'),
                  subtitle: Text(
                      '${data['company']['name']} (${data['company']['department']}, ${data['company']['title']})'),
                ),
                ListTile(
                  title: Text('Role'),
                  subtitle: Text(data['role']),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
