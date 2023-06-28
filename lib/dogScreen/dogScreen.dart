import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class DogScreen extends StatefulWidget {
  const DogScreen({super.key});

  @override
  State<DogScreen> createState() => _DogScreenState();
}

class _DogScreenState extends State<DogScreen> {


  final String DogUrl = 'https://dog.ceo/api/breeds/image/random';

  String? dummyImage;
  String? imageUrl ='';


  Future<void> fetchImage() async {
    final response = await http.get(Uri.parse(DogUrl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      dummyImage = jsonResponse['message'];
      print(dummyImage);

      setState(() {
        imageUrl = dummyImage; // Update the image URL
      });

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          " Dog Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(imageUrl!),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchImage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.black), // Set the border color
                  ),
                ),
                child: const Text('Refresh'),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
