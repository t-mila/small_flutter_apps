//importing the necessary packages
import 'package:flutter/material.dart';
//import the geolocatior
import 'package:geolocator/geolocator.dart';

//The main function of the application
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//Defining the state of the application
class _MyAppState extends State<MyApp> {
  //A string to store the location data received
  String _locationData = "";

  //method to initialize the state of the application
  @override
  void initState() {
    super.initState();
    //call a method to get the current location
    _getLocation();
  }

//method to get the current location data
  Future<void> _getLocation() async {
    //requesting the location permission
    LocationPermission permission = await Geolocator.requestPermission();

    //checking if the permission is denied
    if (permission == LocationPermission.denied) {
      setState(() {
        _locationData = 'Permission denied';
      });
      return;
    }

    //Getting the current position with high accuracy
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    //Storing the latitude and longitude values in the locationData string
    setState(() {
      _locationData =
      'Latitude: ${position.latitude}, Longitude:${position.longitude}';
    });
  }

  //building the user interface of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //Adding an app bar with a title
        appBar: AppBar(
          title: Text('Location Example'),
        ),
        body: Center(child: Text(_locationData)),
      ),
    );
  }
}