import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void main() {runApp(MyApp());}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'My App',
      home: WeatherPage(lat:37.7749, lon: -122.4194),
    );
  }
}
class WeatherPage extends StatefulWidget {

  final double lat;
  final double lon;

  WeatherPage({required this.lat, required this.lon});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}
class _WeatherPageState extends State<WeatherPage>{
  Map<String, dynamic>? _weatherData;

  @override
  void initState(){
    super.initState();
    fetchWeatherData();
  }
  Future<void> fetchWeatherData() async{
    final apiKey = '5afd45adeff0949c42ee5430d477a270';
    final baseUrl = 'https://api.openweathermap.org/data/2.5';
    final url = '$baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      setState(() {
        _weatherData = json.decode(response.body);
      });
    }
      else {
        throw Exception('Failed to load weather data');
    }
  }
  @override
  Widget build(BuildContext contex){
    if(_weatherData == null){
      return Scaffold(
        appBar: AppBar(title: Text('Weather'),),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    else {
      final temperature = _weatherData!['main']['temp'];
      final description = _weatherData!['weather'][0]['description'];
      final iconCode = _weatherData!['weather'][0]['icon'];
      final cityName= _weatherData!['name'];
      final countryName = _weatherData!['name'];
      final icomUrl = '';

      return Scaffold(
        appBar: AppBar(title: Text('Weather')),
        body: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('$temperature',style: TextStyle(fontSize: 48),),
                SizedBox(height: 16),
                Image.network((src))
              ],
            ),
          ),
        ),
      );
    }
  }
}