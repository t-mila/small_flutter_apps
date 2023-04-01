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
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>{
  String apiKey = '5afd45adeff0949c42ee5430d477a270';
  String weatherData = '';

  @override
  void initState(){
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.high);
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric'));

    if(response.statusCode == 200){
      var jsonResponse = json.decode(response.body);
      String cityName = jsonResponse['name'];
      double temp = jsonResponse['main']['temp'];
      String weatherDescription = jsonResponse['weather'][0]['description'];

      setState((){
        weatherData = 'City: $cityName \n Temperature: $temp \n Weather" $weatherDescription';
      });
    }
    else{
      setState(() {
        weatherData = 'Connection lost';
      });
    }
  }

  @override
Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            weatherData,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
