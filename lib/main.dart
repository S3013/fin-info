
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'home_screen/homeScreen.dart';
void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home:  HomeScreen(),
    );
  }
}
class UserList extends StatefulWidget{

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  final String apiUrl = "https://randomuser.me/api";
  final String DogUrl = 'https://dog.ceo/api/breeds/image/random';

  var dummyImage;

  Future<List<dynamic>> fetchUsers() async {

    var result = await http.get(Uri.parse(apiUrl));

    return json.decode(result.body)['results'];


  }

  Future<void> fetchImage() async {
       final response = await http.get(Uri.parse(DogUrl));

       if (response.statusCode == 200) {
         final jsonResponse = json.decode(response.body);
         dummyImage = jsonResponse['message'];
         print(dummyImage); // Display the message in the console
       } else {
         print('Request failed with status: ${response.statusCode}.');
       }
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

  String _registered(Map<dynamic, dynamic> user){
    return "Age: ${user['dob']['date']}";
  }

  String _registeredDays(Map<dynamic, dynamic> user){

    DateTime age = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').parse(user['registered']['date']);
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(age);
    int days = difference.inDays;

    return "Number of days passed since registered: ${days}";
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
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
                              title: Text(_name(snapshot.data[index])),
                              subtitle: Text(_location(snapshot.data[index])),
                              trailing: Text(_age(snapshot.data[index])),
                            ),
                              Text(_email(snapshot.data[index])),
                              Text(_registeredDays(snapshot.data[index])),
                            
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(dummyImage),
                            )
                          ],

                        ),
                      );
                  });
            }else {
              return Center(child: CircularProgressIndicator());
            }
          },


        ),
      ),
    );
  }
}