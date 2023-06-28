import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dogScreen/dogScreen.dart';
import '../profile/profileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final channel = const MethodChannel('com.infocom.fin.flutter_task_native_android');

  final MethodChannel _channel = MethodChannel('bluetooth_channel');

  bool _bluetoothEnabled = false;

  Future<void> _enableBluetooth() async {
    bool enabled;
    try {
      enabled = await _channel.invokeMethod('enableBluetooth');
    } on PlatformException catch (e) {
      print('Error enabling Bluetooth: ${e.message}');
      return;
    }

    setState(() {
      _bluetoothEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const DogScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: const BorderSide(
                        color: Colors.black), // Set the border color
                  ),
                ),
                child: const Text('Random Dog image'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    enableBluetooth();
                    print('Running on Android');
                  } else if (Platform.isIOS) {
                     _enableBluetooth();
                    print('Running on iOS');
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: const BorderSide(
                        color: Colors.black), // Set the border color
                  ),
                ),
                child: const Text('Enable Bluetooth'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ProfileScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: const BorderSide(
                        color: Colors.black), // Set the border color
                  ),
                ),
                child: const Text('Profile'),
              ),


            ],
          ),
        ),
      ),
    );
  }


  Future<void> enableBluetooth() async {
    try {
      await channel.invokeMethod('enableBluetooth');
    } catch (e) {
      print("Failed to enable Bluetooth: ${e}");
    }
  }
}
