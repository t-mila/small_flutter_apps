import 'dart:convert'; //package for encoding and decoding JSON
import 'package:flutter/material.dart'; //material design package
import 'package:http/http.dart' as http; //package for making HTTP requests
import 'package:shared_preferences/shared_preferences.dart'; //package for storing data on device

void main() {
  runApp(MyApp()); //runs the app
}

class MyApp extends StatelessWidget {
  final jokeRepository = JokeRepository(); //creates an instance of JokeRepository

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      home: FutureBuilder<List<Joke>>(
        //displays the jokes in a FutureBuilder
        future: jokeRepository.fetchJokes(),
        //retrieves the jokes from JokeRepository
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //check if the connection is done
            if (snapshot.hasData) {
              //checks if there is data available
              return JokeList(jokes: snapshot.data!); //displays the jokes in JokeList
            } else if (snapshot.hasError) {
              //handles errors
              return Center(child: Text('Error fetching jokes'));
            }
          }
          return Center(child: CircularProgressIndicator()); //displays a loading spinner while the jokes are being loaded
        },
      ),
    );
  }
}

class JokeList extends StatelessWidget {
  final List<Joke> jokes;

  JokeList({required this.jokes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes'),
      ),
      body: ListView.builder(
        itemCount: jokes.length, //sets the number of items to the length of the jokes list
        itemBuilder: (context, index) {
          final joke = jokes[index]; //gets the joke at the current index
          return ListTile(
            title: Text(joke.setup ??
                'Unknown setup'), // Ensure no null values in setup
            subtitle: Text(joke.delivery ??
                'Unknown delivery'), // Ensure no null values in delivery
          );
        },
      ),
    );
  }
}

class Joke {
  final String? setup;
  final String? delivery;

  Joke({required this.setup, required this.delivery});
}

class JokeRepository {
  static const _jokeApiUrl =
      'https://v2.jokeapi.dev/joke/Christmas?blacklistFlags=nsfw,political,racist,sexist,explicit&amount=5'; //url to retrieve jokes from
  static const _jokeCacheKey = 'jokes'; //key for storing jokes in sharedpreferences
  static const _numberOfJokes = 5; //number of jokes to retrieve from the api

  Future<List<Joke>> fetchJokes() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJokesJson = prefs.getString(_jokeCacheKey);

    if (cachedJokesJson != null) {
      final cachedJokes = List<Joke>.from(
        json.decode(cachedJokesJson).map(
              (joke) => Joke(setup: joke['setup'], delivery: joke['delivery']),
        ),
      );
      return cachedJokes;
    }

    List<Joke> jokes = []; //initializes an empty list to hold the jokes

    for (int i = 0; i < _numberOfJokes; i++) { //loops through the API to retrieve jokes
      final response = await http.get(Uri.parse(_jokeApiUrl)); //makes an http get request to retrieve the jokes from the api

      if (response.statusCode == 200) {
        //checks if the response is successful
        final jsonResponse = json.decode(response.body); //decodes the JSON response
        final joke = Joke(
            setup: jsonResponse['setup'], delivery: jsonResponse['delivery']); //creates a new joke object from the json response
        jokes.add(joke); //adds new joke obj to list
      } else {
        throw Exception('Failed to load jokes'); //error check
      }
    }

    final jokesJson = json.encode(jokes
        .map((joke) => {'setup': joke.setup, 'delivery': joke.delivery})
        .toList());
    await prefs.setString(_jokeCacheKey, jokesJson);

    return jokes;
  }
}