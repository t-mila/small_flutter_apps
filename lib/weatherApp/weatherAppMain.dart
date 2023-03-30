import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void main() {runApp(MyApp());}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget{
  @override
  _WEatherPageState createState() => _WeatherPageState();
}

class _WeatherPageSate extends State<WeatherPage>{
  String apiKey = '5afd45adeff0949c42ee5430d477a270';
  String weatherData = '';
}
