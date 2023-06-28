import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final String apiUrl = "https://randomuser.me/api";


  Future<List<dynamic>> fetchUsers() async {

    var result = await http.get(Uri.parse(apiUrl));

    return json.decode(result.body)['results'];


  }

  String _name(dynamic user){
    return user['name']['title'] + " " + user['name']['first'] + " " +  user['name']['last'];
  }
  String _email(dynamic user){
    return user['email'];
  }

  String _location(dynamic user){
    return user['location']['country'];
  }

  String _age(Map<dynamic, dynamic> user){
    return "Age: ${user['dob']['age']}";
  }

  String _registeredDays(Map<dynamic, dynamic> user){

    DateTime age = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').parse(user['registered']['date']);
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(age);
    int days = difference.inDays;

    return "Number of days passed since registered: ${days}";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "User List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            print(_age(snapshot.data[0]));
            return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return
                    Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(snapshot.data[index]['picture']['large'])),
                            title: Text("Name : ${_name(snapshot.data[index])}"),
                            subtitle: Text("Location : ${_location(snapshot.data[index])}"),
                            trailing: Text(_age(snapshot.data[index])),
                          ),
                          Text("Email : ${_email(snapshot.data[index])}"),
                          const SizedBox(height: 10,),
                          Text(_registeredDays(snapshot.data[index])),
                        ],

                      ),
                    );
                });
          }else {
            return Center(child: CircularProgressIndicator());
          }
        },


      ),
    );
  }
}
